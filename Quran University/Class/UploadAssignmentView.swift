import Foundation
import UIKit

class UploadAssignmentView: UIView {
    @IBOutlet weak var pvUploadFileProgressView: UIProgressView!
    
    typealias methodHandler1 = () -> Void
    
    func uploadRecording(completionHandler: @escaping methodHandler1) {
        AssignmentManager.submitAssignment(uiProgressView: pvUploadFileProgressView, completionHandler: { uploadStatus in
            if uploadStatus {
                DialogueManager.showSuccess(viewController: ApplicationObject.CurrentViewController, message: ApplicationSuccessMessage.ASSIGNMENT_SUBMIT, okHandler: {
                    completionHandler()
                })
            }
            else {
                DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.UPLOAD, okHandler: {
                    completionHandler()
                })
            }
        })
    }
}
