import UIKit
import BEMCheckBox

class BRMHideShowViewController: UIViewController {
    @IBOutlet weak var chkWithoutSound: BEMCheckBox!
    @IBOutlet weak var chkWithSound: BEMCheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chkWithoutSound.on = true
        chkWithSound.on = false
    }
    
    @IBAction func chkWithoutSound_TouchUp(_ sender: Any) {
        chkWithoutSound.on = true
        chkWithSound.on = false
    }
    @IBAction func chkWithSound_TouchUp(_ sender: Any) {
        chkWithoutSound.on = false
        chkWithSound.on = true
    }
    
    @IBAction func btnStart_TouchUp(_ sender: Any) {
        RecitationManager.hideShowModeOn = true
        RecitationManager.hideShowPlayWithoutSound = chkWithoutSound.on
        RecitationManager.audioPlayerInitialized = false
        
        AyatSelectionManager.markAyatSelectionRangeForHideMode()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
