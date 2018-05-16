import UIKit
import BEMCheckBox
import AVFoundation

class BLMCorrectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var tvCorrection: UITableView!
    
    var selectedIdList = [Int64]()
    var collapsedHeight: CGFloat = 50
    var detailHeaderHeight: CGFloat = 35
    var detailHeight: CGFloat = 50
//    var seletecdRowFocused = false
//    var selectedId:Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tvCorrection.delegate = self
        tvCorrection.dataSource = self
        
        setViewPosition()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        StudentMediaManager.mediaPlayMode = AudioPlayMode.Paused
        
        StudentMediaManager.btnMediaPlayPause.setImage(#imageLiteral(resourceName: "icn_PlaySmall"), for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if tableView.tag == -1 {
            count = ApplicationData.CurrentAssignment.Correction.count + 1
        }
        else if tableView.tag == -2 {
            if tableView.accessibilityLabel != nil && tableView.accessibilityLabel != "" {
                let id = Int64(tableView.accessibilityLabel!)

                if id! > 0 {
                    let objCorrection = ApplicationData.CurrentAssignment.Correction.filter { $0.Id == id }.first

                    count = (objCorrection?.CorrectionDetail.count)!
                }
            }
        }
        
        return count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight = collapsedHeight
        
        if tableView.tag == -1 {
            let index = ApplicationData.CurrentAssignment.Correction.count - (indexPath.row + 1)
            
            if index >= 0 {
                let objCorrection = ApplicationData.CurrentAssignment.Correction[index]
                
                if selectedIdList.contains(objCorrection.Id) {
                    rowHeight = detailHeaderHeight + detailHeight + (detailHeight * CGFloat(objCorrection.CorrectionDetail.count))
                    
//                    if !seletecdRowFocused && selectedId == id {
//                        selectedId = 0
//                        seletecdRowFocused = true
//
//                        tvCorrection.scrollToRow(at: indexPath, at: .none, animated: true)
//                    }
                }
            }
        }
        else if tableView.tag == -2 {
            rowHeight = detailHeight
        }
        
        return rowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == -1 {
            var tvcCorrection = tableView.dequeueReusableCell(withIdentifier: "tvcCorrection") as! CorrectionTableViewCell
            let index = ApplicationData.CurrentAssignment.Correction.count - indexPath.row
            let number = Int32(indexPath.row) + 1
            
            tvcCorrection.lblNumber.isHidden = true
            tvcCorrection.lblSubmissionDate.isHidden = true
            tvcCorrection.btnPlayPause.isHidden = true
            tvcCorrection.btnStop.isHidden = true
            tvcCorrection.lblCheckDate.isHidden = true
            tvcCorrection.lblMarks.isHidden = true
            tvcCorrection.chkShowDetail.isHidden = true
            
            tvcCorrection.Number = number
            tvcCorrection.vHMistake.backgroundColor = ApplicationMethods.getCorrectionBGColor(number: number)
            tvcCorrection.vHComment.backgroundColor = ApplicationMethods.getCorrectionBGColor(number: number)
            tvcCorrection.vHAudio.backgroundColor = ApplicationMethods.getCorrectionBGColor(number: number)
            tvcCorrection.lblHMistake.textColor = ApplicationMethods.getCorrectionBColor(number: number)
            tvcCorrection.lblHComment.textColor = ApplicationMethods.getCorrectionBColor(number: number)
            tvcCorrection.lblHAudio.textColor = ApplicationMethods.getCorrectionBColor(number: number)
            
            if indexPath.row <= 0 {
                tvcCorrection = setFirstCorrectionCell(tvcCorrection: tvcCorrection)
            }
            else if index >= 0 {
                tvcCorrection = setOtherCorrectionCell(tvcCorrection: tvcCorrection, index: index)
            }
            
            if selectedIdList.contains(tvcCorrection.Id) {
                tvcCorrection.chkShowDetail.on = true
                
                tvcCorrection.setCheckboxStatusColor(isChecked: true, number: number)
            }
            else {
                tvcCorrection.chkShowDetail.on = false
                
                tvcCorrection.setCheckboxStatusColor(isChecked: false, number: number)
            }
            
            if !tvcCorrection.lblSubmissionDate.isHidden ||
                !tvcCorrection.btnPlayPause.isHidden ||
                !tvcCorrection.btnStop.isHidden ||
                !tvcCorrection.lblCheckDate.isHidden ||
                !tvcCorrection.chkShowDetail.isHidden {
                tvcCorrection.lblNumber.isHidden = false
                tvcCorrection.lblNumber.text = ApplicationMethods.getOrdinalNumber(num: number)
                
                tvcCorrection.setCorrectionDetailDataSourceDelegate(self, id: tvcCorrection.Id)
            }
            
            if ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Accepted.rawValue &&
                tvcCorrection.chkShowDetail.isHidden {
                tvcCorrection.lblMarks.isHidden = false
                tvcCorrection.lblMarks.text = ApplicationHeading.MARKS + ApplicationData.CurrentAssignment.MarkString
            }
            
            return tvcCorrection
        }
        else {
            let tvcCorrectionDetail = tableView.dequeueReusableCell(withIdentifier: "tvcCorrectionDetail") as! CorrectionDetailTableViewCell
            
            tvcCorrectionDetail.btnPlayPause.isHidden = true
            tvcCorrectionDetail.btnStop.isHidden = true
            
            if tableView.accessibilityLabel != nil && tableView.accessibilityLabel != "" {
                let id = Int64(tableView.accessibilityLabel!)
                
                if id! > 0 {
                    let objCorrection = ApplicationData.CurrentAssignment.Correction.filter { $0.Id == id }.first
                    let objCorrectionDetail = objCorrection?.CorrectionDetail[indexPath.row]
                    let number = Int32(indexPath.row) + 1
                    
                    tvcCorrectionDetail.lblNumber.text = String(number)
                    tvcCorrectionDetail.lblComment.text = objCorrectionDetail?.TeacherComment
                    
                    if objCorrectionDetail?.TeacherAudioFile != nil &&
                        objCorrectionDetail?.TeacherAudioFile != "" {
                        tvcCorrectionDetail.AudioFile = (objCorrectionDetail?.TeacherAudioFile)!
                        tvcCorrectionDetail.btnPlayPause.isHidden = false
                        tvcCorrectionDetail.btnStop.isHidden = false
                    }
                }
            }
            
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
                tvcCorrection.AudioFile = ApplicationData.CurrentAssignment.StudentAudioFile!
                tvcCorrection.btnPlayPause.isHidden = false
                tvcCorrection.btnStop.isHidden = false
            }
        }
        
        if ApplicationData.CurrentAssignment.StaffCheckDate != nil &&
            ApplicationData.CurrentAssignment.StaffCheckDate != "" {
            tvcCorrection.lblCheckDate.isHidden = false
            tvcCorrection.lblCheckDate.text = ApplicationData.CurrentAssignment.StaffCheck
            
            if ApplicationData.CurrentAssignment.Correction.count > 0 {
                let index = ApplicationData.CurrentAssignment.Correction.count - 1
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
                tvcCorrection.AudioFile = objCorrection.StudentAudioFile!
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
    func closePopUp() {
        StudentMediaManager.mediaPlayMode = AudioPlayMode.Paused
        StudentMediaManager.mediaLoaded = false
        
        if StudentMediaManager.btnMediaPlayPause != nil {
            StudentMediaManager.btnMediaPlayPause.setImage(#imageLiteral(resourceName: "icn_PlaySmall"), for: .normal)
        }
        
        if StudentMediaManager.mediaPlayer != nil {
            StudentMediaManager.mediaPlayer.stop()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnShowMistakeCorrection_TouchUp(_ sender: Any) {
        
    }
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        closePopUp()
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        closePopUp()
    }
}
