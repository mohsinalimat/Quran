import UIKit

class AssignmentTableViewCell: UITableViewCell {
    // ********** Header Section ********** //
    @IBOutlet weak var vHeaderRow: UIView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblAssignment: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSubmissionDate: UILabel!
    @IBOutlet weak var btnUpload: UIButton!
    
    // ********** Detail Section ********** //
    @IBOutlet weak var vDetailRow: UIView!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblDeadline: UILabel!
    @IBOutlet weak var lblSubmitted: UILabel!
    @IBOutlet weak var lblDelayDays: UILabel!
    @IBOutlet weak var lblMarks: UILabel!
    
    var Id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnUpload_TouchUp(_ sender: Any) {
        AssignmentManager.loadAssignmentMode(Id: Id, completionHandler: {
            ApplicationObject.MainViewController.hideMenu()
            ApplicationObject.MainViewController.setFooterMode(currentFooterSectionMode: .AssignmentRecording, enableQuranPageUserInteraction: false)
        })
    }
    @IBAction func btnOpenAssignment_TouchUp(_ sender: Any) {
        AssignmentManager.loadAssignmentMode(Id: Id, completionHandler: {})
    }
}
