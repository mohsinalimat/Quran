import UIKit

class MLoginViewController: UIViewController {
    @IBOutlet weak var btnSignIn: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DocumentManager.initApplicationStructure()
        ApplicationDataManager.initApplicationData()
        Utilities.Initialize()
    }

    @IBAction func btnSignIn_TouchUp(_ sender: Any) {
        performSegue(withIdentifier: "SegueToMain", sender: nil)
    }
}
