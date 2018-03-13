import Foundation
import UIKit

@IBDesignable
final class QUButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            if let borderColor = borderColor {
                self.layer.borderWidth = 1
                self.layer.borderColor = borderColor.cgColor
            }
            else {
                self.layer.borderWidth = 0
                self.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            
            addGradient(cornerRadius: cornerRadius, gradientStartColor: gradientStartColor, gradientEndColor: gradientEndColor)
        }
    }
    
    @IBInspectable
    var gradientStartColor: UIColor? {
        didSet {
            addGradient(cornerRadius: cornerRadius, gradientStartColor: gradientStartColor, gradientEndColor: gradientEndColor)
        }
    }
    
    @IBInspectable
    var gradientEndColor: UIColor? {
        didSet {
            addGradient(cornerRadius: cornerRadius, gradientStartColor: gradientStartColor, gradientEndColor: gradientEndColor)
        }
    }
    
    private func addGradient(cornerRadius: CGFloat, gradientStartColor: UIColor?, gradientEndColor: UIColor?) {
        if let gradientStartColor = gradientStartColor, let gradientEndColor = gradientEndColor {
            self.gradientLayer.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
            self.gradientLayer.frame = self.bounds
            self.gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(self.gradientLayer, below: self.imageView?.layer)
        }
        else {
            self.gradientLayer.removeFromSuperlayer()
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        self.gradientLayer.frame = self.bounds
        self.gradientLayer.cornerRadius = cornerRadius
    }
}
