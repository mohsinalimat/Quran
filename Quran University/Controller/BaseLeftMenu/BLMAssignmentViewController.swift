import UIKit

class BLMAssignmentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var tvAssignment: UITableView!
    
    var dataArray : [[String:String]] = [["Number" : "1", "Assignment" : "Assignment 1", "Course" : "Course 1", "SubmissionDate" : "01 Jan 2018"], ["Number" : "2", "Assignment" : "Assignment 2", "Course" : "Course 1", "SubmissionDate" : "02 Jan 2018"], ["Number" : "3", "Assignment" : "Assignment 3", "Course" : "Course 1", "SubmissionDate" : "03 Jan 2018"], ["Number" : "4", "Assignment" : "Assignment 4", "Course" : "Course 1", "SubmissionDate" : "04 Jan 2018"]]
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvAssignment.delegate = self
        tvAssignment.dataSource = self
        
        setViewPosition()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            return 150;
        }
        else {
            return 35;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcAssignment = tvAssignment.dequeueReusableCell(withIdentifier: "tvcAssignment") as! AssignmentTableViewCell
        let obj = dataArray[indexPath.row]
        
        tvcAssignment.lblNumber.text = obj["Number"]
        tvcAssignment.lblAssignment.text = obj["Assignment"]
        tvcAssignment.lblCourse.text = obj["Course"]
        tvcAssignment.lblSubmissionDate.text = obj["SubmissionDate"]
        
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
