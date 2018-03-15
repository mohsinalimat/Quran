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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSurah = ApplicationData.CurrentSurah
        endSurah = ApplicationData.CurrentSurah
        startAyat = RecitationRepository().getFirstRecitation(surahId: startSurah.Id)
        endAyat = startAyat
        
        setViewForContinuousRecitationMode()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDropDown" {
            let viewController = segue.destination as! UCDropDownViewController
            
            switch currentContinuousRecitationMode {
            case .StartSurah:
                viewController.selectedValue = startSurah.Id
                viewController.dataList = SurahRepository().getSurahList()
                
                break
            case .StartAyat:
                viewController.selectedValue = startAyat.Id
                viewController.dataList = RecitationRepository().getRecitationList(surahId: startSurah.Id)
                
                break
            case .EndSurah:
                viewController.selectedValue = endSurah.Id
                viewController.dataList = SurahRepository().getSurahList()
                
                break
            case .EndAyat:
                viewController.selectedValue = endAyat.Id
                viewController.dataList = RecitationRepository().getRecitationList(surahId: endSurah.Id)
                
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
            if DocumentManager.checkFilesExistForSurahAyatOrderRange(startSurahId: startSurah.Id, endSurahId: endSurah.Id, startAyatOrderId: startAyat.AyatOrderId, endAyatOrderId: endAyat.AyatOrderId) {
                self.delegate?.onDoneHandler?(StartSurahId: startSurah.Id, EndSurahId: endSurah.Id, StartAyatOrderId: startAyat.AyatOrderId, EndAyatOrderId: endAyat.AyatOrderId)
                
                self.dismiss(animated: true, completion: nil)
            }
            else {
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.AYAT_MISSING_DOWNLOAD_SCRIPT_RECITATION, okHandler: {})
            }
        }
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
