import UIKit

class BaseViewController: UIViewController {
    var delegate: ModalDialogueProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ApplicationObject.CurrentViewController = self
        
        if self.presentingViewController != nil {
            if self.presentingViewController is ModalDialogueProtocol {
                self.delegate = self.presentingViewController as! ModalDialogueProtocol
            }
            else {
                for child in (self.presentingViewController?.childViewControllers)! {
                    if child is ModalDialogueProtocol {
                        self.delegate = child as! ModalDialogueProtocol
                        
                        break
                    }
                }
            }
        }
        
        NetworkManager.isUnreachable { _ in
            self.internetNotAvailable()
        }
        NetworkManager.sharedInstance.reachability.whenUnreachable = { reachability in
            self.internetNotAvailable()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.presentingViewController != nil {
            ApplicationObject.CurrentViewController = self.presentingViewController!
        }
        else {
            ApplicationObject.CurrentViewController = ApplicationObject.MainViewController
        }
    }
    
    func internetNotAvailable() {
        DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationInfoMessage.INTERNET_NOT_AVAILABLE, okHandler: {
            ApplicationMethods.showSetting()
        })
    }
}
