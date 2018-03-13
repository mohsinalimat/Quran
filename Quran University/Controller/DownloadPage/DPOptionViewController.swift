import UIKit
import DLRadioButton

class DPOptionViewController: BaseViewController {
    @IBOutlet weak var rbtnPage: DLRadioButton!
    @IBOutlet weak var rbtnSurah: DLRadioButton!
    @IBOutlet weak var rbtnJuzz: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch ApplicationData.CurrentDownloadCategoryMode {
        case .Surah:
            rbtnSurah.isSelected = true
            
            break
        case .Page:
            rbtnPage.isSelected = true
            
            break
        case .Juzz:
            rbtnJuzz.isSelected = true
            
            break
        default:
            break
        }
    }
    
    @IBAction func btnYes_TouchUp(_ sender: Any) {
        if rbtnSurah.isSelected == true {
            ApplicationData.CurrentDownloadCategoryMode = .Surah
        }
        else if rbtnPage.isSelected == true {
            ApplicationData.CurrentDownloadCategoryMode = .Page
        }
        else if rbtnJuzz.isSelected == true {
            ApplicationData.CurrentDownloadCategoryMode = .Juzz
        }
        
        tabBarController?.selectedIndex = 2
    }
    @IBAction func btnNo_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
