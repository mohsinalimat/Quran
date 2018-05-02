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
    static func getCurrentStudentAssignmentRecordingPath() -> String {
        var recordingName = String(ApplicationData.CurrentAssignment.CourseInfoId!) + "_" + String(ApplicationData.CurrentAssignment.StudentId) + "_" + String(ApplicationData.CurrentAssignment.classAssignmentStudentId)
        
        if ApplicationData.CurrentAssignment.Correction.count > 0 {
            recordingName += "_" + String(ApplicationData.CurrentAssignment.Correction[0].Id)
        }
        
        recordingName += ".m4a"
        
        return DirectoryStructure.StudentAssignmentRecording + recordingName
    }
}
