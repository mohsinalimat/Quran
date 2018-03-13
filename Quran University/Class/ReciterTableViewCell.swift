import UIKit
import DLRadioButton

class ReciterTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var rbtnSelection: DLRadioButton!
    
    var Id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func rbtnSelection_TouchUp(_ sender: Any) {
        ApplicationData.CurrentReciter = ReciterRepository().getReciter(Id: Id)
        
        (self.superview as! UITableView).reloadData()
    }
}
