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
        ApplicationData.AssignmentModeOn = true
        
        AssignmentManager.assignmentList.filter { $0.Id == self.Id }.forEach { objAssignment in
            ApplicationData.CurrentAssignment = objAssignment
        }
        
        ApplicationObject.CurrentViewController.dismiss(animated: true, completion: {
            let ayatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId
            let pageObject = PageRepository().getFirstPage(ayatId: ayatId)
            
            ApplicationData.CurrentSurah = SurahRepository().getSurah(ayatId: ayatId)
            
            ApplicationObject.SurahButton.setTitle(ApplicationData.CurrentSurah.Name, for: .normal)
            PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageObject.Id)
        })
    }
}
