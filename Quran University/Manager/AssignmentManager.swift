import Foundation
import UIKit

class AssignmentManager {
    typealias methodHandler1 = () -> Void
    
    static var assignmentList = [AssignmentModel]()
    static var assignmentStatusList = [AssignmentStatus]()
    static var jResponse = JsonResponse()
    static var dataTask: URLSessionDataTask?
    
    static func populateStudentAssignment(completionHandler: @escaping methodHandler1) {
        if assignmentList.count <= 0 {
            dataTask = URLSession.shared.dataTask(with: QuranLink.Assignment()) { (data, response, err) in
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
        var filterAssignmentList = [AssignmentModel]()
        
        for objCourse in jResponse.Course! {
            for objAssignment in objCourse.Assignment! {
                var assignmentStatus = AssignmentStatus.Accepted
                var assignmentStatusString = ApplicationLabel.ACCEPTED
                
                objAssignment.Correction.sort(by: { $0.Id < $1.Id }) // .sort(sort_by('Id', false, parseInt)
                
                if objAssignment.IsMarked {
                    assignmentStatusString = ApplicationLabel.ACCEPTED
                    assignmentStatus = AssignmentStatus.Accepted
                }
                else if !objAssignment.IsMarked {
                    if objAssignment.StudentOnlineSubmissionDate == nil && objAssignment.StudentSubmissionDate == nil {
                        if Utilities.dtJsonDateTime.date(from: objAssignment.DeadlineDate)! < Date() {
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
                            let latestCorrection = objAssignment.Correction[objAssignment.Correction.count - 1];
                            
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
                                if latestCorrection.StudentOnlineSubmissionDate != nil {
                                    assignmentStatusString = ApplicationLabel.RESUBMITTED
                                    assignmentStatus = AssignmentStatus.Resubmitted
                                }
                                else if latestCorrection.StudentOnlineSubmissionDate == nil {
                                    assignmentStatusString = ApplicationLabel.RECHECKED
                                    assignmentStatus = AssignmentStatus.Rechecked
                                }
                            }
                        }
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
                    objAssignment.DeadlineDateValue = Utilities.dtJsonDateTime.date(from: objAssignment.DeadlineDate)
                    objAssignment.CourseTitle = objCourse.Title
                    
                    objAssignment.Correction.sort(by: { $0.Id > $1.Id }) // sort_by('Id', true, parseInt)
                    
                    filterAssignmentList.append(objAssignment)
                }
            }
        }
        
        assignmentList = filterAssignmentList.sorted(by: { ($0.DeadlineDateValue!, $0.Id) > ($1.DeadlineDateValue!, $1.Id) }) // sort_by('DeadlineDateValue', true)
        
        var count = assignmentList.count
        
        for objAssignment in assignmentList {
            objAssignment.Number = count > 9 ? String(count) : ("0" + String(count))
            count = count - 1
        }
    }
}
