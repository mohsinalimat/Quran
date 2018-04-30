import UIKit
import AVFoundation

class BMMContinuousRecitationViewController: BaseViewController, ModalDialogueProtocol {
    @IBOutlet weak var btnStartSurah: UIButton!
    @IBOutlet weak var btnStartAyah: UIButton!
    @IBOutlet weak var btnEndSurah: UIButton!
    @IBOutlet weak var btnEndAyah: UIButton!
    
    var currentContinuousRecitationMode = ContinuousRecitationMode.StartSurah
    var startSurah = Surah()
    var endSurah = Surah()
    var startAyat = Recitation()
    var endAyat = Recitation()
    var startAyatObject = Ayat()
    var endAyatObject = Ayat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ApplicationData.AssignmentModeOn {
            let startAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId
            let endAyatId = ApplicationData.CurrentAssignment.AssignmentBoundary[0].EndPoint[0].AyatId
            
            startAyatObject = AyatRepository().getAyat(Id: startAyatId)
            endAyatObject = AyatRepository().getAyat(Id: endAyatId)
            startSurah = SurahRepository().getSurah(Id: startAyatObject.SurahId)
            endSurah = SurahRepository().getSurah(Id: endAyatObject.SurahId)
            startAyat = RecitationRepository().getRecitation(surahId: startAyatObject.SurahId, ayatOrder: startAyatObject.AyatOrder)
            endAyat = RecitationRepository().getRecitation(surahId: endAyatObject.SurahId, ayatOrder: endAyatObject.AyatOrder)
        }
        else {
            startSurah = ApplicationData.CurrentSurah
            endSurah = ApplicationData.CurrentSurah
            startAyat = RecitationRepository().getFirstRecitation(surahId: startSurah.Id)
            endAyat = startAyat
        }
        
        setViewForContinuousRecitationMode()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDropDown" {
            let viewController = segue.destination as! UCDropDownViewController
            
            switch currentContinuousRecitationMode {
            case .StartSurah:
                viewController.selectedValue = startSurah.Id
                
                if ApplicationData.AssignmentModeOn {
                    viewController.dataList = SurahRepository().getSurahList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId)
                }
                else {
                    viewController.dataList = SurahRepository().getSurahList()
                }
                
                break
            case .StartAyat:
                viewController.selectedValue = startAyat.Id
                
                if ApplicationData.AssignmentModeOn {
                    viewController.dataList = RecitationRepository().getRecitationList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId, fromAyatOrderId: startAyatObject.AyatOrder, toAyatOrderId: endAyatObject.AyatOrder)
                }
                else {
                    viewController.dataList = RecitationRepository().getRecitationList(surahId: startSurah.Id)
                }
                
                break
            case .EndSurah:
                viewController.selectedValue = endSurah.Id
                
                if ApplicationData.AssignmentModeOn {
                    viewController.dataList = SurahRepository().getSurahList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId)
                }
                else {
                    viewController.dataList = SurahRepository().getSurahList()
                }
                
                break
            case .EndAyat:
                viewController.selectedValue = endAyat.Id
                
                if ApplicationData.AssignmentModeOn {
                    viewController.dataList = RecitationRepository().getRecitationList(fromSurahId: startAyatObject.SurahId, toSurahId: endAyatObject.SurahId, fromAyatOrderId: startAyatObject.AyatOrder, toAyatOrderId: endAyatObject.AyatOrder)
                }
                else {
                    viewController.dataList = RecitationRepository().getRecitationList(surahId: endSurah.Id)
                }
                
                break
            default:
                break
            }
        }
    }
    
    func onDoneHandler(Id: Int64) {
        if Id > 0 {
            switch currentContinuousRecitationMode {
            case .StartSurah:
                if Id > endSurah.Id {
                    DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_START_SURAH, okHandler: {})
                }
                else {
                    if startSurah.Id != Id {
                        startAyat = RecitationRepository().getFirstRecitation(surahId: Id)
                    }
                    
                    startSurah = SurahRepository().getSurah(Id: Id)
                }
                
                break
            case .StartAyat:
                if startSurah.Id == endSurah.Id && Id > endAyat.Id {
                    DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_START_AYAT, okHandler: {})
                }
                else {
                    startAyat = RecitationRepository().getRecitation(surahId: startSurah.Id, ayatOrder: Id)
                }
                
                break
            case .EndSurah:
                if startSurah.Id > Id {
                    DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_END_SURAH, okHandler: {})
                }
                else {
                    if endSurah.Id != Id {
                        endAyat = RecitationRepository().getFirstRecitation(surahId: Id)
                    }
                    
                    endSurah = SurahRepository().getSurah(Id: Id)
                }
                
                break
            case .EndAyat:
                if startSurah.Id == endSurah.Id && startAyat.Id > Id {
                    DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_END_AYAT, okHandler: {})
                }
                else {
                    endAyat = RecitationRepository().getRecitation(surahId: endSurah.Id, ayatOrder: Id)
                }
                
                break
            default:
                break
            }
            
            setViewForContinuousRecitationMode()
        }
    }
    
    func setViewForContinuousRecitationMode() {
        btnStartSurah.setTitle(startSurah.Name, for: .normal)
        btnStartAyah.setTitle(String(startAyat.AyatOrderId), for: .normal)
        btnEndSurah.setTitle(endSurah.Name, for: .normal)
        btnEndAyah.setTitle(String(endAyat.AyatOrderId), for: .normal)
    }
    func validateView() -> Bool {
        var status = true
        
        if startSurah.Id > endSurah.Id {
            status = false
            
            DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_START_SURAH, okHandler: {})
        }
        else if startSurah.Id == endSurah.Id && startAyat.Id > endAyat.Id {
            status = false
            
            DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_START_AYAT, okHandler: {})
        }
        
        return status
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnStartSurah_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .StartSurah
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnStartAyah_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .StartAyat
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnEndSurah_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .EndSurah
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnEndAyah_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .EndAyat
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnPlay_TouchUp(_ sender: Any) {
        if validateView() {
            let missingMode = DocumentManager.checkFilesExistForSurahAyatOrderRange(startSurahId: startSurah.Id, endSurahId: endSurah.Id, startAyatOrderId: startAyat.AyatOrderId, endAyatOrderId: endAyat.AyatOrderId)
            
            switch missingMode {
            case .None:
                self.delegate?.onDoneHandler?(StartSurahId: startSurah.Id, EndSurahId: endSurah.Id, StartAyatOrderId: startAyat.AyatOrderId, EndAyatOrderId: endAyat.AyatOrderId, AyatRecitationSilence: 0.0, AyatRepeatFor: 0, RangeRecitationSilence: 0.0, RangeRepeatFor: 0)
                self.dismiss(animated: true, completion: nil)
                
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
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
