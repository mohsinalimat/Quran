import Foundation
import UIKit

class PageManager {
    static func setCurrentQuranPage(pageURL: String) {
        ApplicationObject.QuranPageImageView.image = UIImage(contentsOfFile: pageURL)
        
        AyatSelectionManager.generateAyatSelectionForCurrentPage()
    }
    static func showQuranPage(scriptId: Int64, pageId: Int64) {
        if pageId > 0 {
            ApplicationObject.QuranPageImageView.image = nil
            
            RecitationManager.setPlayerMode(mode: .None)
            ApplicationMethods.setCurrentPageData(selectedScriptId: scriptId, selectedPageId: pageId)
            ApplicationObject.QuranPageImageView.layer.sublayers?.removeAll()
            
            let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getPagePath(scriptId: scriptId, pageId: pageId))
            
            if fileURL == "" {
                ApplicationData.CurrentDownloadPageMode = DownloadPageMode.Confirm.hashValue
                ApplicationData.CurrentDownloadMode = .Script
                
                ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueDownloadPage", sender: nil)
            }
            else {
                setCurrentQuranPage(pageURL: fileURL)
                
                if ApplicationData.AssignmentModeOn {
                    let startAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId
                    let endAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].EndPoint[0].AyatId
                    let startAyatObject = AyatRepository().getAyat(Id: startAyatId)
                    let endAyatObject = AyatRepository().getAyat(Id: endAyatId)
                    let recitationObjectList = RecitationRepository().getRecitationList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId, fromAyatOrderId: startAyatObject.AyatOrder, toAyatOrderId: endAyatObject.AyatOrder)
                    
                    AyatSelectionManager.highlightAyatSelectionRange(recitationList: recitationObjectList)
                    AyatSelectionManager.generateShowAssignmentBoundary()
                }
            }
        }
        
        ApplicationObject.MainViewController.hideMenu()
    }
}
