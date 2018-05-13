import UIKit
import BEMCheckBox

class CorrectionTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Id <= 0 ? 0 : (ApplicationData.CurrentAssignment.Correction.filter { $0.Id == Id }.first?.CorrectionDetail.count)!)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcCorrectionDetail = tvCorrectionDetail.dequeueReusableCell(withIdentifier: "tvcCorrectionDetail") as! CorrectionDetailTableViewCell
        
        return tvcCorrectionDetail
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
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
    }
    @IBAction func btnStop_TouchUp(_ sender: Any) {
    }
    
    @IBAction func chkShowDetail_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(isChecked: chkShowDetail.on)
        (ApplicationObject.CurrentViewController as! BLMCorrectionViewController).setSelectedRow(showDetail: chkShowDetail.on, id: Id)
    }
}
