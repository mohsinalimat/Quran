import ASWaveformPlayerView
import AVFoundation
import UIKit

class BRMRecordCompareViewController: BaseViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var vMain: UIView!
    
    // ********** Recording Section ********** //
    @IBOutlet weak var vRecording: UIView!
    @IBOutlet weak var vTimer: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var btnStopRecording: UIButton!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnPlayRecording: UIButton!
    
    // ********** Ayat Section ********** //
    @IBOutlet weak var vAyat: UIView!
    @IBOutlet weak var lblAyatName: UILabel!
    @IBOutlet weak var btnPlayAyat: UIButton!
    @IBOutlet weak var btnPreviousAyat: UIButton!
    @IBOutlet weak var btnNextAyat: UIButton!
    
    var recordingWaveform: ASWaveformPlayerView!
    var ayatWaveform: ASWaveformPlayerView!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recordingPlayMode = AudioPlayMode.Paused
    var ayatPlayMode = AudioPlayMode.Paused
    var currentPlayMode = RecordComparePlayMode.Recording
    var timer = Timer()
    var currentRecitationIndex = 0
    var totalRecitation = 0
    var second = 0
    var minute = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DocumentManager.clearDirectory(folderPath: DirectoryStructure.TempRecordingRecitation)
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.totalRecitation = RecitationManager.getRecitationCount()
                        
                        self.loadAyat()
                        self.startRecording()
                        
                        NotificationCenter.default.addObserver(self, selector: #selector(self.didAudioPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                    } else {
                        self.closePopUp()
                    }
                }
            }
        } catch {
            closePopUp()
        }
    }
    
    @objc func didAudioPlayToEnd() {
        switch currentPlayMode {
        case .Recording:
            recordingPlayMode = AudioPlayMode.Paused
            
            btnPlayRecording.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
            loadRecording()
            
            break
        case .Ayat:
            ayatPlayMode = AudioPlayMode.Paused
            
            btnPlayAyat.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
            loadAyat()
            
            break
        }
    }
    @objc func timerAction() {
        if minute == 4 {
            finishRecording()
            
            DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.MAX_RECORDING_LIMIT, okHandler: {})
        }
        else {
            second += 1
            
            if second == 60 {
                minute += 1
                second = 0
            }
            
            let secondString = second > 9 ? "\(second)" : "0\(second)"
            let minuteString = minute > 9 ? "\(minute)" : "0\(minute)"
            
            lblTimer.text = "\(minuteString):\(secondString)"
        }
    }
    
    func setViewPosition() {
        var vMVC = (ApplicationObject.MainViewController as! MMainViewController).vHeader!
        var y = vMVC.frame.origin.y + vMVC.bounds.height
        let heightAdjustment = vMVC.bounds.height

        vMain.center = CGPoint(x: vMVC.frame.size.width  / 2, y: vMVC.frame.size.height / 2)
        vMain.frame.origin.y = y
        vMain.frame.size.height = vMain.frame.size.height - heightAdjustment
        
        let ayatSelectionList = AyatSelectionManager.getAyatSelectionList(recitationName: RecitationManager.getRecitationName(recitationIndex: currentRecitationIndex))
        var status = false
        
        for ayatSelection in ayatSelectionList {
            if (ayatSelection.path?.boundingBoxOfPath.intersects(vMain.frame))! {
                status = true
                
                break
            }
        }
        
        if status {
            vMVC = (ApplicationObject.MainViewController as! MMainViewController).vFooter!
            vMain.frame.size.height = vMain.frame.size.height + heightAdjustment
            y = vMVC.frame.origin.y - vMain.bounds.height
    
            vMain.center = CGPoint(x: vMVC.frame.size.width  / 2, y: vMVC.frame.size.height / 2)
            vMain.frame.origin.y = y
        }
        else {
            vMain.frame.size.height = vMain.frame.size.height + heightAdjustment
        }
    }
    func closePopUp() {
        DocumentManager.clearDirectory(folderPath: DirectoryStructure.TempRecordingRecitation)
        (ApplicationObject.MainViewController as! MMainViewController).setFooterMode(currentFooterSectionMode: .Player)
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadRecording() {
        do {
            vRecording.subviews.forEach({ $0.removeFromSuperview() })
            
            let recordingPath = ApplicationMethods.getRecitationRecordingPath(currentRecitationIndex: currentRecitationIndex)
            
            if DocumentManager.checkFileInApplicationDirectory(targetFilePath: recordingPath) != "" {
                let url = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: recordingPath)
                
                recordingWaveform = try ASWaveformPlayerView(audioURL: url, sampleCount: 1024, amplificationFactor: 4000)
                
                recordingWaveform.normalColor = .lightGray
                recordingWaveform.progressColor = .orange
                recordingWaveform.allowSpacing = false
                recordingWaveform.translatesAutoresizingMaskIntoConstraints = false
                recordingPlayMode = .Paused
                
                btnPlayRecording.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
                vRecording.addSubview(recordingWaveform)
                
                NSLayoutConstraint.activate([recordingWaveform.centerXAnchor.constraint(equalTo: vRecording.centerXAnchor),
                                             recordingWaveform.centerYAnchor.constraint(equalTo: vRecording.centerYAnchor),
                                             recordingWaveform.heightAnchor.constraint(equalTo: vRecording.heightAnchor),
                                             recordingWaveform.leadingAnchor.constraint(equalTo: vRecording.leadingAnchor),
                                             recordingWaveform.trailingAnchor.constraint(equalTo: vRecording.trailingAnchor)])
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    func startRecording() {
        let recordingPath = ApplicationMethods.getRecitationRecordingPath(currentRecitationIndex: currentRecitationIndex)
        let url = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: recordingPath)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            minute = 0
            second = 0
            vRecording.isHidden = true
            vTimer.isHidden = false
            lblTimer.text = "00:00"
            
            timer.invalidate()
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            btnRecord.isEnabled = false
            btnStopRecording.isEnabled = true
        } catch {
            finishRecording()
        }
    }
    func finishRecording() {
        audioRecorder.stop()
        timer.invalidate()
        
        vRecording.isHidden = false
        vTimer.isHidden = true
        audioRecorder = nil
        btnRecord.isEnabled = true
        btnStopRecording.isEnabled = false
        
        loadRecording()
    }
    func playPauseRecording() {
        currentPlayMode = .Recording
        ayatPlayMode = AudioPlayMode.Paused
        
        btnPlayAyat.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
        ayatWaveform.audioPlayer.pause()
        
        switch recordingPlayMode {
        case .Paused:
            recordingPlayMode = .Playing
            
            btnPlayRecording.setImage(#imageLiteral(resourceName: "img_PauseGreen"), for: .normal)
            recordingWaveform.audioPlayer.play()
            
            break
        case .Playing:
            recordingPlayMode = .Paused
            
            btnPlayRecording.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
            recordingWaveform.audioPlayer.pause()
            
            break
        }
    }
        
    func loadAyat() {
        do {
            vAyat.subviews.forEach({ $0.removeFromSuperview() })
            
            let ayatOrderId = RecitationManager.getRecitation(recitationIndex: currentRecitationIndex).AyatOrderId
            let currentRecitationNumber = currentRecitationIndex + 1
            
            lblAyatName.text = "Ayat "  + String(ayatOrderId)
            btnNextAyat.isHidden = true
            btnPreviousAyat.isHidden = true
            
            if totalRecitation > 1 {
                if currentRecitationNumber == 1 {
                    btnNextAyat.isHidden = false
                }
                else if currentRecitationNumber == totalRecitation {
                    btnPreviousAyat.isHidden = false
                }
                else {
                    btnNextAyat.isHidden = false
                    btnPreviousAyat.isHidden = false
                }
            }
            
            ayatWaveform = try ASWaveformPlayerView(audioURL: RecitationManager.getRecitationFileURL(recitationIndex: currentRecitationIndex), sampleCount: 1024, amplificationFactor: 2000)
            
            ayatWaveform.normalColor = .lightGray
            ayatWaveform.progressColor = .orange
            ayatWaveform.allowSpacing = false
            ayatWaveform.translatesAutoresizingMaskIntoConstraints = false
            ayatPlayMode = .Paused
            
            btnPlayAyat.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
            vAyat.addSubview(ayatWaveform)
            
            NSLayoutConstraint.activate([ayatWaveform.centerXAnchor.constraint(equalTo: vAyat.centerXAnchor),
                                         ayatWaveform.centerYAnchor.constraint(equalTo: vAyat.centerYAnchor),
                                         ayatWaveform.heightAnchor.constraint(equalTo: vAyat.heightAnchor),
                                         ayatWaveform.leadingAnchor.constraint(equalTo: vAyat.leadingAnchor),
                                         ayatWaveform.trailingAnchor.constraint(equalTo: vAyat.trailingAnchor)])
            
            AyatSelectionManager.highlightAyatSelection(recitationName: RecitationManager.getRecitationName(recitationIndex: currentRecitationIndex))
            setViewPosition()
        } catch {
            print(error.localizedDescription)
        }
    }
    func playPauseAyat() {
        currentPlayMode = .Ayat
        recordingPlayMode = AudioPlayMode.Paused
        
        btnPlayRecording.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
        
        if recordingWaveform != nil {
            recordingWaveform.audioPlayer.pause()
        }
        
        switch ayatPlayMode {
        case .Paused:
            ayatPlayMode = .Playing
            
            btnPlayAyat.setImage(#imageLiteral(resourceName: "img_PauseGreen"), for: .normal)
            ayatWaveform.audioPlayer.play()
            
            break
        case .Playing:
            ayatPlayMode = .Paused
            
            btnPlayAyat.setImage(#imageLiteral(resourceName: "img_PlayGreen"), for: .normal)
            ayatWaveform.audioPlayer.pause()
            
            break
        }
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        closePopUp()
    }
    
    // ********** Recording Section ********** //
    @IBAction func btnStopRecording_TouchUp(_ sender: Any) {
        finishRecording()
    }
    @IBAction func btnRecord_TouchUp(_ sender: Any) {
        startRecording()
    }
    @IBAction func btnPlayRecording_TouchUp(_ sender: Any) {
        playPauseRecording()
    }
    
    // ********** Ayat Section ********** //
    @IBAction func btnPlayAyat_TouchUp(_ sender: Any) {
        playPauseAyat()
    }
    @IBAction func btnPreviousAyat_TouchUp(_ sender: Any) {
        currentRecitationIndex = currentRecitationIndex - 1
        
        loadRecording()
        loadAyat()
    }
    @IBAction func btnNextAyat_TouchUp(_ sender: Any) {
        currentRecitationIndex = currentRecitationIndex + 1
        
        loadRecording()
        loadAyat()
    }
}
