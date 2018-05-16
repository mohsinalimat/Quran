import UIKit

class CorrectionDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    var Id: Int64 = 0
    var AudioFile: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
        StudentMediaManager.checkDownloadTeacherMedia(audioFile: AudioFile, btnPlayPause: btnPlayPause, completionHandler: { status in
            if status {
                StudentMediaManager.playPauseTeacherMedia(audioFile: self.AudioFile, btnPlayPause: self.btnPlayPause)
            }
        })
    }
    @IBAction func btnStop_TouchUp(_ sender: Any) {
        StudentMediaManager.stopMedia(audioFile: AudioFile, btnPlayPause: btnPlayPause)
    }
}
