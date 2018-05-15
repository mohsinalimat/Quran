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
        StudentMediaManager.playPauseMedia(audioFile: AudioFile, btnPlayPause: btnPlayPause)
    }
    @IBAction func btnStop_TouchUp(_ sender: Any) {
    }
}
