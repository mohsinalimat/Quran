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
    static var ayatRecitationSilence: Double = 0.0
    static var ayatRepeatFor: Int64 = 0
    static var rangeRecitationSilence: Double = 0.0
    static var rangeRepeatFor: Int64 = 0
    static var currentAyatRecitationSilence: Double = 0.0
    static var currentAyatRepeatFor: Int64 = 0
    static var currentRangeRecitationSilence: Double = 0.0
    static var currentRangeRepeatFor: Int64 = 0
    
    static func resetPlayer() {
        continuousRecitationModeOn = false
        ayatRecitationSilence = 0.0
        ayatRepeatFor = 0
        rangeRecitationSilence = 0.0
        rangeRepeatFor = 0
        currentAyatRecitationSilence = 0.0
        currentAyatRepeatFor = 0
        currentRangeRecitationSilence = 0.0
        currentRangeRepeatFor = 0
    }
    static func validatePlayer() -> Bool {
        var status = true
        
        if recitationList.count <= 0 {
            DialogueManager.showToast(viewController: ApplicationObject.MainViewController, sourceView: ApplicationObject.PlayButton, message: ApplicationInfoMessage.SELECT_AYAT)
            
            status = false
        }
        
        return status
    }
    static func getRecitationFileURL(recitationIndex: Int) -> URL {
        var fileURL = URL(fileURLWithPath: "")
        
        if recitationList.count > 0 {
            let recitationName = recitationList[recitationIndex]
            
            fileURL = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: ApplicationMethods.getRecitationPath(reciterId: ApplicationData.CurrentReciter.Id, recitationName: recitationName))
        }
        
        return fileURL
    }
    static func getRecitationName(recitationIndex: Int) -> String {
        var recitationName = ""
        
        if recitationList.count > 0 {
            recitationName = recitationList[recitationIndex]
        }
        
        return recitationName
    }
    static func getRecitation(recitationIndex: Int) -> Recitation {
        var recitationObject = Recitation()
        
        if recitationList.count > 0 {
            let recitationLabel = recitationList[recitationIndex]
            
            recitationObject = ApplicationMethods.getRecitaion(recitationLabel: recitationLabel)
        }
        
        return recitationObject
    }
    static func getRecitationCount() -> Int {
        return recitationList.count
    }
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
            
            enableNextButton()
            enablePreviousButton()
            
            break
        case .Play:
            ApplicationObject.RestartButton.setButtonEnabled()
            ApplicationObject.StopButton.setButtonEnabled()
            ApplicationObject.PauseButton.setButtonEnabled()
            ApplicationObject.PlayButton.setButtonDisabled()
            
            enableNextButton()
            enablePreviousButton()
            
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
            enableNextButton()
            enablePreviousButton()
            
            break
        case .Previous:
            enableNextButton()
            enablePreviousButton()
            
            break
        case .Restart:
            ApplicationObject.StopButton.setButtonEnabled()
            ApplicationObject.PauseButton.setButtonEnabled()
            ApplicationObject.PlayButton.setButtonDisabled()
            ApplicationObject.PreviousButton.setButtonDisabled()
            
            enableNextButton()
            enablePreviousButton()
            
            break
        }
    }
    static func enableNextButton() {
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
    }
    static func enablePreviousButton() {
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
    }
    
    static func playRecitation() {
        let status = validatePlayer()
        
        if !status {
            return
        }
        
        if !audioPlayerInitialized {
            let recitationName = recitationList[currentRecitationIndex]
            let fileURL = DocumentManager.getFileURLInApplicationDirectory(targetFilePath: ApplicationMethods.getRecitationPath(reciterId: ApplicationData.CurrentReciter.Id, recitationName: recitationName))
            
            do {
                ApplicationObject.RecitationAudioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                ApplicationObject.RecitationAudioPlayer.delegate = ApplicationObject.MainViewController
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
            if ayatRepeatFor > 0 {
                var listenRepeatInfo = "Ayat(\(currentAyatRepeatFor)/\(ayatRepeatFor))"
                
                if rangeRepeatFor > 0 {
                    listenRepeatInfo = listenRepeatInfo + " Range(\(currentRangeRepeatFor)/\(rangeRepeatFor))"
                }
                
                ApplicationObject.MainViewController.updateListenRepeatView(info: listenRepeatInfo)
            }
            
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
    static func nextRecitation(onAudioPlayFinish: Bool) {
        if recitationList.count <= 0 {
            return
        }
        
        audioPlayerInitialized = false
        
        if onAudioPlayFinish && currentAyatRepeatFor < ayatRepeatFor {
            currentAyatRepeatFor = currentAyatRepeatFor + 1
        }
        else {
            currentAyatRepeatFor = 1
            currentRecitationIndex = currentRecitationIndex + 1
        }
        
        if onAudioPlayFinish && ayatRepeatFor > 0 {
            let listenRepeatInfo = "Ayat(\(currentAyatRecitationSilence) sec)"
            
            ApplicationObject.MainViewController.updateListenRepeatView(info: listenRepeatInfo)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + currentAyatRecitationSilence, execute: {
                continueNextRecitation()
            })
        }
        else {
            continueNextRecitation()
        }
    }
    static func continueNextRecitation() {
        if currentRecitationIndex == recitationList.count {
            if continuousRecitationModeOn {
                currentPageIndex = currentPageIndex + 1
                
                if currentPageIndex != pageList.count {
                    loadPageForContinuousRecitation()
                    playRecitation()
                }
                else {
                    if rangeRepeatFor > 0 && currentRangeRepeatFor < rangeRepeatFor {
                        let listenRepeatInfo = "Range(\(currentRangeRecitationSilence) sec)"
                        
                        currentRangeRepeatFor = currentRangeRepeatFor + 1
                        
                        ApplicationObject.MainViewController.updateListenRepeatView(info: listenRepeatInfo)
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + currentRangeRecitationSilence, execute: {
                            startPlayRecitation()
                        })
                    }
                    else {
                        currentRangeRepeatFor = 1
                        currentPageIndex = 0
                        
                        if ayatRepeatFor > 0 || rangeRepeatFor > 0 {
                            ApplicationObject.MainViewController.hideMenu()
                        }
                        
                        loadPageForContinuousRecitation()
                        setPlayerMode(mode: .Ready)
                    }
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
        
        if ayatRepeatFor > 0 {
            currentAyatRepeatFor = 1
        }
        
        if rangeRepeatFor > 0 {
            currentRangeRepeatFor = 1
        }
        
        setPlayerMode(mode: .Stop)
        playRecitation()
        setPlayerMode(mode: .Restart)
    }
    
    static func setModeForContinuousRecitation(StartSurahId: Int64, EndSurahId: Int64, StartAyatOrderId: Int64, EndAyatOrderId: Int64, AyatRecitationSilence: Double, AyatRepeatFor: Int64, RangeRecitationSilence: Double, RangeRepeatFor: Int64) {
        startSurahId = StartSurahId
        endSurahId = EndSurahId
        startAyatOrderId = StartAyatOrderId
        endAyatOrderId = EndAyatOrderId
        ayatRecitationSilence = AyatRecitationSilence
        ayatRepeatFor = AyatRepeatFor
        rangeRecitationSilence = RangeRecitationSilence
        rangeRepeatFor = RangeRepeatFor
        currentAyatRecitationSilence = ayatRecitationSilence
        currentAyatRepeatFor = 1
        currentRangeRecitationSilence = rangeRecitationSilence
        currentRangeRepeatFor = 1
        pageList = PageRepository().getPageList(fromSurahId: startSurahId, toSurahId: endSurahId, startAyatOrderId: startAyatOrderId, endAyatOrderId: endAyatOrderId)
        
        if pageList.count > 0 {
            startPlayRecitation()
        }
    }
    static func startPlayRecitation() {
        currentPageIndex = 0
        continuousRecitationModeOn = true
        
        loadPageForContinuousRecitation()
        setPlayerMode(mode: .Ready)
        playRecitation()
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
