import Foundation
import AVFoundation

class RecitationManager {
    static var currentPlayerMode = AudioPlayerMode.None
    static var pageList = [Page]()
    static var recitationObjectList = [Recitation]()
    static var recitationList = [String]()
    static var startSurahId: Int64 = 0
    static var endSurahId: Int64 = 0
    static var startAyatOrderId: Int64 = 0
    static var endAyatOrderId: Int64 = 0
    static var currentPageIndex: Int = 0
    static var currentRecitationIndex = 0
    static var audioPlayerInitialized = false
    static var continuousRecitationModeOn = false
    
    static func appendRecitation(accessibilityLabel: String) {
        if !recitationList.contains(accessibilityLabel) {
            recitationList.append(accessibilityLabel)
        }
    }
    static func setPlayerMode(mode: AudioPlayerMode) {
        switch mode {
        case .None:
            ApplicationObject.RestartButton.setButtonEnabled()
            ApplicationObject.PreviousButton.setButtonEnabled()
            ApplicationObject.StopButton.setButtonEnabled()
            ApplicationObject.PlayButton.setButtonEnabled()
            ApplicationObject.PauseButton.setButtonEnabled()
            ApplicationObject.NextButton.setButtonEnabled()
            
            recitationList = [String]()
            currentRecitationIndex = 0
            
            if audioPlayerInitialized {
                audioPlayerInitialized = false
                ApplicationObject.RecitationAudioPlayer.currentTime = 0.0
                
                ApplicationObject.RecitationAudioPlayer.stop()
            }
            
            break
        case .Ready:
            ApplicationObject.PlayButton.setButtonEnabled()
            ApplicationObject.RestartButton.setButtonDisabled()
            ApplicationObject.PreviousButton.setButtonDisabled()
            ApplicationObject.StopButton.setButtonDisabled()
            ApplicationObject.PauseButton.setButtonDisabled()
            
            if recitationList.count > 1 {
                ApplicationObject.NextButton.setButtonEnabled()
            }
            else {
                ApplicationObject.NextButton.setButtonDisabled()
            }
            
            break
        case .Play:
            ApplicationObject.RestartButton.setButtonEnabled()
            ApplicationObject.StopButton.setButtonEnabled()
            ApplicationObject.PauseButton.setButtonEnabled()
            ApplicationObject.PlayButton.setButtonDisabled()
            
            if audioPlayerInitialized {
                ApplicationObject.RecitationAudioPlayer.play()
            }
            
            break
        case .Pause:
            ApplicationObject.PlayButton.setButtonEnabled()
            ApplicationObject.StopButton.setButtonEnabled()
            ApplicationObject.PauseButton.setButtonDisabled()
            
            if audioPlayerInitialized {
                ApplicationObject.RecitationAudioPlayer.pause()
            }
            
            break
        case .Stop:
            ApplicationObject.PlayButton.setButtonEnabled()
            ApplicationObject.StopButton.setButtonDisabled()
            ApplicationObject.PauseButton.setButtonDisabled()
            
            if audioPlayerInitialized {
                ApplicationObject.RecitationAudioPlayer.currentTime = 0.0
                
                ApplicationObject.RecitationAudioPlayer.stop()
            }
            
            break
        case .Next:
            if currentRecitationIndex == (recitationList.count - 1) {
                if continuousRecitationModeOn && currentPageIndex != (pageList.count - 1) {
                    ApplicationObject.NextButton.setButtonEnabled()
                }
                else {
                    ApplicationObject.NextButton.setButtonDisabled()
                }
            }
            else {
                ApplicationObject.NextButton.setButtonEnabled()
            }
            
            if currentRecitationIndex == 0 {
                if continuousRecitationModeOn && currentPageIndex != 0 {
                    ApplicationObject.PreviousButton.setButtonEnabled()
                }
                else {
                    ApplicationObject.PreviousButton.setButtonDisabled()
                }
            }
            else {
                ApplicationObject.PreviousButton.setButtonEnabled()
            }
            
            break
        case .Previous:
            if currentRecitationIndex == (recitationList.count - 1) {
                if continuousRecitationModeOn && currentPageIndex != (pageList.count - 1) {
                    ApplicationObject.NextButton.setButtonEnabled()
                }
                else {
                    ApplicationObject.NextButton.setButtonDisabled()
                }
            }
            else {
                ApplicationObject.NextButton.setButtonEnabled()
            }
            
            if currentRecitationIndex == 0 {
                if continuousRecitationModeOn && currentPageIndex != 0 {
                    ApplicationObject.PreviousButton.setButtonEnabled()
                }
                else {
                    ApplicationObject.PreviousButton.setButtonDisabled()
                }
            }
            else {
                ApplicationObject.PreviousButton.setButtonEnabled()
            }
            
            break
        case .Restart:
            ApplicationObject.StopButton.setButtonEnabled()
            ApplicationObject.PauseButton.setButtonEnabled()
            ApplicationObject.PlayButton.setButtonDisabled()
            ApplicationObject.PreviousButton.setButtonDisabled()
            
            if recitationList.count > 1 {
                ApplicationObject.NextButton.setButtonEnabled()
            }
            else {
                ApplicationObject.NextButton.setButtonDisabled()
            }
            
            break
        }
    }
    static func playRecitation() {
        if recitationList.count <= 0 {
            DialogueManager.showToast(viewController: ApplicationObject.MainViewController, sourceView: ApplicationObject.PlayButton, message: ApplicationInfoMessage.SELECT_AYAT)
            
            return
        }
        
        if !audioPlayerInitialized {
            let recitationName = recitationList[currentRecitationIndex]
            let fileURL = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: ApplicationMethods.getRecitationPath(reciterId: ApplicationData.CurrentReciter.Id, recitationName: recitationName))
            
            do {
                ApplicationObject.RecitationAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                ApplicationObject.RecitationAudioPlayer.delegate = ApplicationObject.MainViewController as? AVAudioPlayerDelegate
                audioPlayerInitialized = true
                
                AyatSelectionManager.highlightAyatSelection(recitationName: recitationName)
            }
            catch {
                ApplicationData.CurrentDownloadMode = .Audio
                ApplicationData.CurrentDownloadCategoryMode = .Page
                ApplicationData.CurrentDownloadPageMode = DownloadPageMode.Confirm.hashValue
                
                ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueDownloadPage", sender: nil)
            }
        }
        
        if audioPlayerInitialized {
            setPlayerMode(mode: .Play)
        }
    }
    static func stopRecitation() {
        if recitationList.count <= 0 {
            return
        }
        
        setPlayerMode(mode: .Stop)
    }
    static func pauseRecitation() {
        if recitationList.count <= 0 {
            return
        }
        
        setPlayerMode(mode: .Pause)
    }
    static func nextRecitation() {
        if recitationList.count <= 0 {
            return
        }
        
        audioPlayerInitialized = false
        currentRecitationIndex = currentRecitationIndex + 1
        
        if currentRecitationIndex == recitationList.count {
            if continuousRecitationModeOn {
                currentPageIndex = currentPageIndex + 1
                
                if currentPageIndex != pageList.count {
                    loadPageForContinuousRecitation()
                    playRecitation()
                }
                else {
                    currentPageIndex = 0
                    
                    loadPageForContinuousRecitation()
                    setPlayerMode(mode: .Ready)
                }
            }
            else {
                currentRecitationIndex = 0
                
                setPlayerMode(mode: .Ready)
                AyatSelectionManager.highlightAyatSelection(recitationName: RecitationManager.recitationList.first!)
            }
        }
        else {
            setPlayerMode(mode: .Stop)
            playRecitation()
            setPlayerMode(mode: .Next)
        }
    }
    static func previousRecitation() {
        if recitationList.count <= 0 {
            return
        }
        
        audioPlayerInitialized = false
        currentRecitationIndex = currentRecitationIndex - 1
        
        if continuousRecitationModeOn && currentRecitationIndex < 0 && currentPageIndex != 0 {
            currentPageIndex = currentPageIndex - 1
            
            loadPageForContinuousRecitation()
            
            currentRecitationIndex = recitationList.count - 1
        }
        
        setPlayerMode(mode: .Stop)
        playRecitation()
        setPlayerMode(mode: .Previous)
    }
    static func restartRecitation() {
        if recitationList.count <= 0 {
            return
        }
        
        audioPlayerInitialized = false
        currentRecitationIndex = 0
        
        if continuousRecitationModeOn {
            currentPageIndex = 0
            
            loadPageForContinuousRecitation()
        }
        
        setPlayerMode(mode: .Stop)
        playRecitation()
        setPlayerMode(mode: .Restart)
    }
    static func setModeForContinuousRecitation(StartSurahId: Int64, EndSurahId: Int64, StartAyatOrderId: Int64, EndAyatOrderId: Int64) {
        startSurahId = StartSurahId
        endSurahId = EndSurahId
        startAyatOrderId = StartAyatOrderId
        endAyatOrderId = EndAyatOrderId
        pageList = PageRepository().getPageList(fromSurahId: startSurahId, toSurahId: endSurahId)
        
        if pageList.count > 0 {
            currentPageIndex = 0
            continuousRecitationModeOn = true
            
            loadPageForContinuousRecitation()
            setPlayerMode(mode: .Ready)
            playRecitation()
        }
    }
    static func loadPageForContinuousRecitation() {
        if currentPageIndex == 0 {
            if pageList.count == 1 {
                recitationObjectList = RecitationRepository().getRecitationList(fromSurahId: startSurahId, toSurahId: endSurahId, fromAyatOrderId: startAyatOrderId, toAyatOrderId: endAyatOrderId)
            }
            else {
                recitationObjectList = RecitationRepository().getRecitationList(pageId: pageList[currentPageIndex].Id, fromSurahId: startSurahId, fromAyatOrderId: startAyatOrderId)
            }
        }
        else if currentPageIndex == (pageList.count - 1) {
            recitationObjectList = RecitationRepository().getRecitationList(pageId: pageList[currentPageIndex].Id, toSurahId: endSurahId, toAyatOrderId: endAyatOrderId)
        }
        else {
            recitationObjectList = RecitationRepository().getRecitationList(pageId: pageList[currentPageIndex].Id)
        }
        
        PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageList[currentPageIndex].Id)
        AyatSelectionManager.highlightAyatSelectionRange(recitationList: recitationObjectList)
    }
}
