import UIKit
import BEMCheckBox

class CorrectionTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblSubmissionDate: UILabel!
    @IBOutlet weak var lblCheckDate: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var chkShowDetail: BEMCheckBox!
    
    @IBOutlet weak var tvCorrectionDetail: UITableView!
    
    var Id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCheckboxStatusColor(isChecked: false)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCheckboxStatusColor(isChecked: Bool) {
        chkShowDetail.boxType = BEMBoxType.square
        chkShowDetail.onCheckColor = AssignmentStatusColor.CHECKED_BG
        
        if isChecked {
            chkShowDetail.onTintColor = AssignmentStatusColor.CHECKED_BG
            chkShowDetail.onFillColor = AssignmentStatusColor.CHECKED_B
        }
        else {
            chkShowDetail.tintColor = AssignmentStatusColor.CHECKED_B
            chkShowDetail.offFillColor = AssignmentStatusColor.CHECKED_BG
        }
    }
    func setCorrectionDetailDataSourceDelegate
        <delegate:UITableViewDelegate & UITableViewDataSource>(_ dataSourceDelegate: delegate, forRow row: Int) {
        tvCorrectionDetail.delegate = dataSourceDelegate
        tvCorrectionDetail.dataSource = dataSourceDelegate
        
        tvCorrectionDetail.reloadData()
    }
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
    }
    @IBAction func btnStop_TouchUp(_ sender: Any) {
    }
    
    @IBAction func chkShowDetail_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(isChecked: chkShowDetail.on)
        (ApplicationObject.CurrentViewController as! BLMCorrectionViewController).setSelectedRow(showDetail: chkShowDetail.on, id: Id)
    }
}
