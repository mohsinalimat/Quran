import Foundation
import AVFoundation

class PermissionManager {
    typealias methodHandler1 = () -> Void
    
    static var recordingSession: AVAudioSession!
    
    static func requestRecordPermission(successHandler: @escaping methodHandler1, errorHandler: @escaping methodHandler1) {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { allowed in
                DispatchQueue.main.async {
                    if allowed {
                        successHandler()
                    } else {
                        DialogueManager.showInfo(viewController: ApplicationObject.CurrentViewController, message: ApplicationInfoMessage.ACCESS_MICROPHONE, okHandler: {
                            errorHandler()
                            ApplicationMethods.showSetting()
                        })
                    }
                }
            }
        }
        catch {
            errorHandler()
        }
    }
}
