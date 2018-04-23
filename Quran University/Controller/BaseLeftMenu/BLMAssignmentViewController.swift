import UIKit
import BEMCheckBox

class BLMAssignmentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnTopClose: QUButton!
    @IBOutlet weak var tvAssignment: UITableView!
    @IBOutlet weak var chkDue: BEMCheckBox!
    @IBOutlet weak var chkLate: BEMCheckBox!
    @IBOutlet weak var chkNotSent: BEMCheckBox!
    @IBOutlet weak var chkAccepted: BEMCheckBox!
    @IBOutlet weak var chkSubmitted: BEMCheckBox!
    @IBOutlet weak var chkChecked: BEMCheckBox!
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvAssignment.delegate = self
        tvAssignment.dataSource = self
        
        setViewPosition()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AssignmentManager.assignmentList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 180
        }
        else {
            return 35
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcAssignment = tvAssignment.dequeueReusableCell(withIdentifier: "tvcAssignment") as! AssignmentTableViewCell
        let objAssignment = AssignmentManager.assignmentList[indexPath.row]
        
        tvcAssignment.Id = objAssignment.Id
        tvcAssignment.lblNumber.text = objAssignment.Number
        tvcAssignment.lblAssignment.text = objAssignment.Title
        tvcAssignment.lblCourse.text = objAssignment.CourseTitle
        tvcAssignment.lblSubmissionDate.text = objAssignment.Submission
        
        tvcAssignment.lblType.text = objAssignment.TypeTitle
        tvcAssignment.lblStatus.text = objAssignment.AssignmentStatusTitle
        tvcAssignment.lblDeadline.text = objAssignment.DeadlineString
        tvcAssignment.lblSubmitted.text = objAssignment.SubmissionTime
        tvcAssignment.lblDelayDays.text = objAssignment.DelayedDays
        tvcAssignment.lblMarks.text = objAssignment.MarkString
        
        if objAssignment.AssignmentStatusId == AssignmentStatus.Due.rawValue {
            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.DUE_BG
        }
        else if objAssignment.AssignmentStatusId == AssignmentStatus.Late.rawValue {
            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.LATE_BG
        }
        else if objAssignment.AssignmentStatusId == AssignmentStatus.NotSent.rawValue {
            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.NOT_SENT_BG
        }
        else if objAssignment.AssignmentStatusId == AssignmentStatus.Accepted.rawValue {
            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.ACCEPTED_BG
        }
        else if objAssignment.AssignmentStatusId == AssignmentStatus.Submitted.rawValue ||
            objAssignment.AssignmentStatusId == AssignmentStatus.Resubmitted.rawValue {
            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.SUBMITTED_BG
        }
        else if objAssignment.AssignmentStatusId == AssignmentStatus.Checked.rawValue ||
            objAssignment.AssignmentStatusId == AssignmentStatus.Rechecked.rawValue {
            tvcAssignment.lblNumber.backgroundColor = AssignmentStatusColor.CHECKED_BG
        }
        
        return tvcAssignment;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(selectedIndex == indexPath.row) {
            selectedIndex = -1
        } else {
            selectedIndex = indexPath.row
        }
        
        self.tvAssignment.beginUpdates()
        self.tvAssignment.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.tvAssignment.endUpdates()
    }
    
    func setViewPosition() {
        let vHeader = ApplicationObject.MainViewController.vHeader!
        let vFooter = ApplicationObject.MainViewController.vFooter!
        let x = vHeader.frame.origin.x
        let y = vHeader.frame.origin.y + vHeader.bounds.height
        let height = vFooter.frame.origin.y - y
        let width = vHeader.frame.size.width
        
        vMain.frame = CGRect(x: x, y: y, width: width, height: height)
        
        setCheckboxStatusColor(statusId: .Due, isChecked: false)
        setCheckboxStatusColor(statusId: .Late, isChecked: false)
        setCheckboxStatusColor(statusId: .NotSent, isChecked: false)
        setCheckboxStatusColor(statusId: .Accepted, isChecked: false)
        setCheckboxStatusColor(statusId: .Submitted, isChecked: false)
        setCheckboxStatusColor(statusId: .Checked, isChecked: false)
    }
    func setCheckboxStatusColor(statusId: AssignmentStatus, isChecked: Bool) {
        switch statusId {
        case .Due:
            chkDue.boxType = BEMBoxType.square
            chkDue.onCheckColor = AssignmentStatusColor.DUE_BG
            
            if isChecked {
                chkDue.onTintColor = AssignmentStatusColor.DUE_BG
                chkDue.onFillColor = AssignmentStatusColor.DUE_B
            }
            else {
                chkDue.tintColor = AssignmentStatusColor.DUE_B
                chkDue.offFillColor = AssignmentStatusColor.DUE_BG
            }
            
            break
        case .Late:
            chkLate.boxType = BEMBoxType.square
            chkLate.onCheckColor = AssignmentStatusColor.LATE_BG
            
            if isChecked {
                chkLate.onTintColor = AssignmentStatusColor.LATE_BG
                chkLate.onFillColor = AssignmentStatusColor.LATE_B
            }
            else {
                chkLate.tintColor = AssignmentStatusColor.LATE_B
                chkLate.offFillColor = AssignmentStatusColor.LATE_BG
            }
            
            break
        case .NotSent:
            chkNotSent.boxType = BEMBoxType.square
            chkNotSent.onCheckColor = AssignmentStatusColor.NOT_SENT_BG
            
            if isChecked {
                chkNotSent.onTintColor = AssignmentStatusColor.NOT_SENT_BG
                chkNotSent.onFillColor = AssignmentStatusColor.NOT_SENT_B
            }
            else {
                chkNotSent.tintColor = AssignmentStatusColor.NOT_SENT_B
                chkNotSent.offFillColor = AssignmentStatusColor.NOT_SENT_BG
            }
            
            break
        case .Accepted:
            chkAccepted.boxType = BEMBoxType.square
            chkAccepted.onCheckColor = AssignmentStatusColor.ACCEPTED_BG
            
            if isChecked {
                chkAccepted.onTintColor = AssignmentStatusColor.ACCEPTED_BG
                chkAccepted.onFillColor = AssignmentStatusColor.ACCEPTED_B
            }
            else {
                chkAccepted.tintColor = AssignmentStatusColor.ACCEPTED_B
                chkAccepted.offFillColor = AssignmentStatusColor.ACCEPTED_BG
            }
            
            break
        case .Submitted:
            chkSubmitted.boxType = BEMBoxType.square
            chkSubmitted.onCheckColor = AssignmentStatusColor.SUBMITTED_BG
            
            if isChecked {
                chkSubmitted.onTintColor = AssignmentStatusColor.SUBMITTED_BG
                chkSubmitted.onFillColor = AssignmentStatusColor.SUBMITTED_B
            }
            else {
                chkSubmitted.tintColor = AssignmentStatusColor.SUBMITTED_B
                chkSubmitted.offFillColor = AssignmentStatusColor.SUBMITTED_BG
            }
            
            break
        case .Checked:
            chkChecked.boxType = BEMBoxType.square
            chkChecked.onCheckColor = AssignmentStatusColor.CHECKED_BG
            
            if isChecked {
                chkChecked.onTintColor = AssignmentStatusColor.CHECKED_BG
                chkChecked.onFillColor = AssignmentStatusColor.CHECKED_B
            }
            else {
                chkChecked.tintColor = AssignmentStatusColor.CHECKED_B
                chkChecked.offFillColor = AssignmentStatusColor.CHECKED_BG
            }
            
            break
        default:
            break
        }
    }
    func filterAssignmentList() {
        AssignmentManager.assignmentStatusList.removeAll()
        
        selectedIndex = -1
        
        if chkDue.on {
            AssignmentManager.assignmentStatusList.append(.Due)
        }
        
        if chkLate.on {
            AssignmentManager.assignmentStatusList.append(.Late)
        }
        
        if chkNotSent.on {
            AssignmentManager.assignmentStatusList.append(.NotSent)
        }
        
        if chkAccepted.on {
            AssignmentManager.assignmentStatusList.append(.Accepted)
        }
        
        if chkSubmitted.on {
            AssignmentManager.assignmentStatusList.append(.Submitted)
            AssignmentManager.assignmentStatusList.append(.Resubmitted)
        }
        
        if chkChecked.on {
            AssignmentManager.assignmentStatusList.append(.Checked)
            AssignmentManager.assignmentStatusList.append(.Rechecked)
        }
        
        AssignmentManager.populateFilteredAssignment(applyFilter: true)
        tvAssignment.reloadData()
    }
    
    @IBAction func btnRefresh_TouchUp(_ sender: Any) {
        AssignmentManager.assignmentList.removeAll()
        btnRefresh.loadingIndicator(true)
        vContent.setViewDisabled()
        
        selectedIndex = -1
        btnTopClose.isEnabled = false
        chkDue.on = false
        chkLate.on = false
        chkNotSent.on = false
        chkAccepted.on = false
        chkSubmitted.on = false
        chkChecked.on = false
        
        AssignmentManager.populateStudentAssignment(completionHandler: {
            DispatchQueue.main.async {
                self.tvAssignment.reloadData()
                self.btnRefresh.loadingIndicator(false)
                self.vContent.setViewEnabled()
                
                self.btnTopClose.isEnabled = true
            }
        })
    }
    
    @IBAction func chkDue_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(statusId: .Due, isChecked: chkDue.on)
        filterAssignmentList()
    }
    @IBAction func chkLate_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(statusId: .Late, isChecked: chkLate.on)
        filterAssignmentList()
    }
    @IBAction func chkNotSent_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(statusId: .NotSent, isChecked: chkNotSent.on)
        filterAssignmentList()
    }
    @IBAction func chkAccepted_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(statusId: .Accepted, isChecked: chkAccepted.on)
        filterAssignmentList()
    }
    @IBAction func chkSubmitted_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(statusId: .Submitted, isChecked: chkSubmitted.on)
        filterAssignmentList()
    }
    @IBAction func chkChecked_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(statusId: .Checked, isChecked: chkChecked.on)
        filterAssignmentList()
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
