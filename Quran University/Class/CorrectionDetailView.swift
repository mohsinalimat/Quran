import UIKit

class CorrectionDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvCorrectionDetailComment: UITableView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        let objCorrectionDetailModel = selectedCorrectionDetail?.filter { $0.Id == correctionDetailId }.first
        
        StudentMediaManager.checkDownloadTeacherMedia(audioFile: (objCorrectionDetailModel?.TeacherAudioFile)!, btnPlayPause: btnPlayPause, completionHandler: { status in
            if status {
                StudentMediaManager.playPauseTeacherMedia(audioFile: (objCorrectionDetailModel?.TeacherAudioFile)!, btnPlayPause: self.btnPlayPause)
            }
        })
    }
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
        
    }
}
