import Foundation
import UIKit

class ApplicationMethods {
    static func setCurrentPageData(selectedScriptId: Int64, selectedPageId: Int64) {
        ApplicationData.CurrentScript = ScriptRepository().getScript(Id: selectedScriptId)
        ApplicationData.CurrentPage = PageRepository().getPage(Id: selectedPageId)
        ApplicationData.CurrentSurah = SurahRepository().getLastSurah(pageId: selectedPageId)
        ApplicationData.CurrentJuzz = JuzzRepository().getLastJuzz(pageId: selectedPageId)
        ApplicationData.CurrentPageGroup = PageRepository().getPageGroup(pageId: selectedPageId)
        
        ApplicationObject.SurahButton.setTitle(ApplicationData.CurrentSurah.Name, for: .normal)
        ApplicationObject.PageButton.setTitle(ApplicationData.CurrentPage.Name, for: .normal)
        ApplicationObject.JuzzButton.setTitle(ApplicationData.CurrentJuzz.Name, for: .normal)
    }
    static func showSetting() {
        if let settingUrl = URL(string: UIApplicationOpenSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingUrl) {
                UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func getScriptPath(scriptId: Int64) -> String {
        return DirectoryStructure.Script + String(scriptId)
    }
    static func getReciterPath(reciterId: Int64) -> String {
        return DirectoryStructure.Audio + String(reciterId)
    }
    static func getPageName(pageId: Int64) -> String {
        return String(pageId) + ApplicationConstant.QuranPageType
    }
    static func getPagePath(scriptId: Int64, pageId: Int64) -> String {
        return DirectoryStructure.Script + String(scriptId) + "/" + getPageName(pageId: pageId)
    }
    static func getPageURL(scriptId: Int64, pageId: Int64) -> String {
        return QuranLink.Script + String(scriptId) + "/" + getPageName(pageId: pageId)
    }
    static func getRecitationName(surahId: Int64, ayatOrderId: Int64) -> String {
        var recitationName = ""
        
        if surahId < 10 {
            recitationName = "00" + String(surahId)
        }
        else if surahId < 100 {
            recitationName = "0" + String(surahId)
        }
        else {
            recitationName = String(surahId)
        }
        
        if ayatOrderId < 10 {
            recitationName = recitationName + "00" + String(ayatOrderId)
        }
        else if ayatOrderId < 100 {
            recitationName = recitationName + "0" + String(ayatOrderId)
        }
        else {
            recitationName = recitationName + String(ayatOrderId)
        }
        
        return (recitationName + ApplicationConstant.QuranRecitationType)
    }
    static func getSurahName(surahId: Int64) -> String {
        var surahName = ""
        
        if surahId < 10 {
            surahName = "00" + String(surahId)
        }
        else if surahId < 100 {
            surahName = "0" + String(surahId)
        }
        else {
            surahName = String(surahId)
        }
        
        return surahName
    }
    static func getRecitationPath(reciterId: Int64, recitationName: String) -> String {
        return DirectoryStructure.Audio + String(reciterId) + "/" + recitationName
    }
    static func getRecitationURL(reciterId: Int64, surahId: Int64, recitationName: String) -> String {
        if reciterId == 1 {
            return QuranLink.Audio + recitationName
        }
        else {
            return QuranLink.Audio + String(reciterId) + "/" + getSurahName(surahId: surahId) + "/" + recitationName
        }
    }
    static func getRecitationRecordingPath(currentRecitationIndex: Int) -> String {
        let recordingName = RecitationManager.getRecitationName(recitationIndex: currentRecitationIndex).replacingOccurrences(of: ".mp3", with: ".m4a")
        
        return DirectoryStructure.TempRecordingRecitation + recordingName
    }
    static func getRecitaion(recitationLabel: String) -> Recitation {
        let sRange = recitationLabel.index(recitationLabel.startIndex, offsetBy: 0)..<recitationLabel.index(recitationLabel.endIndex, offsetBy: -7)
        let aRange = recitationLabel.index(recitationLabel.startIndex, offsetBy: 3)..<recitationLabel.index(recitationLabel.endIndex, offsetBy: -4)
        let surahId = Int64(recitationLabel[sRange])
        let ayatOrder = Int64(recitationLabel[aRange])
        let recitationObject = RecitationRepository().getRecitation(surahId: surahId!, ayatOrder: ayatOrder!)
        
        return recitationObject
    }
    static func getCurrentStudentAssignmentRecordingName() -> String {
        var recordingName = ""
        
        if ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Accepted.rawValue ||
            ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Submitted.rawValue ||
            ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Resubmitted.rawValue {
            recordingName = ApplicationData.CurrentAssignment.StudentAudioFile!
            
            if ApplicationData.CurrentAssignment.Correction.count > 0 {
                recordingName = ApplicationData.CurrentAssignment.Correction[0].StudentAudioFile!
            }
        }
        else {
            recordingName = String(ApplicationData.CurrentAssignment.CourseInfoId!) + "_" + String(ApplicationData.CurrentAssignment.StudentId) + "_" + String(ApplicationData.CurrentAssignment.classAssignmentStudentId)
            
            if ApplicationData.CurrentAssignment.Correction.count > 0 {
                recordingName += "_" + String(ApplicationData.CurrentAssignment.Correction[0].Id)
            }
            
            recordingName += ".m4a"
        }
        
        return recordingName
    }
    static func getCurrentStudentAssignmentRecordingPath() -> String {
        return DirectoryStructure.StudentAssignmentRecording + getCurrentStudentAssignmentRecordingName()
    }
    static func getCurrentStudentAssignmentRecording() -> Data {
        let targetFileURL = DocumentManager.documentsDirectory.appendingPathComponent(getCurrentStudentAssignmentRecordingPath())
        let contents: Data
        
        do {
            contents = try Data(contentsOf: targetFileURL)
        }
        catch {
            fatalError("No \(getCurrentStudentAssignmentRecordingPath()) file found in application.")
        }
        
        return contents
    }
    static func getCurrentStudentAssignmentRecordingWebUrl() -> String {
        return QuranLink.StudentAssignmentUrl + getCurrentStudentAssignmentRecordingName()
    }
    static func getOrdinalNumber(num: Int32) -> String {
        var numString = String(num)
        
        if num > 0 {
            if num > 10 && num < 21 {
                numString = numString + "th"
            }
            else {
                switch num % 10 {
                case 1:
                    numString = numString + "st"
                    
                    break
                case 2:
                    numString = numString + "nd"
                    
                    break
                case 3:
                    numString = numString + "rd"
                    
                    break
                default:
                    numString = numString + "th"
                    
                    break
                }
            }
        }
        else {
            numString = ""
        }
        
        return numString
    }
    static func getStudentAssignmentMediaPath(mediaName: String) -> String {
        return DirectoryStructure.StudentAssignmentRecording + mediaName
    }
    static func getStudentAssignmentRecordingWebUrl(mediaName: String) -> String {
        return QuranLink.StudentAssignmentUrl + mediaName
    }
    static func getTeacherAssignmentMediaPath(mediaName: String) -> String {
        return DirectoryStructure.TeacherAssignmentRecording + mediaName
    }
    static func getTeacherAssignmentRecordingWebUrl(mediaName: String) -> String {
        return QuranLink.TeacherAssignmentUrl + mediaName
    }
    static func getCorrectionBGColor(number: Int32) -> UIColor {
        var correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
        
        switch number {
        case 1:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 2:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 3:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 4:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 5:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 6:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 7:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 8:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 9:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 10:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 11:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 12:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 13:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 14:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        case 15:
            correctionBGColor = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
            
            break
        default:
            break
        }
        
        return correctionBGColor
    }
    static func getCorrectionBColor(number: Int32) -> UIColor {
        var correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
        
        switch number {
        case 1:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 2:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 3:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 4:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 5:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 6:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 7:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 8:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 9:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 10:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 11:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 12:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 13:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 14:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        case 15:
            correctionBColor = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
            
            break
        default:
            break
        }
        
        return correctionBColor
    }
}
