import UIKit
import BEMCheckBox

class BLMCorrectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var tvCorrection: UITableView!
    
    var selectedIdList = [Int64]()
    var collapsedHeight: CGFloat = 50
    var expandedHeight: CGFloat = 200
//    var seletecdRowFocused = false
//    var selectedId:Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        tvCorrection.delegate = self
//        tvCorrection.dataSource = self
//        tvcCorrection.tvCorrectionDetail.delegate = self
//        tvcCorrection.tvCorrectionDetail.dataSource = self
        
        setViewPosition()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return ApplicationData.CurrentAssignment.Correction.count + 1
        }
        else {
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            let index = ApplicationData.CurrentAssignment.Correction.count - (indexPath.row + 1)
            var rowHeight = collapsedHeight
            
            if index >= 0 {
                let id = ApplicationData.CurrentAssignment.Correction[index].Id
                
                if selectedIdList.contains(id) {
                    rowHeight = expandedHeight
                    
//                    if !seletecdRowFocused && selectedId == id {
//                        selectedId = 0
//                        seletecdRowFocused = true
//
//                        tvCorrection.scrollToRow(at: indexPath, at: .none, animated: true)
//                    }
                }
            }
            
            return rowHeight
        }
        else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            var tvcCorrection = tableView.dequeueReusableCell(withIdentifier: "tvcCorrection") as! CorrectionTableViewCell
            let index = ApplicationData.CurrentAssignment.Correction.count - indexPath.row
            let number = Int32(indexPath.row) + 1
            
            tvcCorrection.lblNumber.text = ApplicationMethods.getOrdinalNumber(num: number)
            tvcCorrection.lblSubmissionDate.isHidden = true
            tvcCorrection.btnPlayPause.isHidden = true
            tvcCorrection.btnStop.isHidden = true
            tvcCorrection.lblCheckDate.isHidden = true
            tvcCorrection.chkShowDetail.isHidden = true
            
            if indexPath.row <= 0 {
                tvcCorrection = setFirstCorrectionCell(tvcCorrection: tvcCorrection)
            }
            else if index >= 0 {
                tvcCorrection = setOtherCorrectionCell(tvcCorrection: tvcCorrection, index: index)
            }
            
            if selectedIdList.contains(tvcCorrection.Id) {
                tvcCorrection.chkShowDetail.on = true
                
                tvcCorrection.setCheckboxStatusColor(isChecked: true)
            }
            else {
                tvcCorrection.chkShowDetail.on = false
                
                tvcCorrection.setCheckboxStatusColor(isChecked: false)
            }
            
            return tvcCorrection
        }
        else {
            let tvcCorrectionDetail = tableView.dequeueReusableCell(withIdentifier: "tvcCorrectionDetail") as! CorrectionDetailTableViewCell
            
            return tvcCorrectionDetail
        }
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
    func setSelectedRow(showDetail: Bool, id: Int64) {
        if !showDetail {
            selectedIdList = selectedIdList.filter { $0 != id }
        }
        else {
//            selectedId = id
//            seletecdRowFocused = false
            
            selectedIdList.append(id)
        }
        
        self.tvCorrection.reloadData()
    }
    func setFirstCorrectionCell(tvcCorrection: CorrectionTableViewCell) -> CorrectionTableViewCell {
        if ApplicationData.CurrentAssignment.StudentOnlineSubmissionDate != nil &&
            ApplicationData.CurrentAssignment.StudentOnlineSubmissionDate != "" {
            tvcCorrection.lblSubmissionDate.isHidden = false
            tvcCorrection.lblSubmissionDate.text = ApplicationData.CurrentAssignment.StudentSubmission
            
            if ApplicationData.CurrentAssignment.StudentAudioFile != nil &&
                ApplicationData.CurrentAssignment.StudentAudioFile != "" {
                tvcCorrection.btnPlayPause.isHidden = false
                tvcCorrection.btnStop.isHidden = false
            }
        }
        
        if ApplicationData.CurrentAssignment.StaffCheckDate != nil &&
            ApplicationData.CurrentAssignment.StaffCheckDate != "" {
            let index = ApplicationData.CurrentAssignment.Correction.count - 1
            
            tvcCorrection.lblCheckDate.isHidden = false
            tvcCorrection.lblCheckDate.text = ApplicationData.CurrentAssignment.StaffCheck
            
            if ApplicationData.CurrentAssignment.Correction.count > 0 {
                let objCorrection = ApplicationData.CurrentAssignment.Correction[index]
                
                tvcCorrection.Id = objCorrection.Id
                
                if objCorrection.CorrectionDetail.count > 0 {
                    tvcCorrection.chkShowDetail.isHidden = false
                }
            }
        }
        
        return tvcCorrection
    }
    func setOtherCorrectionCell(tvcCorrection: CorrectionTableViewCell, index: Int) -> CorrectionTableViewCell {
        let objCorrection = ApplicationData.CurrentAssignment.Correction[index]
        
        if objCorrection.StudentOnlineSubmissionDate != nil &&
            objCorrection.StudentOnlineSubmissionDate != "" {
            tvcCorrection.lblSubmissionDate.isHidden = false
            tvcCorrection.lblSubmissionDate.text = objCorrection.Submission
            
            if objCorrection.StudentAudioFile != nil &&
                objCorrection.StudentAudioFile != "" {
                tvcCorrection.btnPlayPause.isHidden = false
                tvcCorrection.btnStop.isHidden = false
            }
        }
        
        if objCorrection.StaffCheckDate != nil &&
            objCorrection.StaffCheckDate != "" {
            let nextIndex = index - 1
            
            tvcCorrection.lblCheckDate.isHidden = false
            tvcCorrection.lblCheckDate.text = objCorrection.StaffCheck
            
            if nextIndex >= 0 {
                let objNextCorrection = ApplicationData.CurrentAssignment.Correction[nextIndex]
                
                tvcCorrection.Id = objNextCorrection.Id
                
                if objNextCorrection.CorrectionDetail.count > 0 {
                    tvcCorrection.chkShowDetail.isHidden = false
                }
            }
        }
        
        return tvcCorrection
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
