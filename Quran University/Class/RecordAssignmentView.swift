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
    var recordingLoaded = false
    var second = 0
    var minute = 0
    
    @objc func didAudioPlayToEnd() {
        recordingPlayMode = AudioPlayMode.Paused
        
        ApplicationObject.MainViewController.setRecordUploadMode(currentRecordUploadMode: .Pause)
        
        _ = loadRecording()
    }
    @objc func timerAction() {
        if minute == 15 {
            recordingPlayMode = .Stopped
            
            recordStopRecording()
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
        recordingLoaded = false
        
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
        
        recordingLoaded = false
        
        timer.invalidate()
        ApplicationObject.MainViewController.hideMenu(tag: ViewTag.RecordedAssignment.rawValue)
    }
    
    func recordStopRecording() {
        switch recordingPlayMode {
        case .Recording:
            vRecording.isHidden = true
            vTimer.isHidden = false
            recordingPlayMode = .Stopped
            
            ApplicationObject.MainViewController.setRecordUploadMode(currentRecordUploadMode: .Stop)
            audioRecorder.stop()
            timer.invalidate()
            
            break
        default:
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
            recordingLoaded = false
            recordingPlayMode = .Recording
            
            ApplicationObject.MainViewController.setRecordUploadMode(currentRecordUploadMode: .Record)
            timer.invalidate()
            
            do {
                audioRecorder = try AVAudioRecorder(url: url, settings: settings)
                audioRecorder.delegate = ApplicationObject.MainViewController
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
                
                audioRecorder.record()
                
                let studentAssignmentRecordingObject = StudentAssignmentRecording(Id: ApplicationData.CurrentAssignment.Id)
                
                _ = StudentAssignmentRecordingRepository().saveStudentAssignmentRecording(studentAssignmentRecordingObject: studentAssignmentRecordingObject)
            }
            catch {
                recordStopRecording()
            }
            
            break
        }
    }
    func playPauseRecording() {
        var recordingExist = true
        
        if !recordingLoaded {
            recordingPlayMode = .Paused
            
            recordingExist = loadRecording()
        }
        
        if recordingExist {
            switch recordingPlayMode {
            case .Playing:
                recordingPlayMode = .Paused
                
                ApplicationObject.MainViewController.setRecordUploadMode(currentRecordUploadMode: .Pause)
                recordingWaveform.audioPlayer.pause()
                
                break
            case .Paused:
                recordingPlayMode = .Playing
                
                ApplicationObject.MainViewController.setRecordUploadMode(currentRecordUploadMode: .Play)
                recordingWaveform.audioPlayer.play()
                
                break
            default:
                break
            }
        }
    }
    
    func loadRecording() -> Bool {
        var recordingExist = false
        
        do {
            vRecording.subviews.forEach({ $0.removeFromSuperview() })
            
            let recordingPath = ApplicationMethods.getCurrentStudentAssignmentRecordingPath()
            
            if DocumentManager.checkFileInApplicationDirectory(targetFilePath: recordingPath) != "" {
                let url = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: recordingPath)
                
                recordingWaveform = try ASWaveformPlayerView(audioURL: url, sampleCount: 1024, amplificationFactor: 4000)
                
                recordingWaveform.normalColor = .lightGray
                recordingWaveform.progressColor = .orange
                recordingWaveform.allowSpacing = false
                recordingWaveform.translatesAutoresizingMaskIntoConstraints = false
                vRecording.isHidden = false
                vTimer.isHidden = true
                recordingLoaded = true
                recordingExist = true
                
                vRecording.addSubview(recordingWaveform)
                
                NSLayoutConstraint.activate([recordingWaveform.centerXAnchor.constraint(equalTo: vRecording.centerXAnchor),
                                             recordingWaveform.centerYAnchor.constraint(equalTo: vRecording.centerYAnchor),
                                             recordingWaveform.heightAnchor.constraint(equalTo: vRecording.heightAnchor),
                                             recordingWaveform.leadingAnchor.constraint(equalTo: vRecording.leadingAnchor),
                                             recordingWaveform.trailingAnchor.constraint(equalTo: vRecording.trailingAnchor)])
            }
            else {
                ApplicationObject.MainViewController.setRecordUploadMode(currentRecordUploadMode: .Download)
                AssignmentManager.downloadAssignment(completionHandler: { downloadStatus in
                    if downloadStatus {
                        ApplicationObject.MainViewController.showMenu(tag: ViewTag.RecordedAssignment.rawValue)
                        self.playPauseRecording()
                    }
                    else {
                        DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {
                            ApplicationObject.MainViewController.setRecordUploadFooter()
                        })
                    }
                })
            }
        }
        catch {}
        
        return recordingExist
    }
}
