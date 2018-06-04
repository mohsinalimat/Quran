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
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.color = UIColor.black
            indicator.tag = tag
            
            self.addSubview(indicator)
            indicator.startAnimating()
        }
        else {
            self.isEnabled = true
            self.alpha = 1.0
            
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
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

extension Date
{
    func toString(dateFormat: String) -> String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
}
