import UIKit
import BEMCheckBox

class BRMListenRepeatViewController: BaseViewController, ModalDialogueProtocol {
    @IBOutlet weak var btnStartSurah: UIButton!
    @IBOutlet weak var btnStartAyah: UIButton!
    @IBOutlet weak var btnEndSurah: UIButton!
    @IBOutlet weak var btnEndAyah: UIButton!
    @IBOutlet weak var chkAyat: BEMCheckBox!
    @IBOutlet weak var chkRange: BEMCheckBox!
    @IBOutlet weak var chkSavePreference: BEMCheckBox!
    @IBOutlet weak var btnAyatRecitationSilence: UIButton!
    @IBOutlet weak var btnRangeRecitationSilence: UIButton!
    @IBOutlet weak var btnAyatNumber: UIButton!
    @IBOutlet weak var btnRangeNumber: UIButton!
    
    var currentContinuousRecitationMode = ContinuousRecitationMode.StartSurah
    var startSurah = Surah()
    var endSurah = Surah()
    var startAyat = Recitation()
    var endAyat = Recitation()
    var ayatRecitationSilence = RecitationSilence()
    var rangeRecitationSilence = RecitationSilence()
    var ayatNumber = Number()
    var rangeNumber = Number()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSurah = ApplicationData.CurrentSurah
        endSurah = ApplicationData.CurrentSurah
        startAyat = RecitationRepository().getFirstRecitation(surahId: startSurah.Id)
        endAyat = startAyat
        ayatRecitationSilence = RecitationSilenceRepository().getFirstRecitationSilence()
        rangeRecitationSilence = ayatRecitationSilence
        ayatNumber = NumberRepository().getFirstNumber()
        rangeNumber = ayatNumber
        
        let recitationPreferenceList = RecitationPreferenceRepository().getRecitationPreferenceList()
        
        if recitationPreferenceList.count > 0 {
            chkSavePreference.on = true
            
            for recitationPreferenceObject in recitationPreferenceList {
                if recitationPreferenceObject.RepeatFor == RecitationRepeatFor.Ayat.rawValue {
                    ayatRecitationSilence = RecitationSilenceRepository().getRecitationSilence(silenceInSecond: recitationPreferenceObject.SilenceInSecond)
                    ayatNumber = NumberRepository().getNumber(Id: recitationPreferenceObject.Number)
                    chkAyat.on = true
                }
                else if recitationPreferenceObject.RepeatFor == RecitationRepeatFor.Range.rawValue {
                    rangeRecitationSilence = RecitationSilenceRepository().getRecitationSilence(silenceInSecond: recitationPreferenceObject.SilenceInSecond)
                    rangeNumber = NumberRepository().getNumber(Id: recitationPreferenceObject.Number)
                    chkRange.on = true
                }
            }
        }
        
        setViewForContinuousRecitationMode(setSelection: false)
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
            case .AyatRecitationSilence:
                viewController.selectedValue = ayatRecitationSilence.Id
                viewController.dataList = RecitationSilenceRepository().getRecitationSilenceList()
                
                break
            case .RangeRecitationSilence:
                viewController.selectedValue = rangeRecitationSilence.Id
                viewController.dataList = RecitationSilenceRepository().getRecitationSilenceList()
                
                break
            case .AyatNumber:
                viewController.selectedValue = ayatNumber.Id
                viewController.dataList = NumberRepository().getNumberList()
                
                break
            case .RangeNumber:
                viewController.selectedValue = rangeNumber.Id
                viewController.dataList = NumberRepository().getNumberList()
                
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
            case .AyatRecitationSilence:
                ayatRecitationSilence = RecitationSilenceRepository().getRecitationSilence(Id: Id)
                
                break
            case .RangeRecitationSilence:
                rangeRecitationSilence = RecitationSilenceRepository().getRecitationSilence(Id: Id)
                
                break
            case .AyatNumber:
                ayatNumber = NumberRepository().getNumber(Id: Id)
                
                break
            case .RangeNumber:
                rangeNumber = NumberRepository().getNumber(Id: Id)
                
                break
            }
            
            setViewForContinuousRecitationMode(setSelection: true)
        }
    }
    
    func setViewForContinuousRecitationMode(setSelection: Bool) {
        btnStartSurah.setTitle(startSurah.Name, for: .normal)
        btnStartAyah.setTitle(String(startAyat.AyatOrderId), for: .normal)
        btnEndSurah.setTitle(endSurah.Name, for: .normal)
        btnEndAyah.setTitle(String(endAyat.AyatOrderId), for: .normal)
        btnAyatRecitationSilence.setTitle(ayatRecitationSilence.Name, for: .normal)
        btnRangeRecitationSilence.setTitle(rangeRecitationSilence.Name, for: .normal)
        btnAyatNumber.setTitle(ayatNumber.Name, for: .normal)
        btnRangeNumber.setTitle(rangeNumber.Name, for: .normal)
        
        if setSelection {
            if ayatRecitationSilence.SilenceInSecond > 0 || ayatNumber.Id > 0 {
                chkAyat.on = true
            }
            else {
                chkAyat.on = false
            }
            
            if rangeRecitationSilence.SilenceInSecond > 0 || rangeNumber.Id > 0 {
                chkRange.on = true
            }
            else {
                chkRange.on = false
            }
        }
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
    @IBAction func btnAyatRecitationSilence_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .AyatRecitationSilence
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnRangeRecitationSilence_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .RangeRecitationSilence
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnAyatNumber_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .AyatNumber
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnRangeNumber_TouchUp(_ sender: Any) {
        currentContinuousRecitationMode = .RangeNumber
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func chkSavePreferences_TouchUp(_ sender: Any) {
        if chkSavePreference.on {
            var recitationPreferenceList = [RecitationPreference]()
            
            if chkAyat.on {
                let recitationPreferenceObject = RecitationPreference()
                
                recitationPreferenceObject.RepeatFor = Int64(RecitationRepeatFor.Ayat.rawValue)
                recitationPreferenceObject.SilenceInSecond = ayatRecitationSilence.SilenceInSecond
                recitationPreferenceObject.Number = ayatNumber.Id
                
                recitationPreferenceList.append(recitationPreferenceObject)
            }
            
            if chkRange.on {
                let recitationPreferenceObject = RecitationPreference()
                
                recitationPreferenceObject.RepeatFor = Int64(RecitationRepeatFor.Range.rawValue)
                recitationPreferenceObject.SilenceInSecond = rangeRecitationSilence.SilenceInSecond
                recitationPreferenceObject.Number = rangeNumber.Id
                
                recitationPreferenceList.append(recitationPreferenceObject)
            }
            
            _ = RecitationPreferenceRepository().saveRecitationPreference(recitationPreferenceList: recitationPreferenceList)
        }
        else {
            _ = RecitationPreferenceRepository().deleteRecitationPreference()
        }
    }
    @IBAction func btnPlay_TouchUp(_ sender: Any) {
        if validateView() {
            if DocumentManager.checkFilesExistForSurahAyatOrderRange(startSurahId: startSurah.Id, endSurahId: endSurah.Id, startAyatOrderId: startAyat.AyatOrderId, endAyatOrderId: endAyat.AyatOrderId) {
                var aSilence: Double = 0.0
                var aNumber:Int64 = 0
                var rSilence: Double = 0.0
                var rNumber:Int64 = 0
                
                if chkAyat.on {
                    aSilence = ayatRecitationSilence.SilenceInSecond
                    aNumber = ayatNumber.Id
                }
                
                if chkRange.on {
                    rSilence = rangeRecitationSilence.SilenceInSecond
                    rNumber = rangeNumber.Id
                }
                
                self.delegate?.onDoneHandler?(StartSurahId: startSurah.Id, EndSurahId: endSurah.Id, StartAyatOrderId: startAyat.AyatOrderId, EndAyatOrderId: endAyat.AyatOrderId, AyatRecitationSilence: aSilence, AyatRepeatFor: aNumber, RangeRecitationSilence: rSilence, RangeRepeatFor: rNumber)
                
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
