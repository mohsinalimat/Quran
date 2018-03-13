import Foundation
import UIKit

extension UIButton
{
    func setButtonDisabled() {
        self.isEnabled = false
        self.isUserInteractionEnabled = false
        self.alpha = 0.3
    }
    func setButtonEnabled() {
        self.isEnabled = true
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
}

extension UIView
{
    func setViewDisabled() {
        self.isUserInteractionEnabled = false
        self.alpha = 0.3
    }
    func setViewEnabled() {
        self.isUserInteractionEnabled = true
        self.alpha = 1
    }
}
