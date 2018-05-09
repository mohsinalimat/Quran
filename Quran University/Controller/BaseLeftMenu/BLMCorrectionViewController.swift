import UIKit
import BEMCheckBox

class BLMCorrectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var tvCorrection: UITableView!
    
    var collapsedHeight: CGFloat = 35
    var expandedHeight: CGFloat = 180
    var seletecdRowFocused = false
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvCorrection.delegate = self
        tvCorrection.dataSource = self
        
        setViewPosition()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApplicationData.CurrentAssignment.Correction.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = collapsedHeight
        
        if selectedIndex == indexPath.row {
            rowHeight = expandedHeight
            
            if !seletecdRowFocused {
                seletecdRowFocused = true
                
                tvCorrection.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        else {
            rowHeight = collapsedHeight
        }
        
        return rowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcCorrection = tvCorrection.dequeueReusableCell(withIdentifier: "tvcCorrection") as! CorrectionTableViewCell
        let objCorrection = ApplicationData.CurrentAssignment.Correction[indexPath.row]
        let number = Int32(indexPath.row) + 1
        
        tvcCorrection.SelectedIndexPath = indexPath
        tvcCorrection.Id = objCorrection.Id
        tvcCorrection.lblNumber.text = ApplicationMethods.getOrdinalNumber(num: number)
//        tvcCorrection.lblAssignment.text = objAssignment.Title
//        tvcCorrection.lblCourse.text = objAssignment.CourseTitle
//        tvcCorrection.lblSubmissionDate.text = objAssignment.Submission
//
//        tvcAssignment.lblType.text = objAssignment.TypeTitle
//        tvcAssignment.lblStatus.text = objAssignment.AssignmentStatusTitle
//        tvcAssignment.lblDeadline.text = objAssignment.DeadlineString
//        tvcAssignment.lblSubmitted.text = objAssignment.SubmissionTime
//        tvcAssignment.lblDelayDays.text = objAssignment.DelayedDays
//        tvcAssignment.lblMarks.text = objAssignment.MarkString
//
//        if objAssignment.AssignmentStatusId == AssignmentStatus.Due.rawValue {
//            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.DUE_BG
//        }
//        else if objAssignment.AssignmentStatusId == AssignmentStatus.Late.rawValue {
//            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.LATE_BG
//        }
//        else if objAssignment.AssignmentStatusId == AssignmentStatus.NotSent.rawValue {
//            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.NOT_SENT_BG
//        }
//        else if objAssignment.AssignmentStatusId == AssignmentStatus.Accepted.rawValue {
//            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.ACCEPTED_BG
//        }
//        else if objAssignment.AssignmentStatusId == AssignmentStatus.Submitted.rawValue ||
//            objAssignment.AssignmentStatusId == AssignmentStatus.Resubmitted.rawValue {
//            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.SUBMITTED_BG
//        }
//        else if objAssignment.AssignmentStatusId == AssignmentStatus.Checked.rawValue ||
//            objAssignment.AssignmentStatusId == AssignmentStatus.Rechecked.rawValue {
//            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.CHECKED_BG
//        }
//
//        if !objAssignment.RecordingExists! {
//            tvcAssignment.btnUpload.isHidden = true
//            tvcAssignment.lblAssignment.frame = CGRect(x: tvcAssignment.lblAssignment.frame.origin.x, y: tvcAssignment.lblAssignment.frame.origin.y, width: 147, height: tvcAssignment.lblAssignment.frame.height)
//        }
//        else {
//            tvcAssignment.btnUpload.isHidden = false
//            tvcAssignment.lblAssignment.frame = CGRect(x: tvcAssignment.lblAssignment.frame.origin.x, y: tvcAssignment.lblAssignment.frame.origin.y, width: 115, height: tvcAssignment.lblAssignment.frame.height)
//        }
        
        return tvcCorrection;
    }
    
    func setViewPosition() {
        let vHeader = ApplicationObject.MainViewController.vHeader!
        let vFooter = ApplicationObject.MainViewController.vFooter!
        let x = vHeader.frame.origin.x
        let y = vHeader.frame.origin.y + vHeader.bounds.height
        let height = vFooter.frame.origin.y - y
        let width = vHeader.frame.size.width
        
        vMain.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    func setSelectedRow(indexPath: IndexPath) {
        if selectedIndex == indexPath.row {
            selectedIndex = -1
        }
        else {
            selectedIndex = indexPath.row
            seletecdRowFocused = false
        }
        
        self.tvCorrection.reloadData()
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
