import Foundation
import UIKit
import Alamofire

class AssignmentManager {
    typealias methodHandler1 = () -> Void
    typealias methodHandler2 = (_ status: Bool) -> Void
    
    static var pvFileProgressView = UIProgressView()
    static var assignmentList = [AssignmentModel]()
    static var assignmentStatusList = [AssignmentStatus]()
    static var jResponse = JsonResponse()
    static var dataTask: URLSessionDataTask?
    
    static func populateStudentAssignment(completionHandler: @escaping methodHandler1) {
        if assignmentList.count <= 0 {
            dataTask = URLSession.shared.dataTask(with: QuranLink.GetAssignment()) { (data, response, err) in
                let response = response as? HTTPURLResponse
                
                if err == nil && response?.statusCode == 200 {
                    do {
//                        let jsonString = String(data: data!, encoding: .utf8)
                        jResponse = try JSONDecoder().decode(JsonResponse.self, from: data!)
                        
                        populateFilteredAssignment(applyFilter: false)
                    }
                    catch {
                        print("Error: \(error).")
                    }
                }
                
                completionHandler()
            }
            
            dataTask?.resume()
        }
        else {
            populateFilteredAssignment(applyFilter: false)
            completionHandler()
        }
    }
    static func populateFilteredAssignment(applyFilter: Bool) {
        let studentAssignmentRecordingList = StudentAssignmentRecordingRepository().getStudentAssignmentRecordingList()
        var filterAssignmentList = [AssignmentModel]()
        
        for objCourse in jResponse.Course! {
            for objAssignment in objCourse.Assignment! {
                var assignmentStatus = AssignmentStatus.Accepted
                var assignmentStatusString = ApplicationLabel.ACCEPTED
                var recordingExists = false
                
                objAssignment.Correction.sort(by: { $0.Id > $1.Id })
                
                if objAssignment.IsMarked {
                    assignmentStatusString = ApplicationLabel.ACCEPTED
                    assignmentStatus = AssignmentStatus.Accepted
                }
                else if !objAssignment.IsMarked {
                    if objAssignment.StudentOnlineSubmissionDate == nil && objAssignment.StudentSubmissionDate == nil {
                        if Int64(objAssignment.DelayedDays)! > 0 {
                            assignmentStatusString = ApplicationLabel.LATE
                            assignmentStatus = AssignmentStatus.Late
                        }
                        else {
                            assignmentStatusString = ApplicationLabel.DUE
                            assignmentStatus = AssignmentStatus.Due
                        }
                    }
                    else if objAssignment.StudentOnlineSubmissionDate == nil && objAssignment.StudentSubmissionDate != nil {
                        assignmentStatusString = ApplicationLabel.NOTSENT
                        assignmentStatus = AssignmentStatus.NotSent
                    }
                    else if objAssignment.StudentOnlineSubmissionDate != nil && objAssignment.StudentSubmissionDate != nil {
                        if objAssignment.Correction.count == 0 {
                            assignmentStatusString = ApplicationLabel.SUBMITTED
                            assignmentStatus = AssignmentStatus.Submitted
                        }
                        else if objAssignment.Correction.count > 0 {
                            if objAssignment.Correction.count == 1 {
                                if objAssignment.Correction[0].StudentOnlineSubmissionDate == nil {
                                    assignmentStatusString = ApplicationLabel.CHECKED
                                    assignmentStatus = AssignmentStatus.Checked
                                }
                                else if objAssignment.Correction[0].StudentOnlineSubmissionDate != nil {
                                    assignmentStatusString = ApplicationLabel.RESUBMITTED
                                    assignmentStatus = AssignmentStatus.Resubmitted
                                }
                            }
                            else if objAssignment.Correction.count > 1 {
                                if objAssignment.Correction[0].StudentOnlineSubmissionDate != nil {
                                    assignmentStatusString = ApplicationLabel.RESUBMITTED
                                    assignmentStatus = AssignmentStatus.Resubmitted
                                }
                                else if objAssignment.Correction[0].StudentOnlineSubmissionDate == nil {
                                    assignmentStatusString = ApplicationLabel.RECHECKED
                                    assignmentStatus = AssignmentStatus.Rechecked
                                }
                            }
                        }
                    }
                }
                
                if !(assignmentStatus == AssignmentStatus.Accepted ||
                    assignmentStatus == AssignmentStatus.Submitted ||
                    assignmentStatus == AssignmentStatus.Resubmitted) {
                    studentAssignmentRecordingList.lazy.filter { $0.Id == objAssignment.Id }.forEach { objStudentAssignmentRecording in
                        recordingExists = true
                    }
                    
                    if recordingExists {
                        assignmentStatusString = ApplicationLabel.NOTSENT
                        assignmentStatus = AssignmentStatus.NotSent
                    }
                }
                
                var addRow = true
                
                if applyFilter {
                    if assignmentStatusList.count > 0 {
                        addRow = false
                        
                        for objAssignmentStatus in assignmentStatusList {
                            if assignmentStatus == objAssignmentStatus {
                                addRow = true
                            }
                        }
                    }
                }
                
                if addRow {
                    objAssignment.AssignmentStatusTitle = assignmentStatusString
                    objAssignment.AssignmentStatusId = assignmentStatus.rawValue
                    objAssignment.CourseInfoId = objCourse.CourseInfoId
                    objAssignment.CourseTitle = objCourse.Title
                    objAssignment.RecordingExists = recordingExists
                    
                    filterAssignmentList.append(objAssignment)
                }
            }
        }
        
        assignmentList = filterAssignmentList.sorted(by: { ($0.Deadline, $0.Id) > ($1.Deadline, $1.Id) })
        
        var count = assignmentList.count
        
        for objAssignment in assignmentList {
            objAssignment.Number = count > 9 ? String(count) : ("0" + String(count))
            count = count - 1
        }
    }
    static func loadAssignmentMode(Id: Int64, completionHandler: @escaping methodHandler1) {
        unloadAssignment(completionHandler: {
            ApplicationData.AssignmentModeOn = true
            
            AssignmentManager.assignmentList.filter { $0.Id == Id }.forEach { objAssignment in
                ApplicationData.CurrentAssignment = objAssignment
            }
            
            ApplicationObject.CurrentViewController.dismiss(animated: true, completion: {
                let ayatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId
                let pageObject = PageRepository().getFirstPage(ayatId: ayatId)
                
                ApplicationData.CurrentSurah = SurahRepository().getSurah(ayatId: ayatId)
                
                ApplicationObject.SurahButton.setTitle(ApplicationData.CurrentSurah.Name, for: .normal)
                PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageObject.Id)
                ApplicationObject.MainViewController.btnLMenu.setImage(#imageLiteral(resourceName: "img_LeftAssignmentLinesCircle"), for: .normal)
                ApplicationObject.MainViewController.showHideMenu(tag: ViewTag.BaseLeftMenu.rawValue)
                completionHandler()
            })
        })
    }
    static func unloadAssignmentMode(completionHandler: @escaping methodHandler1) {
        if ApplicationData.AssignmentModeOn {
            DialogueManager.showConfirmation(viewController: ApplicationObject.CurrentViewController, message: ApplicationConfirmMessage.TURN_OFF_ASSIGNMENT_MODE, yesHandler: {
                unloadAssignment(completionHandler: completionHandler)
            })
        }
        else {
            completionHandler()
        }
    }
    static func unloadAssignment(completionHandler: @escaping methodHandler1) {
        ApplicationData.AssignmentModeOn = false
        
        AyatSelectionManager.hideAyatSelection()
        AyatSelectionManager.removeAssignmentBoundary()
        ApplicationObject.MainViewController.btnLMenu.setImage(#imageLiteral(resourceName: "img_LeftAssignmentPlainCircle"), for: .normal)
        ApplicationObject.MainViewController.hideMenu()
        ApplicationObject.MainViewController.setFooterMode(currentFooterSectionMode: .Player, enableQuranPageUserInteraction: true)
        
        completionHandler()
    }
    static func submitAssignment(uiProgressView: UIProgressView, completionHandler: @escaping methodHandler2) {
        let progressFactor: Float = (1 / 3)
        
        pvFileProgressView = uiProgressView
        pvFileProgressView.progress = 0
        
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(ApplicationMethods.getCurrentStudentAssignmentRecording(),
                                         withName: "audio",
                                         fileName: ApplicationMethods.getCurrentStudentAssignmentRecordingName(),
                                         mimeType: "audio/m4a")
                },
                to: QuranLink.UploadAssignment(),
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.uploadProgress { progress in
                            pvFileProgressView.progress = Float(progress.fractionCompleted) * progressFactor
                        }
                        
                        upload.validate()
                        
                        upload.responseJSON { response in
                            let jsonContent = """
                            {
                            "ClassAssignmentStudentId": \(ApplicationData.CurrentAssignment.classAssignmentStudentId),
                            "StudentSubmissionDate": "\(Utilities.dtJsonDateTime.string(from: Date()))",
                            "StudentOnlineSubmissionDate": "\(Utilities.dtJsonDateTime.string(from: Date()))",
                            "StudentAudioFile": "\(ApplicationMethods.getCurrentStudentAssignmentRecordingName())",
                            "Iscorrection": \(ApplicationData.CurrentAssignment.Correction.count > 0 ? 1 : 0)
                            }
                            """
                            let dataTask = URLSession.shared.dataTask(with: QuranLink.SubmitAssignment(jsonContent: jsonContent)) { (data, response, err) in
                                let response = response as? HTTPURLResponse
                                
                                DispatchQueue.main.async {
                                    pvFileProgressView.progress = pvFileProgressView.progress + progressFactor
                                }
                                
                                if err == nil && response?.statusCode == 200 {
                                    do {
                                        //                            let jsonString = String(data: data!, encoding: .utf8)
                                        let jResponse = try JSONDecoder().decode(JsonResponse.self, from: data!)
                                        
                                        if jResponse.Status == 2 {
                                            assignmentList.removeAll()
                                            
                                            populateStudentAssignment(completionHandler: {
                                                DispatchQueue.main.async {
                                                    pvFileProgressView.progress = pvFileProgressView.progress + progressFactor
                                                }
                                                
                                                AssignmentManager.assignmentList.filter { $0.Id == ApplicationData.CurrentAssignment.Id }.forEach { objAssignment in
                                                    ApplicationData.CurrentAssignment = objAssignment
                                                }
                                                
                                                completionHandler(true)
                                            })
                                        }
                                        else {
                                            completionHandler(false)
                                        }
                                    }
                                    catch {
                                        completionHandler(false)
                                    }
                                }
                                else {
                                    completionHandler(false)
                                }
                            }
                            
                            dataTask.resume()
                        }
                    case .failure( _):
                        completionHandler(false)
                }
            })
    }
    static func highlightAssignment() {
        let startAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId
        let endAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].EndPoint[0].AyatId
        let startAyatObject = AyatRepository().getAyat(Id: startAyatId)
        let endAyatObject = AyatRepository().getAyat(Id: endAyatId)
        let recitationObjectList = RecitationRepository().getRecitationList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId, fromAyatOrderId: startAyatObject.AyatOrder, toAyatOrderId: endAyatObject.AyatOrder)
        
        AyatSelectionManager.highlightAyatSelectionRange(recitationList: recitationObjectList)
        AyatSelectionManager.generateBoundaryForCurrentAssignment()
    }
    static func markAssignment() {
        let startAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId
        let endAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].EndPoint[0].AyatId
        let startAyatObject = AyatRepository().getAyat(Id: startAyatId)
        let endAyatObject = AyatRepository().getAyat(Id: endAyatId)
        let recitationObjectList = RecitationRepository().getRecitationList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId, fromAyatOrderId: startAyatObject.AyatOrder, toAyatOrderId: endAyatObject.AyatOrder)
        
        AyatSelectionManager.markAyatSelectionRange(recitationList: recitationObjectList)
    }
    static func downloadAssignment(completionHandler: @escaping methodHandler2) {
        Alamofire
            .request(ApplicationMethods.getCurrentStudentAssignmentRecordingWebUrl())
            .validate()
            .responseData(completionHandler: { (response) in
                var status = false
                
                if response.result.isSuccess {
                    if let data = response.result.value {
                        let createdFileURL = DocumentManager.createFileInApplicationDirectory(contents: data, targetFilePath: ApplicationMethods.getCurrentStudentAssignmentRecordingPath())
                        
                        if createdFileURL != "" {
                            status = true
                        }
                    }
                }
                
                completionHandler(status)
            })
    }
    static func cancelDownloadUploadAssignment() {
        let sessionManager = Alamofire.SessionManager.default
        
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            downloadTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            dataTasks.forEach { $0.cancel() }
        }
    }
    
    static func assignmentRecordingExist() -> Bool {
        let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getCurrentStudentAssignmentRecordingPath())
        var recordingExist = true
        
        if fileURL == "" {
            recordingExist = false
        }
        
        return recordingExist
    }
}
