import ASWaveformPlayerView
import AVFoundation
import UIKit

class RecordAssignmentView: UIView {
    @IBOutlet weak var vTimer: UIView!
    @IBOutlet weak var vRecording: UIView!
    @IBOutlet weak var lblTimer: UILabel!
    
    typealias methodHandler1 = () -> Void
    
    var recordingWaveform: ASWaveformPlayerView!
    var audioRecorder: AVAudioRecorder!
    var recordingPlayMode = AudioPlayMode.Paused
    var timer = Timer()
    var second = 0
    var minute = 0
    
    @objc func didAudioPlayToEnd() {
        recordingPlayMode = AudioPlayMode.Paused
        
        loadRecording()
    }
    @objc func timerAction() {
        if minute == 15 {
            finishRecording()
            
            DialogueManager.showInfo(viewController: ApplicationObject.MainViewController, message: ApplicationInfoMessage.MAX_RECORDING_LIMIT, okHandler: {})
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
    
    func loadView(completionHandler: @escaping methodHandler1) {
        PermissionManager.requestRecordPermission(successHandler: {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didAudioPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
            
            completionHandler()
        }, errorHandler: {
            self.closePopUp()
        })
    }
    func closePopUp() {
        if audioRecorder != nil {
            audioRecorder.stop()
        }
        
        timer.invalidate()
        ApplicationObject.MainViewController.hideMenu(tag: ViewTag.RecordedAssignment.rawValue)
    }
    
    func loadRecording() {
        do {
            vRecording.subviews.forEach({ $0.removeFromSuperview() })
            
            vRecording.isHidden = false
            vTimer.isHidden = true
            
            let recordingPath = ApplicationMethods.getCurrentStudentAssignmentRecordingPath()
            
            if DocumentManager.checkFileInApplicationDirectory(targetFilePath: recordingPath) != "" {
                let url = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: recordingPath)
                
                recordingWaveform = try ASWaveformPlayerView(audioURL: url, sampleCount: 1024, amplificationFactor: 4000)
                
                recordingWaveform.normalColor = .lightGray
                recordingWaveform.progressColor = .orange
                recordingWaveform.allowSpacing = false
                recordingWaveform.translatesAutoresizingMaskIntoConstraints = false
                recordingPlayMode = .Paused
                
                vRecording.addSubview(recordingWaveform)
                
                NSLayoutConstraint.activate([recordingWaveform.centerXAnchor.constraint(equalTo: vRecording.centerXAnchor),
                                             recordingWaveform.centerYAnchor.constraint(equalTo: vRecording.centerYAnchor),
                                             recordingWaveform.heightAnchor.constraint(equalTo: vRecording.heightAnchor),
                                             recordingWaveform.leadingAnchor.constraint(equalTo: vRecording.leadingAnchor),
                                             recordingWaveform.trailingAnchor.constraint(equalTo: vRecording.trailingAnchor)])
            }
            
        }
        catch {
            print(error.localizedDescription)
        }
    }
    func startRecording() {
        let recordingPath = ApplicationMethods.getCurrentStudentAssignmentRecordingPath()
        let url = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: recordingPath)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 32000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        minute = 0
        second = 0
        vRecording.isHidden = true
        vTimer.isHidden = false
        lblTimer.text = "00:00"
        
        timer.invalidate()
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.delegate = ApplicationObject.MainViewController
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            audioRecorder.record()
        } catch {
            finishRecording()
        }
    }
    func finishRecording() {
        vRecording.isHidden = true
        vTimer.isHidden = false
        
        audioRecorder.stop()
        timer.invalidate()
    }
    func playPauseRecording() {
        loadRecording()
        
        switch recordingPlayMode {
        case .Paused:
            recordingPlayMode = .Playing
            
            recordingWaveform.audioPlayer.play()
            
            break
        case .Playing:
            recordingPlayMode = .Paused
            
            recordingWaveform.audioPlayer.pause()
            
            break
        }
    }
}
