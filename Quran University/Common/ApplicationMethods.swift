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
    static func getCorrectionBColor(number: Int32) -> UIColor {
        var correctionColor = UIColor(red: 96.0/255, green: 125.0/255, blue: 139.0/255, alpha: 1.0)
        
        switch number {
        case 1:
            correctionColor = UIColor(red: 244.0/255, green: 67.0/255, blue: 54.0/255, alpha: 1.0)
            
            break
        case 2:
            correctionColor = UIColor(red: 233.0/255, green: 30.0/255, blue: 99.0/255, alpha: 1.0)
            
            break
        case 3:
            correctionColor = UIColor(red: 156.0/255, green: 39.0/255, blue: 176.0/255, alpha: 1.0)
            
            break
        case 4:
            correctionColor = UIColor(red: 103.0/255, green: 58.0/255, blue: 183.0/255, alpha: 1.0)
            
            break
        case 5:
            correctionColor = UIColor(red: 63.0/255, green: 81.0/255, blue: 181.0/255, alpha: 1.0)
            
            break
        case 6:
            correctionColor = UIColor(red: 33.0/255, green: 150.0/255, blue: 243.0/255, alpha: 1.0)
            
            break
        case 7:
            correctionColor = UIColor(red: 3.0/255, green: 169.0/255, blue: 244.0/255, alpha: 1.0)
            
            break
        case 8:
            correctionColor = UIColor(red: 0.0/255, green: 188.0/255, blue: 212.0/255, alpha: 1.0)
            
            break
        case 9:
            correctionColor = UIColor(red: 0.0/255, green: 150.0/255, blue: 136.0/255, alpha: 1.0)
            
            break
        case 10:
            correctionColor = UIColor(red: 76.0/255, green: 175.0/255, blue: 80.0/255, alpha: 1.0)
            
            break
        case 11:
            correctionColor = UIColor(red: 139.0/255, green: 195.0/255, blue: 74.0/255, alpha: 1.0)
            
            break
        case 12:
            correctionColor = UIColor(red: 205.0/255, green: 220.0/255, blue: 57.0/255, alpha: 1.0)
            
            break
        case 13:
            correctionColor = UIColor(red: 255.0/255, green: 235.0/255, blue: 59.0/255, alpha: 1.0)
            
            break
        case 14:
            correctionColor = UIColor(red: 255.0/255, green: 193.0/255, blue: 7.0/255, alpha: 1.0)
            
            break
        case 15:
            correctionColor = UIColor(red: 255.0/255, green: 152.0/255, blue: 0.0/255, alpha: 1.0)
            
            break
        case 16:
            correctionColor = UIColor(red: 255.0/255, green: 87.0/255, blue: 34.0/255, alpha: 1.0)
            
            break
        case 17:
            correctionColor = UIColor(red: 121.0/255, green: 85.0/255, blue: 72.0/255, alpha: 1.0)
            
            break
        case 18:
            correctionColor = UIColor(red: 158.0/255, green: 158.0/255, blue: 158.0/255, alpha: 1.0)
            
            break
        default:
            break
        }
        
        return correctionColor
    }
    static func getCorrectionBGColor(number: Int32) -> UIColor {
        var correctionColor = UIColor(red: 176.0/255, green: 190.0/255, blue: 197.0/255, alpha: 1.0)
        
        switch number {
        case 1:
            correctionColor = UIColor(red: 239.0/255, green: 154.0/255, blue: 154.0/255, alpha: 1.0)
            
            break
        case 2:
            correctionColor = UIColor(red: 244.0/255, green: 143.0/255, blue: 177.0/255, alpha: 1.0)
            
            break
        case 3:
            correctionColor = UIColor(red: 206.0/255, green: 147.0/255, blue: 216.0/255, alpha: 1.0)
            
            break
        case 4:
            correctionColor = UIColor(red: 179.0/255, green: 157.0/255, blue: 219.0/255, alpha: 1.0)
            
            break
        case 5:
            correctionColor = UIColor(red: 159.0/255, green: 168.0/255, blue: 218.0/255, alpha: 1.0)
            
            break
        case 6:
            correctionColor = UIColor(red: 144.0/255, green: 202.0/255, blue: 249.0/255, alpha: 1.0)
            
            break
        case 7:
            correctionColor = UIColor(red: 129.0/255, green: 212.0/255, blue: 250.0/255, alpha: 1.0)
            
            break
        case 8:
            correctionColor = UIColor(red: 128.0/255, green: 222.0/255, blue: 234.0/255, alpha: 1.0)
            
            break
        case 9:
            correctionColor = UIColor(red: 128.0/255, green: 203.0/255, blue: 196.0/255, alpha: 1.0)
            
            break
        case 10:
            correctionColor = UIColor(red: 165.0/255, green: 214.0/255, blue: 167.0/255, alpha: 1.0)
            
            break
        case 11:
            correctionColor = UIColor(red: 197.0/255, green: 225.0/255, blue: 165.0/255, alpha: 1.0)
            
            break
        case 12:
            correctionColor = UIColor(red: 230.0/255, green: 238.0/255, blue: 156.0/255, alpha: 1.0)
            
            break
        case 13:
            correctionColor = UIColor(red: 255.0/255, green: 249.0/255, blue: 196.0/255, alpha: 1.0)
            
            break
        case 14:
            correctionColor = UIColor(red: 255.0/255, green: 236.0/255, blue: 179.0/255, alpha: 1.0)
            
            break
        case 15:
            correctionColor = UIColor(red: 255.0/255, green: 204.0/255, blue: 128.0/255, alpha: 1.0)
            
            break
        case 16:
            correctionColor = UIColor(red: 255.0/255, green: 171.0/255, blue: 145.0/255, alpha: 1.0)
            
            break
        case 17:
            correctionColor = UIColor(red: 188.0/255, green: 170.0/255, blue: 164.0/255, alpha: 1.0)
            
            break
        case 18:
            correctionColor = UIColor(red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1.0)
            
            break
        default:
            break
        }
        
        return correctionColor
    }
}
