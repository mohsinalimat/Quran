import UIKit
import DLRadioButton

class DPDownloadViewController: BaseViewController, ModalDialogueProtocol {
    // ********** Header Section ********** //
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnTopClose: QUButton!
    
    // ********** Main Section ********** //
    @IBOutlet weak var vMain: UIView!
    
    // ********** Main - Script Section ********** //
    @IBOutlet weak var vScript: UIView!
    @IBOutlet weak var btnScript: UIButton!
    
    // ********** Main - Reciter Section ********** //
    @IBOutlet weak var vReciter: UIView!
    @IBOutlet weak var btnReciter: UIButton!
    
    // ********** Main - Page Section ********** //
    @IBOutlet weak var vPage: UIView!
    @IBOutlet weak var rbtnPage: DLRadioButton!
    @IBOutlet weak var btnFrom: UIButton!
    @IBOutlet weak var btnTo: UIButton!
    
    // ********** Main - Surah Section ********** //
    @IBOutlet weak var vSurah: UIView!
    @IBOutlet weak var rbtnSurah: DLRadioButton!
    @IBOutlet weak var btnSurah: UIButton!
    
    // ********** Main - Juzz Section ********** //
    @IBOutlet weak var vJuzz: UIView!
    @IBOutlet weak var rbtnJuzz: DLRadioButton!
    @IBOutlet weak var btnJuzz: UIButton!
    
    // ********** Download Section ********** //
    @IBOutlet weak var pvFileProgressView: UIProgressView!
    @IBOutlet weak var pvOverallProgressView: UIProgressView!
    @IBOutlet weak var lblDownloadEachFile: UILabel!
    @IBOutlet weak var lblDownloadTotalFiles: UILabel!
    @IBOutlet weak var lblNoOfFile: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnCancelDownload: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var currentDownloadCategoryMode = DownloadCategoryMode.Surah
    var currentPageMode = PageMode.From
    var currentScript = Script()
    var currentReciter = Reciter()
    var currentSurah = Surah()
    var currentJuzz = Juzz()
    var currentFromPage = Page()
    var currentToPage = Page()
    var currentFromPageGroup = Page()
    var currentToPageGroup = Page()
    var selectedRecitationList = [Recitation]()
    var selectedPageList = [Page]()
    var lastPageId: Int64 = 0
    var firstPageId: Int64 = 0
    var lastAyatId: Int64 = 0
    var firstAyatId: Int64 = 0
    var totalDownload: Int = 0
    var currentDownload: Int = 1
    var successDownload: Int = 0
    var errorDownload: Int = 0
    var overallFileProgressFactor: Double = 0
    var terminateDownload = false
    var downloadCategorySelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        currentDownloadCategoryMode = ApplicationData.CurrentDownloadCategoryMode
        currentScript = ApplicationData.CurrentScript
        currentReciter = ApplicationData.CurrentReciter
        currentSurah = ApplicationData.CurrentSurah
        currentJuzz = ApplicationData.CurrentJuzz
        currentFromPage = ApplicationData.CurrentPage
        currentToPage = ApplicationData.CurrentPage
        currentFromPageGroup = ApplicationData.CurrentPageGroup
        currentToPageGroup = ApplicationData.CurrentPageGroup
        
        setViewForCurrentDownloadMode()
        setCurrentDownloadCategoryMode()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueDropDown" {
            let viewController = segue.destination as! UCDropDownViewController
            
            if downloadCategorySelected {
                switch currentDownloadCategoryMode {
                case .Surah:
                    viewController.selectedValue = currentSurah.Id
                    viewController.dataList = SurahRepository().getSurahList()
                    
                    break
                case .Juzz:
                    viewController.selectedValue = currentJuzz.Id
                    viewController.dataList = JuzzRepository().getJuzzList()
                    
                    break
                default:
                    break
                }
            }
            else {
                switch ApplicationData.CurrentDownloadMode {
                case .Audio:
                    viewController.selectedValue = currentReciter.Id
                    viewController.dataList = ReciterRepository().getReciterList()
                    
                    break
                case .Script:
                    viewController.selectedValue = currentScript.Id
                    viewController.dataList = ScriptRepository().getScriptList()
                    
                    break
                }
            }
        }
        else if segue.identifier == "SegueDualDropDown" {
            let viewController = segue.destination as! UCDualDropDownViewController
            
            switch currentDownloadCategoryMode {
            case .Page:
                switch currentPageMode {
                case .From:
                    viewController.primaryValue = currentFromPage.Id
                    viewController.secondaryValue = currentFromPageGroup.Id
                    
                    break
                case .To:
                    viewController.primaryValue = currentToPage.Id
                    viewController.secondaryValue = currentToPageGroup.Id
                    
                    break
                }
                
                viewController.primaryDataList = PageRepository().getPageList()
                viewController.secondaryDataList = PageRepository().getPageGroupList()
                
                break
            default:
                break
            }
        }
    }
    
    func onDoneHandler(Id: Int64) {
        if Id > 0 {
            if downloadCategorySelected {
                switch currentDownloadCategoryMode {
                case .Surah:
                    currentSurah = SurahRepository().getSurah(Id: Id)
                    
                    break
                case .Juzz:
                    currentJuzz = JuzzRepository().getJuzz(Id: Id)
                    
                    break
                default:
                    break
                }
                
                setViewForCurrentDownloadCategoryMode()
            }
            else {
                switch ApplicationData.CurrentDownloadMode {
                case .Audio:
                    currentReciter = ReciterRepository().getReciter(Id: Id)
                    
                    break
                case .Script:
                    currentScript = ScriptRepository().getScript(Id: Id)
                    
                    break
                }
                
                setViewForCurrentDownloadMode()
            }
        }
    }
    func onDoneHandler(PriId: Int64, SecId: Int64) {
        if PriId > 0 && SecId > 0 {
            switch currentDownloadCategoryMode {
            case .Page:
                switch currentPageMode {
                case .From:
                    currentFromPage = PageRepository().getPage(Id: PriId)
                    currentFromPageGroup = PageRepository().getPageGroup(pageId: PriId)
                    
                    if currentFromPage.Id > currentToPage.Id {
                        DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_FROM_PAGE, okHandler: {})
                    }
                    
                    break
                case .To:
                    currentToPage = PageRepository().getPage(Id: PriId)
                    currentToPageGroup = PageRepository().getPageGroup(pageId: PriId)
                    
                    if currentFromPage.Id > currentToPage.Id {
                        DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_TO_PAGE, okHandler: {})
                    }
                    
                    break
                }
                
                break
            default:
                break
            }
        }
        
        setViewForCurrentDownloadCategoryMode()
    }
    
    func setLayout() {
        switch ApplicationData.CurrentDownloadMode {
        case .Audio:
            lblHeading.text = ApplicationHeading.RECITATION_DOWNLOAD
            lblDownloadEachFile.text = ApplicationHeading.DOWNLOAD_EACH_RECITATION
            lblDownloadTotalFiles.text = ApplicationHeading.DOWNLOAD_TOTAL_RECITATION
            
            break
        case .Script:
            lblHeading.text = ApplicationHeading.SCRIPT_DOWNLOAD
            lblDownloadEachFile.text = ApplicationHeading.DOWNLOAD_EACH_SCRIPT
            lblDownloadTotalFiles.text = ApplicationHeading.DOWNLOAD_TOTAL_SCRIPT
            
            break
        }
        
        btnCancelDownload.setButtonDisabled()
    }
    func setCurrentDownloadCategoryMode() {
        switch currentDownloadCategoryMode {
        case .Surah:
            rbtnSurah.isSelected = true
            
            break
        case .Page:
            rbtnPage.isSelected = true
            
            break
        case .Juzz:
            rbtnJuzz.isSelected = true
            
            break
        default:
            break
        }
        
        setViewForCurrentDownloadCategoryMode()
    }
    func setViewForCurrentDownloadMode() {
        vReciter.isHidden = true
        vScript.isHidden = true
        
        switch ApplicationData.CurrentDownloadMode {
        case .Audio:
            vReciter.isHidden = false
            
            btnReciter.setTitle(currentReciter.Name, for: .normal)
            
            break
        case .Script:
            vScript.isHidden = false
            
            btnScript.setTitle(currentScript.Name, for: .normal)
            
            break
        }
    }
    func setViewForCurrentDownloadCategoryMode() {
        vPage.isHidden = true
        vSurah.isHidden = true
        vJuzz.isHidden = true
        
        switch currentDownloadCategoryMode {
        case .Surah:
            vSurah.isHidden = false
            
            btnSurah.setTitle(currentSurah.Name, for: .normal)
            
            break
        case .Page:
            vPage.isHidden = false
            
            btnFrom.setTitle(currentFromPage.Name, for: .normal)
            btnTo.setTitle(currentToPage.Name, for: .normal)
            
            break
        case .Juzz:
            vJuzz.isHidden = false
            
            btnJuzz.setTitle(currentJuzz.Name, for: .normal)
            
            break
        default:
            break
        }
    }
    func validateView() -> Bool {
        var status = true
        
        switch currentDownloadCategoryMode {
        case .Page:
            if currentFromPage.Id > currentToPage.Id {
                status = false
                
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.INVALID_PAGE_RANGE, okHandler: {})
            }
            
            break
        default:
            break
        }
        
        return status
    }
    func setDownloadConstraint(enableConstraint: Bool) {
        pvFileProgressView.progress = 0
        pvOverallProgressView.progress = 0
        lastPageId = 0
        firstPageId = 0
        lastAyatId = 0
        firstAyatId = 0
        totalDownload = 0
        currentDownload = 1
        successDownload = 0
        errorDownload = 0
        
        if enableConstraint {
            terminateDownload = false
            
            btnTopClose.setButtonDisabled()
            vMain.setViewDisabled()
            btnCancelDownload.setButtonEnabled()
            btnDownload.setButtonDisabled()
            btnClose.setButtonDisabled()
        }
        else {
            terminateDownload = true
            
            btnTopClose.setButtonEnabled()
            vMain.setViewEnabled()
            btnCancelDownload.setButtonDisabled()
            btnDownload.setButtonEnabled()
            btnClose.setButtonEnabled()
        }
    }
    func downloadScript() {
        setDownloadConstraint(enableConstraint: true)
        selectedPageList.removeAll()
        
        switch currentDownloadCategoryMode {
        case .Surah:
            selectedPageList = PageRepository().getPageList(surahId: currentSurah.Id)
            
            break
        case .Page:
            selectedPageList = PageRepository().getPageList(fromPageId: currentFromPage.Id, toPageId: currentToPage.Id)
            
            break
        case .Juzz:
            selectedPageList = PageRepository().getPageList(juzzId: currentJuzz.Id)
            
            break
        case .Quran:
            selectedPageList = PageRepository().getPageList()
            
            break
        }
        
        totalDownload = selectedPageList.count
        overallFileProgressFactor = (1 / Double(totalDownload))
        
        continueDownloadScript()
    }
    func continueDownloadScript() {
        if terminateDownload {
            setDownloadConstraint(enableConstraint: false)
        }
        else {
            if let pageId = selectedPageList.first?.Id {
                lblNoOfFile.text = String(currentDownload) + "/" + String(totalDownload)
                    
                DownloadManager.downloadCurrentQuranPage(uiOProgressView: pvOverallProgressView, uiFProgressView: pvFileProgressView, scriptId: currentScript.Id, pageId: pageId, overallProgressFactor: overallFileProgressFactor, completionHandler: { downloadStatus in
                    if downloadStatus {
                        self.successDownload = self.successDownload + 1
                        self.lastPageId = pageId
                        
                        if self.firstPageId <= 0 {
                            self.firstPageId = pageId
                            //ApplicationData.CurrentScript = self.currentScript
                        }
                    }
                    else {
                        self.errorDownload = self.errorDownload + 1
                    }
                    
                    self.pvOverallProgressView.progress = Float(self.overallFileProgressFactor) * Float(self.currentDownload)
                    self.currentDownload = self.currentDownload + 1
                    
                    self.selectedPageList.remove(at: 0)
                    self.continueDownloadScript()
                })
            }
            else {
                if ApplicationData.AssignmentModeOn {
                    if self.successDownload > 0 {
                        DialogueManager.showSuccess(viewController: self, message: ApplicationSuccessMessage.SCRIPT_DOWNLOAD, okHandler: {
                            AssignmentManager.loadAssignmentMode(Id: ApplicationData.CurrentAssignment.Id, completionHandler: {
                                self.dismiss(animated: true, completion: nil)
                            })
                        })
                    }
                    else {
                        DialogueManager.showError(viewController: self, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
                else {
                    if self.firstPageId > 0 {
                        PageManager.showQuranPage(scriptId: currentScript.Id, pageId: self.firstPageId)
                    }
                    
                    if self.totalDownload > 0 {
                        if self.errorDownload > 0 {
                            if self.successDownload > 0 {
                                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.SOME_SCRIPT_NOT_DOWNLOAD, okHandler: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                            else {
                                DialogueManager.showError(viewController: self, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                        }
                        else if self.successDownload > 0 {
                            DialogueManager.showSuccess(viewController: self, message: ApplicationSuccessMessage.SCRIPT_DOWNLOAD, okHandler: {
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                }
            }
        }
    }
    func cancelDownloadScript() {
        DialogueManager.showConfirmation(viewController: self, message: ApplicationConfirmMessage.CANCEL_SCRIPT_DOWNLOAD, yesHandler: {
            self.setDownloadConstraint(enableConstraint: false)
            DownloadManager.cancelDownload()
        })
    }
    func downloadRecitation() {
        setDownloadConstraint(enableConstraint: true)
        selectedRecitationList.removeAll()
        
        switch currentDownloadCategoryMode {
        case .Surah:
            selectedRecitationList = RecitationRepository().getRecitationList(surahId: currentSurah.Id)
            
            break
        case .Page:
            selectedRecitationList = RecitationRepository().getRecitationList(fromPageId: currentFromPage.Id, toPageId: currentToPage.Id)
            
            break
        case .Juzz:
            selectedRecitationList = RecitationRepository().getRecitationList(juzzId: currentJuzz.Id)
            
            break
        case .Quran:
            selectedRecitationList = RecitationRepository().getRecitationList()
            
            break
        }
        
        totalDownload = selectedRecitationList.count
        overallFileProgressFactor = (1 / Double(totalDownload))
        
        continueDownloadRecitation()
    }
    func continueDownloadRecitation() {
        if terminateDownload {
            setDownloadConstraint(enableConstraint: false)
        }
        else {
            if let ayatId = selectedRecitationList.first?.AyatId {
                lblNoOfFile.text = String(currentDownload) + "/" + String(totalDownload)
                
                DownloadManager.downloadCurrentAyatRecitation(uiOProgressView: pvOverallProgressView, uiFProgressView: pvFileProgressView, reciterId: currentReciter.Id, surahId: (selectedRecitationList.first?.SurahId)!, recitationName: (selectedRecitationList.first?.RecitationFileName)!, overallProgressFactor: overallFileProgressFactor, completionHandler: { downloadStatus in
                    if downloadStatus {
                        self.successDownload = self.successDownload + 1
                        self.lastAyatId = ayatId
                        
                        if self.firstAyatId <= 0 {
                            self.firstAyatId = ayatId
                            self.firstPageId = (self.selectedRecitationList.first?.PageId)!
                            //ApplicationData.CurrentReciter = self.currentReciter
                        }
                    }
                    else {
                        self.errorDownload = self.errorDownload + 1
                    }
                    
                    self.pvOverallProgressView.progress = Float(self.overallFileProgressFactor) * Float(self.currentDownload)
                    self.currentDownload = self.currentDownload + 1
                    
                    self.selectedRecitationList.remove(at: 0)
                    self.continueDownloadRecitation()
                })
            }
            else {
                if self.firstPageId > 0 {
                    PageManager.showQuranPage(scriptId: currentScript.Id, pageId: self.firstPageId)
                }
                
                if self.totalDownload > 0 {
                    if self.errorDownload > 0 {
                        if self.successDownload > 0 {
                            DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.SOME_RECITATION_NOT_DOWNLOAD, okHandler: {
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                        else {
                            DialogueManager.showError(viewController: self, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    }
                    else if self.successDownload > 0 {
                        DialogueManager.showSuccess(viewController: self, message: ApplicationSuccessMessage.RECITATION_DOWNLOAD, okHandler: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }
        }
    }
    func cancelDownloadRecitation() {
        DialogueManager.showConfirmation(viewController: self, message: ApplicationConfirmMessage.CANCEL_RECITATION_DOWNLOAD, yesHandler: {
            self.setDownloadConstraint(enableConstraint: false)
            DownloadManager.cancelDownload()
        })
    }
    func closePopUp() {
        self.dismiss(animated: true, completion: {
            if ApplicationData.AssignmentModeOn {
                AssignmentManager.unloadAssignment {
                    AssignmentManager.populateStudentAssignment(completionHandler: {
                        ApplicationObject.MainViewController.performSegue(withIdentifier: "SegueAssignment", sender: nil)
                    })
                }
            }
        })
    }
    
    // ********** Main Section ********** //
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        closePopUp()
    }
    @IBAction func btnScript_TouchUp(_ sender: Any) {
        downloadCategorySelected = false
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnReciter_TouchUp(_ sender: Any) {
        downloadCategorySelected = false
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func rtbnPage_TouchUp(_ sender: Any) {
        currentDownloadCategoryMode = .Page
        
        setViewForCurrentDownloadCategoryMode()
    }
    @IBAction func rbtnSurah_TouchUp(_ sender: Any) {
        currentDownloadCategoryMode = .Surah
        
        setViewForCurrentDownloadCategoryMode()
    }
    @IBAction func rbtnJuzz_TouchUp(_ sender: Any) {
        currentDownloadCategoryMode = .Juzz
        
        setViewForCurrentDownloadCategoryMode()
    }
    @IBAction func rbtnQuran_TouchUp(_ sender: Any) {
        currentDownloadCategoryMode = .Quran
        
        setViewForCurrentDownloadCategoryMode()
    }
    @IBAction func btnFromPage_TouchUp(_ sender: Any) {
        downloadCategorySelected = true
        currentDownloadCategoryMode = .Page
        currentPageMode = .From
        
        self.performSegue(withIdentifier: "SegueDualDropDown", sender: nil)
    }
    @IBAction func btnToPage_TouchUp(_ sender: Any) {
        downloadCategorySelected = true
        currentDownloadCategoryMode = .Page
        currentPageMode = .To
        
        self.performSegue(withIdentifier: "SegueDualDropDown", sender: nil)
    }
    @IBAction func btnSurah_TouchUp(_ sender: Any) {
        downloadCategorySelected = true
        currentDownloadCategoryMode = .Surah
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnJuzz_TouchUp(_ sender: Any) {
        downloadCategorySelected = true
        currentDownloadCategoryMode = .Juzz
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    
    // ********** Download Section ********** //
    @IBAction func btnDownload_TouchUp(_ sender: Any) {
        if validateView() {
            switch ApplicationData.CurrentDownloadMode {
            case .Audio:
                DocumentManager.createDirectory(folderPath: ApplicationMethods.getReciterPath(reciterId: currentReciter.Id))
                downloadRecitation()
                
                break
            case .Script:
                DocumentManager.createDirectory(folderPath: ApplicationMethods.getScriptPath(scriptId: currentScript.Id))
                downloadScript()
                
                break
            }
        }
    }
    @IBAction func btnCancelDownload_TouchUp(_ sender: Any) {
        switch ApplicationData.CurrentDownloadMode {
        case .Audio:
            cancelDownloadRecitation()
            
            break
        case .Script:
            cancelDownloadScript()
            
            break
        }
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        closePopUp()
    }
}
