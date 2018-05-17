import UIKit
import BEMCheckBox

class CorrectionTableViewCell: UITableViewCell {
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var lblSubmissionDate: UILabel!
    @IBOutlet weak var lblMarks: UILabel!
    @IBOutlet weak var lblCheckDate: UILabel!
    @IBOutlet weak var chkShowDetail: BEMCheckBox!
    
    @IBOutlet weak var vHMistake: UIView!
    @IBOutlet weak var lblHMistake: UILabel!
    @IBOutlet weak var vHComment: UIView!
    @IBOutlet weak var lblHComment: UILabel!
    @IBOutlet weak var vHAudio: UIView!
    @IBOutlet weak var lblHAudio: UILabel!
    
    @IBOutlet weak var tvCorrectionDetail: UITableView!
    
    var Id: Int64 = 0
    var Number: Int32 = 0
    var AudioFile: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCheckboxStatusColor(isChecked: false, number: Number)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCheckboxStatusColor(isChecked: Bool, number: Int32) {
        chkShowDetail.boxType = BEMBoxType.square
        chkShowDetail.onCheckColor = ApplicationMethods.getCorrectionBGColor(number: number)
        
        if isChecked {
            chkShowDetail.onTintColor = ApplicationMethods.getCorrectionBGColor(number: number)
            chkShowDetail.onFillColor = ApplicationMethods.getCorrectionBColor(number: number)
        }
        else {
            chkShowDetail.tintColor = ApplicationMethods.getCorrectionBColor(number: number)
            chkShowDetail.offFillColor = ApplicationMethods.getCorrectionBGColor(number: number)
        }
    }
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
        StudentMediaManager.checkDownloadStudentMedia(audioFile: AudioFile, btnPlayPause: btnPlayPause, completionHandler: { status in
            if status {
                StudentMediaManager.playPauseStudentMedia(audioFile: self.AudioFile, btnPlayPause: self.btnPlayPause)
            }
        })
    }
    @IBAction func btnStop_TouchUp(_ sender: Any) {
        StudentMediaManager.stopMedia(audioFile: AudioFile, btnPlayPause: btnPlayPause)
    }
    @IBAction func chkShowDetail_TouchUp(_ sender: Any) {
        setCheckboxStatusColor(isChecked: chkShowDetail.on, number: Number)
        (ApplicationObject.CurrentViewController as! BLMCorrectionViewController).setSelectedRow(showDetail: chkShowDetail.on, id: Id, number: Number)
    }
}

extension CorrectionTableViewCell {
    func setCorrectionDetailDataSourceDelegate<D: UITableViewDataSource & UITableViewDelegate>(_ dataSourceDelegate: D, id: Int64) {
        tvCorrectionDetail.delegate = dataSourceDelegate
        tvCorrectionDetail.dataSource = dataSourceDelegate
        tvCorrectionDetail.accessibilityLabel = String(id)
        
        tvCorrectionDetail.reloadData()
    }
}
