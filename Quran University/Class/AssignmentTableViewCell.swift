import UIKit

class AssignmentTableViewCell: UITableViewCell {
    // ********** Header Section ********** //
    @IBOutlet weak var vHeaderRow: UIView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblAssignment: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSubmissionDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDeadline: UILabel!
    @IBOutlet weak var lblSubmitted: UILabel!
    @IBOutlet weak var lblDelayDays: UILabel!
    @IBOutlet weak var lblMarks: UILabel!
    
    // ********** Detail Section ********** //
    @IBOutlet weak var vDetailRow: UIView!
    
    var Id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnOpenAssignment_TouchUp(_ sender: Any) {
        AssignmentManager.loadAssignmentMode(Id: Id)
    }
}
