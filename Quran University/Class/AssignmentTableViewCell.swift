import UIKit

class AssignmentTableViewCell: UITableViewCell {
    // ********** Header Section ********** //
    @IBOutlet weak var vHeaderRow: UIView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblAssignment: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSubmissionDate: UILabel!
    
    // ********** Detail Section ********** //
    @IBOutlet weak var vDetailRow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
