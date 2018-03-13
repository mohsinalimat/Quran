import Foundation
import UIKit

class PageManager {
    static func setCurrentQuranPage(pageURL: String) {
        ApplicationObject.QuranPageImageView.image = UIImage(contentsOfFile: pageURL)
        
        AyatSelectionManager.generateAyatSelectionForCurrentPage()
        
        for objAyatSelection in AyatSelectionManager.ayatSelectionList {
            ApplicationObject.QuranPageImageView.layer.addSublayer(objAyatSelection)
        }
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
            }
        }
    }
}
