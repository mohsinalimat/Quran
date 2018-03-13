import Foundation
import UIKit

@IBDesignable
final class QUView: UIView {
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var shadowRadius: CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    @IBInspectable
    var shadowOpacity: Float = 0 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    @IBInspectable
    var shadowOffset: CGSize = CGSize() {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable
    var shadowColor: UIColor? {
        didSet {
            self.layer.shadowColor = shadowColor?.cgColor
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
            
            self.layer.insertSublayer(self.gradientLayer, at: 0)
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
