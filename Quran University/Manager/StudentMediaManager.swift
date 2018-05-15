import Foundation
import AVFoundation
import UIKit
import Alamofire

class StudentMediaManager {
    static var mediaPlayer: AVAudioPlayer!
    static var btnMediaPlayPause: UIButton!
    static var mediaPlayMode = AudioPlayMode.Paused
    static var mediaFile = ""
    static var mediaLoaded = false
    
    static func playPauseMedia(audioFile: String, btnPlayPause: UIButton) {
        var mediaExist = true
        
        if mediaFile != audioFile {
            if mediaLoaded {
                mediaLoaded = false
                
                btnMediaPlayPause.setImage(#imageLiteral(resourceName: "icn_PlaySmall"), for: .normal)
                mediaPlayer.stop()
            }
        }

        if !mediaLoaded {
            mediaPlayMode = .Paused
            mediaExist = loadMedia(audioFile: audioFile, btnPlayPause: btnPlayPause)
        }

        if mediaExist {
            switch mediaPlayMode {
            case .Playing:
                mediaPlayMode = .Paused

                btnPlayPause.setImage(#imageLiteral(resourceName: "icn_PlaySmall"), for: .normal)
                mediaPlayer.pause()

                break
            case .Paused:
                mediaPlayMode = .Playing
                
                btnPlayPause.setImage(#imageLiteral(resourceName: "icn_PauseSmall"), for: .normal)
                mediaPlayer.play()

                break
            default:
                break
            }
        }
    }
    static func loadMedia(audioFile: String, btnPlayPause: UIButton) -> Bool {
        var mediaExist = false

        do {
            let mediaPath = ApplicationMethods.getStudentAssignmentMediaPath(mediaName: audioFile)

            if DocumentManager.checkFileInApplicationDirectory(targetFilePath: mediaPath) != "" {
                let fileURL = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: mediaPath)

                mediaPlayer = try AVAudioPlayer(contentsOf: fileURL)
                mediaPlayer.delegate = ApplicationObject.CurrentViewController as? AVAudioPlayerDelegate
                
                btnMediaPlayPause = btnPlayPause
                mediaLoaded = true
                mediaExist = true
            }
            else {
                mediaLoaded = false
                
                btnPlayPause.setButtonDisabled()
                
                Alamofire
                    .request(ApplicationMethods.getStudentAssignmentRecordingWebUrl(mediaName: audioFile))
                    .validate()
                    .responseData(completionHandler: { (response) in
                        var status = false
                        
                        btnPlayPause.setButtonEnabled()
                        
                        if response.result.isSuccess {
                            if let data = response.result.value {
                                let createdFileURL = DocumentManager.createFileInApplicationDirectory(contents: data, targetFilePath: mediaPath)
                                
                                if createdFileURL != "" {
                                    status = true
                                }
                            }
                        }
                        
                        if status {
                            
                        }
                        else {
                            DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {})
                        }
                    })
            }
        }
        catch {}

        return mediaExist
    }
}
