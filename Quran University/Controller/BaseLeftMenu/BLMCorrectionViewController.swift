import UIKit
import BEMCheckBox

class BLMCorrectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var tvCorrection: UITableView!
    
    var collapsedHeight: CGFloat = 65
    var expandedHeight: CGFloat = 245
    var seletecdRowFocused = false
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvCorrection.delegate = self
        tvCorrection.dataSource = self
        
        setViewPosition()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ApplicationData.CurrentAssignment.Correction.count + 1
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
        let number = Int32(indexPath.row) + 1
        
        tvcCorrection.SelectedIndexPath = indexPath
        tvcCorrection.lblNumber.text = ApplicationMethods.getOrdinalNumber(num: number)
        
        if indexPath.row <= 0 {
            if ApplicationData.CurrentAssignment.StudentOnlineSubmissionDate == nil || ApplicationData.CurrentAssignment.StudentOnlineSubmissionDate == "" {
                tvcCorrection.btnPlayPause.isHidden = true
                tvcCorrection.btnStop.isHidden = true
                tvcCorrection.lblSubmissionDate.isHidden = true
            }
            else {
                if ApplicationData.CurrentAssignment.StudentAudioFile == nil || ApplicationData.CurrentAssignment.StudentAudioFile == "" {
                    
                }
                
                tvcCorrection.lblSubmissionDate.text = ApplicationData.CurrentAssignment.StudentSubmission
            }
            
            if ApplicationData.CurrentAssignment.StaffCheckDate == nil || ApplicationData.CurrentAssignment.StaffCheckDate == "" {
                tvcCorrection.chkShowDetail.isHidden = true
                tvcCorrection.lblCheckDate.isHidden = true
            }
            else {
                if ApplicationData.CurrentAssignment.StudentAudioFile == nil || ApplicationData.CurrentAssignment.StudentAudioFile == "" {
                    
                }
                
                tvcCorrection.lblCheckDate.text = ApplicationData.CurrentAssignment.StaffCheck
            }
        }
        else {
            let index = ApplicationData.CurrentAssignment.Correction.count - indexPath.row
            let objCorrection = ApplicationData.CurrentAssignment.Correction[index]
            
            tvcCorrection.Id = objCorrection.Id
            
            if objCorrection.StudentOnlineSubmissionDate == nil || objCorrection.StudentOnlineSubmissionDate == "" {
                tvcCorrection.btnPlayPause.isHidden = true
                tvcCorrection.btnStop.isHidden = true
                tvcCorrection.lblSubmissionDate.isHidden = true
            }
            else {
                if objCorrection.StudentAudioFile == nil || objCorrection.StudentAudioFile == "" {
                    
                }
                
                tvcCorrection.lblSubmissionDate.text = objCorrection.Submission
            }
            
            if objCorrection.StaffCheckDate == nil || objCorrection.StaffCheckDate == "" {
                tvcCorrection.chkShowDetail.isHidden = true
                tvcCorrection.lblCheckDate.isHidden = true
            }
            else {
                if objCorrection.StudentAudioFile == nil || objCorrection.StudentAudioFile == "" {
                    
                }
                
                tvcCorrection.lblCheckDate.text = objCorrection.StaffCheck
            }
        }
        
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
