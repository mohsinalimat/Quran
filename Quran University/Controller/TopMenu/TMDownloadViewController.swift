import UIKit

class TMDownloadViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func downloadBook(currentDownloadBookMode: DownloadBookMode) {
        ApplicationData.CurrentDownloadBookMode = currentDownloadBookMode
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
            ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueDownloadBook", sender: nil)
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnScriptDownload_TouchUp(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
            ApplicationData.CurrentDownloadMode = .Script
            ApplicationData.CurrentDownloadCategoryMode = .Page
            ApplicationData.CurrentDownloadPageMode = DownloadPageMode.Download.hashValue
            
            ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueDownloadPage", sender: nil)
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnRecitationDownload_TouchUp(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
            ApplicationData.CurrentDownloadMode = .Audio
            ApplicationData.CurrentDownloadCategoryMode = .Page
            ApplicationData.CurrentDownloadPageMode = DownloadPageMode.Download.hashValue
            
            ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueDownloadPage", sender: nil)
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnTranslationDownload_TouchUp(_ sender: Any) {
        downloadBook(currentDownloadBookMode: .Translation)
    }
    @IBAction func btnTafseerDownload_TouchUp(_ sender: Any) {
        downloadBook(currentDownloadBookMode: .Tafseer)
    }
    @IBAction func btnWordMeaning_TouchUp(_ sender: Any) {
        downloadBook(currentDownloadBookMode: .WordMeaning)
    }
    @IBAction func btnCauseOfRevelation_TouchUp(_ sender: Any) {
        downloadBook(currentDownloadBookMode: .CauseOfRevelation)
    }
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
