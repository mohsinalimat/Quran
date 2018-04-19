import UIKit

class DPConfirmViewController: BaseViewController {
    @IBOutlet weak var lblMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch ApplicationData.CurrentDownloadMode {
        case .Audio:
            lblMessage.text = ApplicationInfoMessage.DEFAULT_RECITER_RECITATION_NOT_AVAILABLE + "\r\n" + ApplicationInfoMessage.WANT_TO_DOWNLOAD
            
            break
        case .Script:
            lblMessage.text = ApplicationInfoMessage.PAGE_SURAH_JUZZ_NOT_AVAILABLE + "\n" + ApplicationInfoMessage.WANT_TO_DOWNLOAD
            
            break
        }
    }
    
    @IBAction func btnYes_TouchUp(_ sender: Any) {
        tabBarController?.selectedIndex = DownloadPageMode.Option.hashValue
    }
    @IBAction func btnNo_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if ApplicationData.AssignmentModeOn {
                AssignmentManager.populateStudentAssignment(completionHandler: {
                    DispatchQueue.main.async {
                        ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueAssignment", sender: nil)
                    }
                })
            }
        })
    }
}
