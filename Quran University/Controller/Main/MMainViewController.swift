import UIKit
import Alamofire
import AVFoundation

class MMainViewController: BaseViewController, ModalDialogueProtocol, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    // ********** Header Section ********** //
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnSurah: UIButton!
    @IBOutlet weak var btnPage: UIButton!
    @IBOutlet weak var btnJuzz: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    @IBOutlet weak var btnPageLock: UIButton!
    
    // ********** Top Menu Section ********** //
    @IBOutlet var vTopMenu: UIView!
    @IBOutlet weak var btnReciter: QUButton!
    @IBOutlet weak var btnSetting: QUButton!
    @IBOutlet weak var btnDownload: QUButton!
    
    // ********** Content Section ********** //
    @IBOutlet weak var ivQuranPage: UIImageView!
    
    // ********** Footer Section ********** //
    @IBOutlet weak var vFooter: UIView!
    @IBOutlet weak var btnLMenu: UIButton!
    @IBOutlet weak var btnRMenu: UIButton!
    
    // ********** Footer Player Section ********** //
    @IBOutlet weak var vPlayer: UIView!
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    // ********** Footer Recording Section ********** //
    @IBOutlet weak var vRecording: UIView!
    @IBOutlet weak var btnRRefresh: UIButton!
    @IBOutlet weak var btnRRecord: UIButton!
    @IBOutlet weak var btnRStop: UIButton!
    @IBOutlet weak var btnGPlay: UIButton!
    @IBOutlet weak var btnGRefresh: UIButton!
    
    // ********** Base Left Menu Section ********** //
    @IBOutlet var vBaseLeftMenu: UIView!
    
    // ********** Base Right Menu Section ********** //
    @IBOutlet var vBaseRightMenu: UIView!
    @IBOutlet var vListenRepeat: UIView!
    @IBOutlet var vRecordCompare: RecordCompareView!
    @IBOutlet weak var lblListenRepeatInfo: UILabel!
    
    var startTouchPoint = CGPoint()
    var startDate = Date()
    var pageLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        ApplicationObject.MainViewController = self
        ApplicationObject.QuranPageImageView = ivQuranPage
        ApplicationObject.SurahButton = btnSurah
        ApplicationObject.PageButton = btnPage
        ApplicationObject.JuzzButton = btnJuzz
        ApplicationObject.RestartButton = btnRefresh
        ApplicationObject.PreviousButton = btnPrevious
        ApplicationObject.StopButton = btnStop
        ApplicationObject.PlayButton = btnPlay
        ApplicationObject.PauseButton = btnPause
        ApplicationObject.NextButton = btnNext
        
        PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: ApplicationData.CurrentPage.Id)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pageLocked {
            if let touch = touches.first {
                if touch.view != vTopMenu {
                    hideMenu()
                }
                
                if touch.view == ivQuranPage {
                    startTouchPoint = touch.location(in: self.ivQuranPage)
                    RecitationManager.resetPlayer()
                    RecitationManager.setPlayerMode(mode: .None)
                    AyatSelectionManager.showHideAyatSelection(startTouchPoint: startTouchPoint, lastTouchPoint: startTouchPoint, touchMoving: false)
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pageLocked {
            if let touch = touches.first {
                if touch.view == ivQuranPage {
                    let currentTouchPoint = touch.location(in: self.ivQuranPage)
                    
                    AyatSelectionManager.showHideAyatSelection(startTouchPoint: startTouchPoint, lastTouchPoint: currentTouchPoint, touchMoving: true)
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pageLocked {
            if let touch = touches.first {
                if touch.view == ivQuranPage && RecitationManager.recitationList.first != nil {
                    RecitationManager.setPlayerMode(mode: .Ready)
                    AyatSelectionManager.highlightAyatSelection(recitationName: RecitationManager.recitationList.first!)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDropDown" {
            let viewController = segue.destination as! UCDropDownViewController
            
            switch ApplicationData.CurrentDownloadCategoryMode {
            case .Surah:
                viewController.selectedValue = ApplicationData.CurrentSurah.Id
                viewController.dataList = SurahRepository().getSurahList()
                
                break
            case .Juzz:
                viewController.selectedValue = ApplicationData.CurrentJuzz.Id
                viewController.dataList = JuzzRepository().getJuzzList()
            
                break
            default:
                break
            }
        }
        else if segue.identifier == "SegueDualDropDown" {
            let viewController = segue.destination as! UCDualDropDownViewController
            
            switch ApplicationData.CurrentDownloadCategoryMode {
            case .Page:
                viewController.primaryValue = ApplicationData.CurrentPage.Id
                viewController.secondaryValue = ApplicationData.CurrentPageGroup.Id
                viewController.primaryDataList = PageRepository().getPageList()
                viewController.secondaryDataList = PageRepository().getPageGroupList()
                
                break
            default:
                break
            }
        }
    }
    
    @objc func cbShowQuranPage() {
        PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: ApplicationData.CurrentPage.Id)
    }
    
    func onDoneHandler(Id: Int64) {
        if Id > 0 {
            switch ApplicationData.CurrentDownloadCategoryMode {
            case .Surah:
                ApplicationData.CurrentPage = PageRepository().getFirstPage(surahId: Id)
                
                perform(#selector(cbShowQuranPage), with: nil, afterDelay: 0.25)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
                    ApplicationData.CurrentSurah = SurahRepository().getSurah(Id: Id)
                    
                    self.btnSurah.setTitle(ApplicationData.CurrentSurah.Name, for: .normal)
                })
                
                break
            case .Juzz:
                ApplicationData.CurrentPage = PageRepository().getFirstPage(juzzId: Id)
                
                perform(#selector(cbShowQuranPage), with: nil, afterDelay: 0.25)
                
                break
            default:
                break
            }
        }
    }
    func onDoneHandler(PriId: Int64, SecId: Int64) {
        if PriId > 0 && SecId > 0 {
            switch ApplicationData.CurrentDownloadCategoryMode {
            case .Page:
                ApplicationData.CurrentPage = PageRepository().getPage(Id: PriId)
                
                perform(#selector(cbShowQuranPage), with: nil, afterDelay: 0.25)
                
                break
            default:
                break
            }
        }
    }
    func onDoneHandler(StartSurahId: Int64, EndSurahId: Int64, StartAyatOrderId: Int64, EndAyatOrderId: Int64, AyatRecitationSilence: Double, AyatRepeatFor: Int64, RangeRecitationSilence: Double, RangeRepeatFor: Int64) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {
            RecitationManager.setModeForContinuousRecitation(StartSurahId: StartSurahId, EndSurahId: EndSurahId, StartAyatOrderId: StartAyatOrderId, EndAyatOrderId: EndAyatOrderId, AyatRecitationSilence: AyatRecitationSilence, AyatRepeatFor: AyatRepeatFor, RangeRecitationSilence: RangeRecitationSilence, RangeRepeatFor: RangeRepeatFor)
        })
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        RecitationManager.nextRecitation(onAudioPlayFinish: true)
    }
    
    func setLayout() {
        var x = vHeader.frame.origin.x
        var y = vHeader.frame.origin.y + vHeader.bounds.height
        var height = vTopMenu.frame.size.height
        var width = vHeader.frame.size.width
        
        vTopMenu.tag = ViewTag.TopMenu.rawValue
        vTopMenu.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vTopMenu)
        
        x = vHeader.frame.origin.x
        y = vHeader.frame.origin.y + vHeader.bounds.height
        height = vRecordCompare.frame.size.height
        width = vRecordCompare.frame.size.width
        
        vRecordCompare.tag = ViewTag.RecordCompare.rawValue
        vRecordCompare.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vRecordCompare)
        
        x = vFooter.frame.origin.x
        y = vFooter.frame.origin.y - vBaseLeftMenu.bounds.height
        height = vBaseLeftMenu.frame.size.height
        width = vFooter.frame.size.width
        
        vBaseLeftMenu.tag = ViewTag.BaseLeftMenu.rawValue
        vBaseLeftMenu.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vBaseLeftMenu)
        
        x = vFooter.frame.origin.x
        y = vFooter.frame.origin.y - vBaseRightMenu.bounds.height
        height = vBaseRightMenu.frame.size.height
        width = vFooter.frame.size.width
        
        vBaseRightMenu.tag = ViewTag.BaseRightMenu.rawValue
        vBaseRightMenu.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vBaseRightMenu)
        
        x = vFooter.frame.origin.x
        y = vFooter.frame.origin.y - vListenRepeat.bounds.height
        height = vListenRepeat.frame.size.height
        width = vFooter.frame.size.width
        
        vListenRepeat.tag = ViewTag.ListenRepeat.rawValue
        vListenRepeat.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vListenRepeat)
    }
    func hideMenu() {
        self.view.viewWithTag(ViewTag.TopMenu.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.BaseLeftMenu.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.BaseRightMenu.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.ListenRepeat.rawValue)?.isHidden = true
    }
    func hideMenu(tag: Int) {
        hideMenu()
        
        self.view.viewWithTag(tag)?.isHidden = true
    }
    func showMenu(tag: Int) {
        if self.view.viewWithTag(tag)?.isHidden == false {
            hideMenu()
        }
        else {
            hideMenu()
            
            self.view.viewWithTag(tag)?.isHidden = false
        }
    }
    func updateListenRepeatView(info: String) {
        self.view.viewWithTag(ViewTag.ListenRepeat.rawValue)?.isHidden = false
        lblListenRepeatInfo.text = info
    }
    func setFooterMode(currentFooterSectionMode: FooterSectionMode) {
        vPlayer.isHidden = true
        vRecording.isHidden = true
        
        setViewForFooterMode(isUserInteractionEnabled: true)
        
        switch currentFooterSectionMode {
        case .Player:
            vPlayer.isHidden = false
            
            break
        case .Recording:
            vRecording.isHidden = false
            
            setViewForFooterMode(isUserInteractionEnabled: false)
            setRecordCompareMode(currentRecordCompareMode: .Ready)
            
            break
        }
    }
    func setRecordCompareMode(currentRecordCompareMode: RecordCompareMode) {
        btnRRefresh.isEnabled = false
        btnRRecord.isEnabled = false
        btnRStop.isEnabled = false
        btnGPlay.isEnabled = false
        btnGRefresh.isEnabled = false
        
        switch currentRecordCompareMode {
        case .Ready:
            btnRRecord.isEnabled = true
            
            break
        case .RRefresh:
            btnRRefresh.isEnabled = true
            btnRStop.isEnabled = true
            
            break
        case .RRecord:
            btnRRefresh.isEnabled = true
            btnRStop.isEnabled = true
            
            break
        case .RStop:
            btnRRefresh.isEnabled = true
            btnGPlay.isEnabled = true
            
            break
        case .GPlay:
            btnRRefresh.isEnabled = true
            btnGRefresh.isEnabled = true
            
            break
        case .GRefresh:
            btnRRefresh.isEnabled = true
            btnGRefresh.isEnabled = true
            
            break
        }
    }
    func setViewForFooterMode(isUserInteractionEnabled: Bool) {
        vHeader.isUserInteractionEnabled = isUserInteractionEnabled
        ivQuranPage.isUserInteractionEnabled = isUserInteractionEnabled
        btnLMenu.isUserInteractionEnabled = isUserInteractionEnabled
        btnRMenu.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    // ********** Header Section ********** //
    @IBAction func btnMenu_TouchUp(_ sender: UIButton) {
        btnReciter.setTitle(ApplicationData.CurrentReciter.Name, for: .normal)
        showMenu(tag: ViewTag.TopMenu.rawValue)
    }
    @IBAction func btnSurah_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        ApplicationData.CurrentDownloadCategoryMode = .Surah
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnPage_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        ApplicationData.CurrentDownloadCategoryMode = .Page
        
        self.performSegue(withIdentifier: "SegueDualDropDown", sender: nil)
    }
    @IBAction func btnJuzz_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        ApplicationData.CurrentDownloadCategoryMode = .Juzz
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnPageLock_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        pageLocked = !pageLocked
        
        if pageLocked {
            let image = UIImage(named: "img_Lock")
            
            btnPageLock.setImage(image, for: .normal)
        }
        else {
            let image = UIImage(named: "img_Unlock")
            
            btnPageLock.setImage(image, for: .normal)
        }
    }
    
    // ********** Top Menu Section ********** //
    @IBAction func btnReciter_TouchUp(_ sender: Any) {
        hideMenu()
        
        self.performSegue(withIdentifier: "SegueAvailableReciter", sender: nil)
    }
    @IBAction func btnSetting_TouchUp(_ sender: Any) {
        hideMenu()
    }
    @IBAction func btnDownload_TouchUp(_ sender: Any) {
        hideMenu()
        
        self.performSegue(withIdentifier: "SegueDownload", sender: nil)
    }
    
    // ********** Content Section ********** //
    @IBAction func sgrLeft_Performed(_ sender: UISwipeGestureRecognizer) {
        hideMenu()

        if !pageLocked {
            if sender.state == .ended {
                let pageId = PageRepository().getPreviousPage(Id: ApplicationData.CurrentPage.Id).Id

                PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageId)
            }
        }
    }
    @IBAction func sgrRight_Performed(_ sender: UISwipeGestureRecognizer) {
        hideMenu()

        if !pageLocked {
            if sender.state == .ended {
                let pageId = PageRepository().getNextPage(Id: ApplicationData.CurrentPage.Id).Id

                PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageId)
            }
        }
    }
    
    // ********** Footer Section ********** //
    @IBAction func btnLMenu_TouchUp(_ sender: UIButton) {
        showMenu(tag: ViewTag.BaseLeftMenu.rawValue)
    }
    @IBAction func btnRMenu_TouchUp(_ sender: UIButton) {
        showMenu(tag: ViewTag.BaseRightMenu.rawValue)
    }
    
    // ********** Footer Player Section ********** //
    @IBAction func btnRefresh_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        RecitationManager.restartRecitation()
    }
    @IBAction func btnPrevious_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        RecitationManager.previousRecitation()
    }
    @IBAction func btnStop_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        RecitationManager.stopRecitation()
    }
    @IBAction func btnPlay_TouchDown(_ sender: Any) {
        hideMenu()
        
        startDate = Date()
    }
    @IBAction func btnPlay_TouchUp(_ sender: UIButton) {
        let timeInterval = Date().timeIntervalSince(startDate)
        
        if timeInterval >= 1 {
            self.performSegue(withIdentifier: "SegueContinuousRecitation", sender: nil)
        }
        else {
            RecitationManager.playRecitation()
        }
    }
    @IBAction func btnPause_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        RecitationManager.pauseRecitation()
    }
    @IBAction func btnNext_TouchUp(_ sender: UIButton) {
        hideMenu()
        
        RecitationManager.nextRecitation(onAudioPlayFinish: false)
    }
    
    // ********** Footer Recording Section ********** //
    @IBAction func btnRRefresh_TouchUp(_ sender: Any) {
        vRecordCompare.startRecording()
    }
    @IBAction func btnRRecord_TouchUp(_ sender: Any) {
        showMenu(tag: ViewTag.RecordCompare.rawValue)
        setRecordCompareMode(currentRecordCompareMode: .RRecord)
        vRecordCompare.loadView()
    }
    @IBAction func btnRStop_TouchUp(_ sender: Any) {
        vRecordCompare.finishRecording()
    }
    @IBAction func btnGPlay_TouchUp(_ sender: Any) {
        vRecordCompare.playPauseRecording()
    }
    @IBAction func btnGRefresh_TouchUp(_ sender: Any) {
        vRecordCompare.playPauseRecording()
    }
    
    // ********** Base Right Menu Section ********** //
    @IBAction func btnRecordCompare_TouchUp(_ sender: Any) {
        hideMenu()
        
        if RecitationManager.validatePlayer() {
            let startAyatOrderId = RecitationManager.getRecitation(recitationIndex: 0).AyatOrderId
            let endAyatOrderId = RecitationManager.getRecitation(recitationIndex: (RecitationManager.getRecitationCount() - 1)).AyatOrderId
            
            if DocumentManager.checkFilesExistForSurahAyatOrderRange(startSurahId: ApplicationData.CurrentSurah.Id, endSurahId: ApplicationData.CurrentSurah.Id, startAyatOrderId: startAyatOrderId, endAyatOrderId: endAyatOrderId) {
                
                setFooterMode(currentFooterSectionMode: .Recording)
            }
            else {
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.AYAT_MISSING_DOWNLOAD_SCRIPT_RECITATION, okHandler: {})
            }
        }
    }
    @IBAction func btnListenRepeat_TouchUp(_ sender: Any) {
        hideMenu()
        
        self.performSegue(withIdentifier: "SegueListenRepeat", sender: nil)
    }
}
