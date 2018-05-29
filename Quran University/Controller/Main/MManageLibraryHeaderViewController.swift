import UIKit

class MManageLibraryHeaderViewController: UIViewController {
    @IBOutlet weak var vMainScroll: UIScrollView!
    @IBOutlet weak var btnTafseer: UIButton!
    @IBOutlet weak var btnTranslation: UIButton!
    @IBOutlet weak var btnWordMeaning: UIButton!
    @IBOutlet weak var btnCausesOfRevelation: UIButton!
    @IBOutlet weak var btnTajwid: UIButton!
    @IBOutlet weak var btnMyNotes: UIButton!
    @IBOutlet weak var vHighlightBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highlightButton(btnHighlighted: btnTafseer)
    }
    
    func highlightButton(btnHighlighted: UIButton) {
        btnTafseer.setTitleColor(ApplicationConstant.ButtonTextColor, for: .normal)
        btnTranslation.setTitleColor(ApplicationConstant.ButtonTextColor, for: .normal)
        btnWordMeaning.setTitleColor(ApplicationConstant.ButtonTextColor, for: .normal)
        btnCausesOfRevelation.setTitleColor(ApplicationConstant.ButtonTextColor, for: .normal)
        btnTajwid.setTitleColor(ApplicationConstant.ButtonTextColor, for: .normal)
        btnMyNotes.setTitleColor(ApplicationConstant.ButtonTextColor, for: .normal)
        
        btnHighlighted.setTitleColor(ApplicationConstant.ButtonTextHighlightColor, for: .normal)
        
        let x = btnHighlighted.superview?.frame.origin.x
        let y = vHighlightBar.frame.origin.y
        let height = vHighlightBar.frame.size.height
        let width = btnHighlighted.frame.size.width
        let rect = CGRect(x: x!, y: y, width: width, height: height)
        
        vHighlightBar.frame = rect
        
        vMainScroll.scrollRectToVisible(rect, animated: true)
    }
    
    @IBAction func btnTafseer_TouchUp(_ sender: Any) {
        highlightButton(btnHighlighted: btnTafseer)
    }
    @IBAction func btnTranslation_TouchUp(_ sender: Any) {
        highlightButton(btnHighlighted: btnTranslation)
    }
    @IBAction func btnWordMeaning_TouchUp(_ sender: Any) {
        highlightButton(btnHighlighted: btnWordMeaning)
    }
    @IBAction func btnCausesOfRevelation_TouchUp(_ sender: Any) {
        highlightButton(btnHighlighted: btnCausesOfRevelation)
    }
    @IBAction func btnTajwid_TouchUp(_ sender: Any) {
        highlightButton(btnHighlighted: btnTajwid)
    }
    @IBAction func btnMyNotes_TouchUp(_ sender: Any) {
        highlightButton(btnHighlighted: btnMyNotes)
    }
}
