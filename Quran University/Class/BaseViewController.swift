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

    func internetNotAvailable() {
        DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationInfoMessage.INTERNET_NOT_AVAILABLE, okHandler: {
            ApplicationMethods.showGeneralSetting()
        })
    }
}
