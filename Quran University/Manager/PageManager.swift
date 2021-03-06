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
            AyatSelectionManager.removeAyatSelection()
            
            let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getPagePath(scriptId: scriptId, pageId: pageId))
            
            if fileURL == "" {
                ApplicationData.CurrentDownloadPageMode = DownloadPageMode.Confirm.hashValue
                ApplicationData.CurrentDownloadMode = .Script
                
                ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueDownloadPage", sender: nil)
            }
            else {
                setCurrentQuranPage(pageURL: fileURL)
                
                if ApplicationData.AssignmentModeOn {
                    AssignmentManager.highlightAssignment()
                    RecitationManager.setPlayerMode(mode: .Ready)
                }
            }
        }
        
        ApplicationObject.MainViewController.hideMenu()
    }
}
