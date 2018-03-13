import Foundation
import UIKit

class DialogueManager {
    typealias methodHandler1 = () -> Void
    
    static func showError(viewController: UIViewController, message: String, okHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: ApplicationLabel.ERROR, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: ApplicationLabel.OK, style: .default, handler: { action in
            okHandler()
        }))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
    static func showInfo(viewController: UIViewController, message: String, okHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: ApplicationLabel.INFO, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: ApplicationLabel.OK, style: .default, handler: { action in
            okHandler()
        }))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
    static func showSuccess(viewController: UIViewController, message: String, okHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: ApplicationLabel.SUCCESS, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: ApplicationLabel.OK, style: .default, handler: { action in
            okHandler()
        }))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
    static func showConfirmation(viewController: UIViewController, message: String, yesHandler: @escaping methodHandler1) {
        let alert = UIAlertController(title: ApplicationLabel.CONFIRM, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: ApplicationLabel.NO, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: ApplicationLabel.YES, style: .destructive, handler: { action in
            yesHandler()
        }))
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            viewController.present(alert, animated: true)
        })
    }
    static func showToast(viewController: UIViewController, sourceView: UIView, message: String) {
        let alert = UIAlertController(title: ApplicationLabel.ALERT, message: message, preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = sourceView
        
        viewController.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
}
