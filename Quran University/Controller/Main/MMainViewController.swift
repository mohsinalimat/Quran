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
    
    // ********** Footer Record & Compare Section ********** //
    @IBOutlet weak var vRecording: UIView!
    @IBOutlet weak var btnRRefresh: UIButton!
    @IBOutlet weak var btnRRecord: UIButton!
    @IBOutlet weak var btnRStop: UIButton!
    @IBOutlet weak var btnGPlay: UIButton!
    @IBOutlet weak var btnGRefresh: UIButton!
    
    // ********** Footer Assignment Record & Upload Section ********** //
    @IBOutlet weak var vAssignmentRecording: UIView!
    @IBOutlet var vRecordAssignment: RecordAssignmentView!
    @IBOutlet var vUploadAssignment: UploadAssignmentView!
    @IBOutlet weak var btnARecord: UIButton!
    @IBOutlet weak var btnAPlay: UIButton!
    @IBOutlet weak var btnAUpload: UIButton!
    
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
                if ivQuranPage.isUserInteractionEnabled &&
                    touch.view != vTopMenu &&
                    touch.view != vRecordAssignment &&
                    touch.view?.superview?.tag != ViewTag.RecordAssignment.rawValue &&
                    touch.view?.superview?.superview?.tag != ViewTag.RecordAssignment.rawValue {
                    hideMenu()
                }
                
                if touch.view == ivQuranPage {
                    startTouchPoint = touch.location(in: self.ivQuranPage)
                    
                    if !ApplicationData.CorrectionModeOn {
                        RecitationManager.resetPlayer()
                        RecitationManager.setPlayerMode(mode: .None)
                        AyatSelectionManager.showHideAyatSelection(startTouchPoint: startTouchPoint, lastTouchPoint: startTouchPoint, touchMoving: false)
                    }
                }
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pageLocked {
            if let touch = touches.first {
                if touch.view == ivQuranPage && !ApplicationData.CorrectionModeOn {
                    let currentTouchPoint = touch.location(in: self.ivQuranPage)
                    
                    AyatSelectionManager.showHideAyatSelection(startTouchPoint: startTouchPoint, lastTouchPoint: currentTouchPoint, touchMoving: true)
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !pageLocked {
            if let touch = touches.first {
                if touch.view == ivQuranPage {
                    if ApplicationData.CorrectionModeOn {
                        let touchPoint = touch.location(in: self.ivQuranPage)
                        
                        if startTouchPoint == touchPoint {
                            DialogueManager.showInfo(viewController: self, message: "Alert", okHandler: {})
                        }
                    }
                    else if RecitationManager.recitationList.first != nil {
                        setFooterMode(currentFooterSectionMode: .Player, enableQuranPageUserInteraction: true)
                        RecitationManager.setPlayerMode(mode: .Ready)
                        AyatSelectionManager.highlightAyatSelection(recitationName: RecitationManager.recitationList.first!)
                    }
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        self.hideMenu()
        
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
        
        x = vFooter.frame.origin.x
        y = vFooter.frame.origin.y - vRecordAssignment.bounds.height
        height = vRecordAssignment.frame.size.height
        width = vFooter.frame.size.width
        
        vRecordAssignment.tag = ViewTag.RecordAssignment.rawValue
        vRecordAssignment.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vRecordAssignment)
        
        x = ivQuranPage.frame.origin.x
        y = (ivQuranPage.frame.origin.y + (ivQuranPage.frame.size.height / 2)) - (vUploadAssignment.bounds.height / 2)
        height = vUploadAssignment.frame.size.height
        width = ivQuranPage.frame.size.width
        
        vUploadAssignment.tag = ViewTag.UploadAssignment.rawValue
        vUploadAssignment.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.view.addSubview(vUploadAssignment)
    }
    func hideMenu() {
        self.view.viewWithTag(ViewTag.TopMenu.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.BaseLeftMenu.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.BaseRightMenu.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.ListenRepeat.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.RecordAssignment.rawValue)?.isHidden = true
        self.view.viewWithTag(ViewTag.UploadAssignment.rawValue)?.isHidden = true
    }
    func hideMenu(tag: Int) {
        hideMenu()
        
        self.view.viewWithTag(tag)?.isHidden = true
    }
    func showMenu(tag: Int) {
        hideMenu()
        
        self.view.viewWithTag(tag)?.isHidden = false
    }
    func showHideMenu(tag: Int) {
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
    func setFooterMode(currentFooterSectionMode: FooterSectionMode, enableQuranPageUserInteraction: Bool) {
        vPlayer.isHidden = true
        vRecording.isHidden = true
        vAssignmentRecording.isHidden = true
        
        setViewForFooterMode(isUserInteractionEnabled: true)
        
        switch currentFooterSectionMode {
        case .Player:
            vPlayer.isHidden = false
            
            break
        case .Recording:
            vRecording.isHidden = false
            
            setViewForFooterMode(isUserInteractionEnabled: false)
            setRecordCompareMode(currentRecordCompareMode: .Ready)
            
            if enableQuranPageUserInteraction {
                ivQuranPage.isUserInteractionEnabled = true
            }
            
            break
        case .AssignmentRecording:
            vAssignmentRecording.isHidden = false
            vRecordAssignment.recordingLoaded = false
            
            setRecordUploadFooter()
            
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
            
            if vRecordCompare.onlyRecordModeOn && vRecordCompare.currentRecitationIndex < (vRecordCompare.totalRecitation - 1) {
                btnRStop.isEnabled = true
            }
            else {
                btnGPlay.isEnabled = true
            }
            
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
    func setRecordUploadFooter() {
        if ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Accepted.rawValue ||
            ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Submitted.rawValue ||
            ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Resubmitted.rawValue {
            btnARecord.isEnabled = false
            btnAPlay.isEnabled = true
            btnAUpload.isEnabled = false
        }
        else {
            btnARecord.isEnabled = true
            
            if AssignmentManager.assignmentRecordingExist() {
                btnAPlay.isEnabled = true
                btnAUpload.isEnabled = true
            }
            else {
                btnAPlay.isEnabled = false
                btnAUpload.isEnabled = false
            }
        }
    }
    func setRecordUploadMode(currentRecordUploadMode: RecordUploadMode) {
        btnARecord.setImage(#imageLiteral(resourceName: "icn_RecordCircle"), for: .normal)
        btnAPlay.setImage(#imageLiteral(resourceName: "icn_PlayCircle"), for: .normal)
        btnAPlay.loadingIndicator(false)
        setViewForFooterMode(isUserInteractionEnabled: true)
        
        btnARecord.isEnabled = false
        btnAPlay.isEnabled = false
        btnAUpload.isEnabled = false
        
        switch currentRecordUploadMode {
        case .Record:
            btnARecord.isEnabled = true
            
            btnARecord.setImage(#imageLiteral(resourceName: "icn_StopCircle"), for: .normal)
            setViewForFooterMode(isUserInteractionEnabled: false)
            AssignmentManager.markAssignment()
            
            break
        case .Stop:
            btnARecord.isEnabled = true
            btnAPlay.isEnabled = true
            btnAUpload.isEnabled = true
            
            AssignmentManager.highlightAssignment()
            
            break
        case .Play:
            btnAPlay.isEnabled = true
            
            btnAPlay.setImage(#imageLiteral(resourceName: "icn_PauseCircle"), for: .normal)
            setViewForFooterMode(isUserInteractionEnabled: false)
            
            break
        case .Pause:
            btnARecord.isEnabled = true
            btnAPlay.isEnabled = true
            btnAUpload.isEnabled = true
            
            break
        case .Download:
            hideMenu(tag: ViewTag.RecordAssignment.rawValue)
            btnAPlay.loadingIndicator(true)
            
            break
        case .Upload:
            setViewForFooterMode(isUserInteractionEnabled: false)
            
            break
        }

        if ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Accepted.rawValue ||
            ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Submitted.rawValue ||
            ApplicationData.CurrentAssignment.AssignmentStatusId == AssignmentStatus.Resubmitted.rawValue {
            btnARecord.isEnabled = false
            btnAPlay.isEnabled = true
            btnAUpload.isEnabled = false
        }
    }
    
    // ********** Header Section ********** //
    @IBAction func btnMenu_TouchUp(_ sender: UIButton) {
        btnReciter.setTitle(ApplicationData.CurrentReciter.Name, for: .normal)
        showHideMenu(tag: ViewTag.TopMenu.rawValue)
    }
    @IBAction func btnSurah_TouchUp(_ sender: UIButton) {
        AssignmentManager.unloadAssignmentMode(completionHandler: {
            ApplicationData.CurrentDownloadCategoryMode = .Surah
            
            self.hideMenu()
            self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
        })
    }
    @IBAction func btnPage_TouchUp(_ sender: UIButton) {
        AssignmentManager.unloadAssignmentMode(completionHandler: {
            ApplicationData.CurrentDownloadCategoryMode = .Page
            
            self.hideMenu()
            self.performSegue(withIdentifier: "SegueDualDropDown", sender: nil)
        })
    }
    @IBAction func btnJuzz_TouchUp(_ sender: UIButton) {
        AssignmentManager.unloadAssignmentMode(completionHandler: {
            ApplicationData.CurrentDownloadCategoryMode = .Juzz
            
            self.hideMenu()
            self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
        })
    }
    @IBAction func btnPageLock_TouchUp(_ sender: UIButton) {
        self.hideMenu()
        
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
        self.hideMenu()
        self.performSegue(withIdentifier: "SegueAvailableReciter", sender: nil)
    }
    @IBAction func btnSetting_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func btnDownload_TouchUp(_ sender: Any) {
        self.hideMenu()
        self.performSegue(withIdentifier: "SegueDownload", sender: nil)
    }
    
    // ********** Content Section ********** //
    @IBAction func sgrLeft_Performed(_ sender: UISwipeGestureRecognizer) {
        self.hideMenu()

        if !pageLocked {
            if sender.state == .ended {
                AssignmentManager.unloadAssignmentMode(completionHandler: {
                    let pageId = PageRepository().getPreviousPage(Id: ApplicationData.CurrentPage.Id).Id
                    
                    PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageId)
                })
            }
        }
    }
    @IBAction func sgrRight_Performed(_ sender: UISwipeGestureRecognizer) {
        self.hideMenu()

        if !pageLocked {
            if sender.state == .ended {
                AssignmentManager.unloadAssignmentMode(completionHandler: {
                    let pageId = PageRepository().getNextPage(Id: ApplicationData.CurrentPage.Id).Id
                    
                    PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: pageId)
                })
            }
        }
    }
    
    // ********** Footer Section ********** //
    @IBAction func btnLMenu_TouchUp(_ sender: UIButton) {
        if ApplicationData.AssignmentModeOn {
            showHideMenu(tag: ViewTag.BaseLeftMenu.rawValue)
        }
        else {
            btnLMenu.loadingIndicator(true)
            
            AssignmentManager.populateStudentAssignment(completionHandler: {
                DispatchQueue.main.async {
                    self.btnLMenu.loadingIndicator(false)
                    self.performSegue(withIdentifier: "SegueAssignment", sender: nil)
                }
            })
        }
        
        setFooterMode(currentFooterSectionMode: .Player, enableQuranPageUserInteraction: true)
    }
    @IBAction func btnRMenu_TouchUp(_ sender: UIButton) {
        showHideMenu(tag: ViewTag.BaseRightMenu.rawValue)
    }
    
    // ********** Footer Player Section ********** //
    @IBAction func btnRefresh_TouchUp(_ sender: UIButton) {
        self.hideMenu()
        RecitationManager.restartRecitation()
    }
    @IBAction func btnPrevious_TouchUp(_ sender: UIButton) {
        self.hideMenu()
        RecitationManager.previousRecitation()
    }
    @IBAction func btnStop_TouchUp(_ sender: UIButton) {
        self.hideMenu()
        RecitationManager.stopRecitation()
    }
    @IBAction func btnPlay_TouchDown(_ sender: Any) {
        self.hideMenu()
        
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
        self.hideMenu()
        RecitationManager.pauseRecitation()
    }
    @IBAction func btnNext_TouchUp(_ sender: UIButton) {
        self.hideMenu()
        RecitationManager.nextRecitation(onAudioPlayFinish: false)
    }
    
    // ********** Footer Record & Compare Section ********** //
    @IBAction func btnRRefresh_TouchUp(_ sender: Any) {
        vRecordCompare.onlyRecordModeOn = true
        vRecordCompare.currentRecitationIndex = 0
        
        vRecordCompare.startRecording()
    }
    @IBAction func btnRRecord_TouchUp(_ sender: Any) {
        setFooterMode(currentFooterSectionMode: .Recording, enableQuranPageUserInteraction: false)
        showHideMenu(tag: ViewTag.RecordCompare.rawValue)
        setRecordCompareMode(currentRecordCompareMode: .RRecord)
        vRecordCompare.loadView()
    }
    @IBAction func btnRStop_TouchUp(_ sender: Any) {
        vRecordCompare.onlyRecordModeOn = true
        
        vRecordCompare.finishRecording()
    }
    @IBAction func btnGPlay_TouchUp(_ sender: Any) {
        vRecordCompare.onlyRecordModeOn = false
        vRecordCompare.currentRecitationIndex = 0
        
        vRecordCompare.playPauseRecording()
        vRecordCompare.loadAyat()
    }
    @IBAction func btnGRefresh_TouchUp(_ sender: Any) {
        vRecordCompare.onlyRecordModeOn = false
        vRecordCompare.currentRecitationIndex = 0
        
        vRecordCompare.playPauseRecording()
        vRecordCompare.loadAyat()
    }
    
    // ********** Footer Assignment Section ********** //
    @IBAction func btnAssignmentList_TouchUp(_ sender: Any) {
        self.hideMenu()
        
        AssignmentManager.populateStudentAssignment(completionHandler: {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "SegueAssignment", sender: nil)
            }
        })
    }
    @IBAction func btnRecordUpload_TouchUp(_ sender: Any) {
        self.hideMenu()
        
        setFooterMode(currentFooterSectionMode: .AssignmentRecording, enableQuranPageUserInteraction: false)
    }
    @IBAction func btnCorrection_TouchUp(_ sender: Any) {
        self.hideMenu()
        
        CorrectionManager.unloadCorrectionMode()
        self.performSegue(withIdentifier: "SegueCorrection", sender: nil)
    }
    @IBAction func btnMeeting_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func btnSchedule_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func btnExit_TouchUp(_ sender: Any) {
        AssignmentManager.unloadAssignmentMode(completionHandler: {})
    }
    
    // ********** Footer Assignment Record & Upload Section ********** //
    @IBAction func btnARecord_TouchUp(_ sender: Any) {
        showMenu(tag: ViewTag.RecordAssignment.rawValue)
        
        if vRecordAssignment.recordingPlayMode != .Recording {
            vRecordAssignment.loadView(completionHandler: {
                self.vRecordAssignment.recordStopRecording()
            })
        }
        else {
            self.vRecordAssignment.recordStopRecording()
        }
    }
    @IBAction func btnAPlay_TouchUp(_ sender: Any) {
        showMenu(tag: ViewTag.RecordAssignment.rawValue)
        
        if !vRecordAssignment.recordingLoaded {
            vRecordAssignment.loadView(completionHandler: {
                self.vRecordAssignment.playPauseRecording()
            })
        }
        else {
            self.vRecordAssignment.playPauseRecording()
        }
    }
    @IBAction func btnAUpload_TouchUp(_ sender: Any) {
        showMenu(tag: ViewTag.UploadAssignment.rawValue)
        setRecordUploadMode(currentRecordUploadMode: .Upload)
        
        vUploadAssignment.uploadRecording(completionHandler: {
            DispatchQueue.main.async {
                self.hideMenu()
                self.setViewForFooterMode(isUserInteractionEnabled: true)
                self.setRecordUploadFooter()
            }
        })
    }
    
    // ********** Base Right Menu Section ********** //
    @IBAction func btnListenRepeat_TouchUp(_ sender: Any) {
        self.hideMenu()
        self.performSegue(withIdentifier: "SegueListenRepeat", sender: nil)
    }
    @IBAction func btnHideShow_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func btnRecordCompare_TouchUp(_ sender: Any) {
        self.hideMenu()
        
        if RecitationManager.validatePlayer() {
            let startAyat = RecitationManager.getRecitation(recitationIndex: 0)
            let endAyat = RecitationManager.getRecitation(recitationIndex: (RecitationManager.getRecitationCount() - 1))
            let missingMode = DocumentManager.checkFilesExistForSurahAyatOrderRange(startSurahId: ApplicationData.CurrentSurah.Id, endSurahId: ApplicationData.CurrentSurah.Id, startAyatOrderId: startAyat.AyatOrderId, endAyatOrderId: endAyat.AyatOrderId)
            
            switch missingMode {
            case .None:
                setFooterMode(currentFooterSectionMode: .Recording, enableQuranPageUserInteraction: true)
                
                break
            case .All:
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.AYAT_MISSING_DOWNLOAD_SCRIPT_RECITATION, okHandler: {})
                
                break
            case .Audio:
                RecitationManager.downloadRecitationForCurrentPage()
                
                break
            case .Script:
                PageManager.showQuranPage(scriptId: ApplicationData.CurrentScript.Id, pageId: startAyat.PageId)
                
                break
            }
        }
    }
    @IBAction func btnSearch_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func btnBookmark_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
    @IBAction func btnLibrary_TouchUp(_ sender: Any) {
        self.hideMenu()
    }
}
