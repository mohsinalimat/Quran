import Foundation
import AVFoundation
import UIKit
import Alamofire

class StudentMediaManager {
    typealias methodHandler2 = (_ status: Bool) -> Void
    
    static var mediaPlayer: AVAudioPlayer!
    static var btnMediaPlayPause: UIButton!
    static var mediaPlayMode = AudioPlayMode.Paused
    static var mediaFile = ""
    static var mediaLoaded = false
    
    static func playPauseMedia(mediaExist: Bool, btnPlayPause: UIButton) {
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
    static func playPauseStudentMedia(audioFile: String, btnPlayPause: UIButton) {
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
            mediaExist = loadStudentMedia(audioFile: audioFile, btnPlayPause: btnPlayPause)
        }

        playPauseMedia(mediaExist: mediaExist, btnPlayPause: btnPlayPause)
    }
    static func playPauseTeacherMedia(audioFile: String, btnPlayPause: UIButton) {
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
            mediaExist = loadTeacherMedia(audioFile: audioFile, btnPlayPause: btnPlayPause)
        }
        
        playPauseMedia(mediaExist: mediaExist, btnPlayPause: btnPlayPause)
    }
    static func stopMedia(audioFile: String, btnPlayPause: UIButton) {
        if mediaFile == audioFile && mediaLoaded {
            mediaFile = ""
            mediaLoaded = false
            mediaPlayMode = .Paused
            
            btnPlayPause.setImage(#imageLiteral(resourceName: "icn_PlaySmall"), for: .normal)
            mediaPlayer.stop()
        }
    }
    static func checkDownloadStudentMedia(audioFile: String, btnPlayPause: UIButton, completionHandler: @escaping methodHandler2) {
        let mediaPath = ApplicationMethods.getStudentAssignmentMediaPath(mediaName: audioFile)
        
        if DocumentManager.checkFileInApplicationDirectory(targetFilePath: mediaPath) == "" {
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
                    
                    if !status {
                        DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {})
                    }
                    
                    completionHandler(status)
                })
        }
        else {
            completionHandler(true)
        }
    }
    static func checkDownloadTeacherMedia(audioFile: String, btnPlayPause: UIButton, completionHandler: @escaping methodHandler2) {
        let mediaPath = ApplicationMethods.getTeacherAssignmentMediaPath(mediaName: audioFile)
        
        if DocumentManager.checkFileInApplicationDirectory(targetFilePath: mediaPath) == "" {
            btnPlayPause.setButtonDisabled()
            
            Alamofire
                .request(ApplicationMethods.getTeacherAssignmentRecordingWebUrl(mediaName: audioFile))
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
                    
                    if !status {
                        DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {})
                    }
                    
                    completionHandler(status)
                })
        }
        else {
            completionHandler(true)
        }
    }
    static func loadStudentMedia(audioFile: String, btnPlayPause: UIButton) -> Bool {
        var mediaExist = false

        do {
            let mediaPath = ApplicationMethods.getStudentAssignmentMediaPath(mediaName: audioFile)

            if DocumentManager.checkFileInApplicationDirectory(targetFilePath: mediaPath) != "" {
                let fileURL = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: mediaPath)

                mediaPlayer = try AVAudioPlayer(contentsOf: fileURL)
                mediaPlayer.delegate = ApplicationObject.CurrentViewController as? AVAudioPlayerDelegate
                
                btnMediaPlayPause = btnPlayPause
                mediaFile = audioFile
                mediaLoaded = true
                mediaExist = true
            }
            else {
                mediaFile = ""
                mediaLoaded = false
            }
        }
        catch {
            DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.INVALIDDATA, okHandler: {})
        }

        return mediaExist
    }
    static func loadTeacherMedia(audioFile: String, btnPlayPause: UIButton) -> Bool {
        var mediaExist = false
        
        do {
            let mediaPath = ApplicationMethods.getTeacherAssignmentMediaPath(mediaName: audioFile)
            
            if DocumentManager.checkFileInApplicationDirectory(targetFilePath: mediaPath) != "" {
                let fileURL = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: mediaPath)
                
                mediaPlayer = try AVAudioPlayer(contentsOf: fileURL)
                mediaPlayer.delegate = ApplicationObject.CurrentViewController as? AVAudioPlayerDelegate
                
                btnMediaPlayPause = btnPlayPause
                mediaFile = audioFile
                mediaLoaded = true
                mediaExist = true
            }
            else {
                mediaFile = ""
                mediaLoaded = false
            }
        }
        catch {
            DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.INVALIDDATA, okHandler: {})
        }
        
        return mediaExist
    }
}
