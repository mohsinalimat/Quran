import UIKit

class BLMAssignmentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var tvAssignment: UITableView!
    
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
        
        tvcAssignment.lblNumber.text = ""
        tvcAssignment.lblAssignment.text = objAssignment.Title
        tvcAssignment.lblCourse.text = objAssignment.CourseTitle
        tvcAssignment.lblSubmissionDate.text = objAssignment.SubmissionTime
        
        tvcAssignment.lblType.text = objAssignment.TypeTitle
        tvcAssignment.lblStatus.text = objAssignment.AssignmentCurrentStatusTitle
        tvcAssignment.lblDeadline.text = objAssignment.Deadline
        tvcAssignment.lblSubmitted.text = objAssignment.Submission
        tvcAssignment.lblDelayDays.text = objAssignment.DelayedDaysString
        tvcAssignment.lblMarks.text = String(objAssignment.Marks)
        
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
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
