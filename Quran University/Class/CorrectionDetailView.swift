import UIKit

class CorrectionDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvCorrectionDetailComment: UITableView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    var SelectedCorrectionDetail = CorrectionDetailModel()
    var rowHeight: CGFloat = 32
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcCorrectionDetailComment = tvCorrectionDetailComment.dequeueReusableCell(withIdentifier: "tvcCorrectionDetailComment") as! CorrectionDetailCommentTableViewCell
        
        tvcCorrectionDetailComment.lblComment.text = "Test"
        tvcCorrectionDetailComment.vCommentColor.backgroundColor = UIColor.blue
        
        return tvcCorrectionDetailComment
    }
    
    func initializeView() {
        tvCorrectionDetailComment.delegate = self
        tvCorrectionDetailComment.dataSource = self
    }
    func loadView(correctionDetailId: Int32, correctionKey: Int32) {
        let selectedCorrectionDetail = CorrectionManager.selectedCorrectionDetailList[correctionKey]
        
        SelectedCorrectionDetail = (selectedCorrectionDetail?.filter { $0.Id == correctionDetailId }.first)!
        
        btnPlayPause.isEnabled = false
        
        if SelectedCorrectionDetail.TeacherAudioFile != "" {
            btnPlayPause.isEnabled = true
            
            StudentMediaManager.checkDownloadTeacherMedia(audioFile: SelectedCorrectionDetail.TeacherAudioFile, btnPlayPause: btnPlayPause, completionHandler: { status in
                if status {
                    StudentMediaManager.playPauseTeacherMedia(audioFile: self.SelectedCorrectionDetail.TeacherAudioFile, btnPlayPause: self.btnPlayPause)
                }
            })
        }
    }
    func unloadView() {
        StudentMediaManager.stopMedia(audioFile: SelectedCorrectionDetail.TeacherAudioFile, btnPlayPause: btnPlayPause)
    }
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
        StudentMediaManager.checkDownloadTeacherMedia(audioFile: SelectedCorrectionDetail.TeacherAudioFile, btnPlayPause: btnPlayPause, completionHandler: { status in
            if status {
                StudentMediaManager.playPauseTeacherMedia(audioFile: self.SelectedCorrectionDetail.TeacherAudioFile, btnPlayPause: self.btnPlayPause)
            }
        })
    }
}
