import UIKit

class TMDownloadBookViewController: BaseViewController, ModalDialogueProtocol, UITableViewDelegate, UITableViewDataSource {
    // ********** Header Section ********** //
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var btnTopClose: QUButton!
    
    // ********** Main Section ********** //
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var btnLanguage: UIButton!
    
    // ********** Main - Tafseer Section ********** //
    @IBOutlet weak var vTafseer: UIView!
    @IBOutlet weak var btnTafseer: UIButton!
    
    // ********** Main - Translation Section ********** //
    @IBOutlet weak var vTranslation: UIView!
    @IBOutlet weak var btnTranslation: UIButton!
    
    // ********** Main - Word Meaning Section ********** //
    @IBOutlet weak var vWordMeaning: UIView!
    @IBOutlet weak var btnWordMeaning: UIButton!
    
    // ********** Main - Cause of Revelation Section ********** //
    @IBOutlet weak var vCauseOfRevelation: UIView!
    @IBOutlet weak var btnCauseOfRevelation: UIButton!
    
    // ********** Download Section ********** //
    @IBOutlet weak var pvOverallProgressView: UIProgressView!
    @IBOutlet weak var lblDownloadTotalFiles: UILabel!
    @IBOutlet weak var btnDownload: QUButton!
    @IBOutlet weak var btnCancelDownload: QUButton!
    @IBOutlet weak var btnClose: QUButton!
    
    // ********** List Section ********** //
    @IBOutlet weak var tvBook: UITableView!
    
    var wordMeaningBookList = [WordMeaningBook]()
    var tafseerBookList = [TafseerBook]()
    var translationBookList = [TranslationBook]()
    var causeOfRevelationBookList = [CauseOfRevelationBook]()
    var currentLanguage = Language()
    var currentWordMeaningBook = WordMeaningBook()
    var currentTafseerBook = TafseerBook()
    var currentTranslationBook = TranslationBook()
    var currentCauseOfRevelationBook = CauseOfRevelationBook()
    var downloadBookSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            currentWordMeaningBook = WordMeaningBookRepository().getFirstWordMeaningBook()
            currentLanguage = LanguageRepository().getFirstLanguage()
            
            break
        case .Tafseer:
            currentTafseerBook = TafseerBookRepository().getFirstTafseerBook()
            currentLanguage = LanguageRepository().getLanguage(Id: currentTafseerBook.LanguageId)
            
            break
        case .Translation:
            currentTranslationBook = TranslationBookRepository().getFirstTranslationBook()
            currentLanguage = LanguageRepository().getLanguage(Id: currentTranslationBook.LanguageId)
            
            break
        case .CauseOfRevelation:
            currentCauseOfRevelationBook = CauseOfRevelationBookRepository().getFirstCauseOfRevelationBook()
            currentLanguage = LanguageRepository().getLanguage(Id: currentCauseOfRevelationBook.LanguageId)
            
            break
        }
        
        setViewForCurrentDownloadBookMode()
        loadDataForBookTableView()
        
        tvBook.delegate = self
        tvBook.dataSource = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController = segue.destination as! UCDropDownViewController
        
        if downloadBookSelected {
            switch ApplicationData.CurrentDownloadBookMode {
            case .WordMeaning:
                viewController.selectedValue = currentWordMeaningBook.Id
                viewController.dataList = WordMeaningBookRepository().getWordMeaningBookList()
                
                break
            case .Tafseer:
                viewController.selectedValue = currentTafseerBook.Id
                viewController.dataList = TafseerBookRepository().getTafseerBookList(languageId: currentLanguage.Id)
                
                break
            case .Translation:
                viewController.selectedValue = currentTranslationBook.Id
                viewController.dataList = TranslationBookRepository().getTranslationBookList(languageId: currentLanguage.Id)
                
                break
            case .CauseOfRevelation:
                viewController.selectedValue = currentCauseOfRevelationBook.Id
                viewController.dataList = CauseOfRevelationBookRepository().getCauseOfRevelationBookList(languageId: currentLanguage.Id)
                
                break
            }
        }
        else {
            viewController.selectedValue = currentLanguage.Id
            viewController.dataList = LanguageRepository().getLanguageList()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countForBookTableView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcBook = tvBook.dequeueReusableCell(withIdentifier: "tvcBook") as! BookTableViewCell
        
        return bindBookTableViewCell(currentBookTableViewCell: tvcBook, index: indexPath.row)
    }
    
    func onDoneHandler(Id: Int64) {
        if Id > 0 {
            if downloadBookSelected {
                switch ApplicationData.CurrentDownloadBookMode {
                case .WordMeaning:
                    currentWordMeaningBook = WordMeaningBookRepository().getWordMeaningBook(Id: Id)
                    
                    break
                case .Tafseer:
                    currentTafseerBook = TafseerBookRepository().getTafseerBook(Id: Id)
                    
                    break
                case .Translation:
                    currentTranslationBook = TranslationBookRepository().getTranslationBook(Id: Id)
                    
                    break
                case .CauseOfRevelation:
                    currentCauseOfRevelationBook = CauseOfRevelationBookRepository().getCauseOfRevelationBook(Id: Id)
                    
                    break
                }
            }
            else {
                currentLanguage = LanguageRepository().getLanguage(Id: Id)
                
                switch ApplicationData.CurrentDownloadBookMode {
                case .WordMeaning:
                    currentWordMeaningBook = WordMeaningBookRepository().getFirstWordMeaningBook()
                    
                    break
                case .Tafseer:
                    currentTafseerBook = TafseerBookRepository().getFirstTafseerBook(languageId: Id)
                    
                    break
                case .Translation:
                    currentTranslationBook = TranslationBookRepository().getFirstTranslationBook(languageId: Id)
                    
                    break
                case .CauseOfRevelation:
                    currentCauseOfRevelationBook = CauseOfRevelationBookRepository().getFirstCauseOfRevelationBook(languageId: Id)
                    
                    break
                }
            }
            
            setViewForCurrentDownloadBookMode()
        }
    }
    
    func setLayout() {
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            lblHeading.text = ApplicationHeading.WORDMEANING_DOWNLOAD
            lblDownloadTotalFiles.text = ApplicationHeading.DOWNLOAD_TOTAL_WORDMEANING
                
            break
        case .Tafseer:
            lblHeading.text = ApplicationHeading.TAFSEER_DOWNLOAD
            lblDownloadTotalFiles.text = ApplicationHeading.DOWNLOAD_TOTAL_TAFSEER
            
            break
        case .Translation:
            lblHeading.text = ApplicationHeading.TRANSLATION_DOWNLOAD
            lblDownloadTotalFiles.text = ApplicationHeading.DOWNLOAD_TOTAL_TRANSLATION
            
            break
        case .CauseOfRevelation:
            lblHeading.text = ApplicationHeading.CAUSEOFREVELATION_DOWNLOAD
            lblDownloadTotalFiles.text = ApplicationHeading.DOWNLOAD_TOTAL_CAUSEOFREVELATION
                
            break
        }
        
        btnCancelDownload.setButtonDisabled()
    }
    func setViewForCurrentDownloadBookMode() {
        vWordMeaning.isHidden = true
        vTafseer.isHidden = true
        vTranslation.isHidden = true
        vCauseOfRevelation.isHidden = true
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            vWordMeaning.isHidden = false
            
            btnWordMeaning.setTitle(currentWordMeaningBook.Name, for: .normal)
            
            break
        case .Tafseer:
            vTafseer.isHidden = false
            
            btnTafseer.setTitle(currentTafseerBook.Name, for: .normal)
            
            break
        case .Translation:
            vTranslation.isHidden = false
            
            btnTranslation.setTitle(currentTranslationBook.Name, for: .normal)
            
            break
        case .CauseOfRevelation:
            vCauseOfRevelation.isHidden = false
            
            btnCauseOfRevelation.setTitle(currentCauseOfRevelationBook.Name, for: .normal)
            
            break
        }
        
        btnLanguage.setTitle(currentLanguage.Name, for: .normal)
    }
    func loadDataForBookTableView() {
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            wordMeaningBookList = WordMeaningBookRepository().getWordMeaningBookListForDetail()
            
            break
        case .Tafseer:
            tafseerBookList = TafseerBookRepository().getTafseerBookListForDetail()
            
            break
        case .Translation:
            translationBookList = TranslationBookRepository().getTranslationBookListForDetail()
            
            break
        case .CauseOfRevelation:
            causeOfRevelationBookList = CauseOfRevelationBookRepository().getCauseOfRevelationBookListForDetail()
            
            break
        }
    }
    func countForBookTableView() -> Int {
        var count:Int = 0
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            count = wordMeaningBookList.count
            
            break
        case .Tafseer:
            count = tafseerBookList.count
            
            break
        case .Translation:
            count = translationBookList.count
            
            break
        case .CauseOfRevelation:
            count = causeOfRevelationBookList.count
            
            break
        }
        
        return count
    }
    func bindBookTableViewCell(currentBookTableViewCell: BookTableViewCell, index: Int) -> BookTableViewCell {
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            currentBookTableViewCell.lblName.text = wordMeaningBookList[index].Name
            currentBookTableViewCell.lblLanguage.text = LanguageRepository().getLanguage(Id: wordMeaningBookList[index].LanguageId).Name
            currentBookTableViewCell.Id = wordMeaningBookList[index].Id
            
            if ApplicationData.WordMeaningBookList.contains(where: { $0.Id == wordMeaningBookList[index].Id }) {
                currentBookTableViewCell.chkSelect.on = true
            }
            
            break
        case .Tafseer:
            currentBookTableViewCell.lblName.text = tafseerBookList[index].Name
            currentBookTableViewCell.lblLanguage.text = LanguageRepository().getLanguage(Id: tafseerBookList[index].LanguageId).Name
            currentBookTableViewCell.Id = tafseerBookList[index].Id
            
            if ApplicationData.TafseerBookList.contains(where: { $0.Id == tafseerBookList[index].Id }) {
                currentBookTableViewCell.chkSelect.on = true
            }
            
            break
        case .Translation:
            currentBookTableViewCell.lblName.text = translationBookList[index].Name
            currentBookTableViewCell.lblLanguage.text = LanguageRepository().getLanguage(Id: translationBookList[index].LanguageId).Name
            currentBookTableViewCell.Id = translationBookList[index].Id
            
            if ApplicationData.TranslationBookList.contains(where: { $0.Id == translationBookList[index].Id }) {
                currentBookTableViewCell.chkSelect.on = true
            }
            
            break
        case .CauseOfRevelation:
            currentBookTableViewCell.lblName.text = causeOfRevelationBookList[index].Name
            currentBookTableViewCell.lblLanguage.text = LanguageRepository().getLanguage(Id: causeOfRevelationBookList[index].LanguageId).Name
            currentBookTableViewCell.Id = causeOfRevelationBookList[index].Id
            
            if ApplicationData.CauseOfRevelationBookList.contains(where: { $0.Id == causeOfRevelationBookList[index].Id }) {
                currentBookTableViewCell.chkSelect.on = true
            }
            
            break
        }
        
        return currentBookTableViewCell
    }
    func validateView() -> Bool {
        var status = true
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            if currentWordMeaningBook.Id <= 0 {
                status = false
                
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.SELECT_BOOK, okHandler: {})
            }
            
            break
        case .Tafseer:
            if currentTafseerBook.Id <= 0 {
                status = false
                
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.SELECT_BOOK, okHandler: {})
            }
            
            break
        case .Translation:
            if currentTranslationBook.Id <= 0 {
                status = false
                
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.SELECT_BOOK, okHandler: {})
            }
            
            break
        case .CauseOfRevelation:
            if currentCauseOfRevelationBook.Id <= 0 {
                status = false
                
                DialogueManager.showInfo(viewController: self, message: ApplicationInfoMessage.SELECT_BOOK, okHandler: {})
            }
            
            break
        }
        
        return status
    }
    func setDownloadConstraint(enableConstraint: Bool) {
        if enableConstraint {
            vMain.setViewDisabled()
            btnTopClose.setButtonDisabled()
            btnCancelDownload.setButtonEnabled()
            btnDownload.setButtonDisabled()
            btnClose.setButtonDisabled()
            tvBook.setViewDisabled()
        }
        else {
            vMain.setViewEnabled()
            btnTopClose.setButtonEnabled()
            btnCancelDownload.setButtonDisabled()
            btnDownload.setButtonEnabled()
            btnClose.setButtonEnabled()
            tvBook.setViewEnabled()
        }
    }
    
    // ********** Main Section ********** //
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnLanguage_TouchUp(_ sender: Any) {
        downloadBookSelected = false
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnTafseer_TouchUp(_ sender: Any) {
        downloadBookSelected = true
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnTranslation_TouchUp(_ sender: Any) {
        downloadBookSelected = true
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnWordMeaning_TouchUp(_ sender: Any) {
        downloadBookSelected = true
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    @IBAction func btnCauseOfRevelation_TouchUp(_ sender: Any) {
        downloadBookSelected = true
        
        self.performSegue(withIdentifier: "SegueDropDown", sender: nil)
    }
    
    // ********** Download Section ********** //
    @IBAction func btnDownload_TouchUp(_ sender: Any) {
        if validateView() {
            var bookId: Int64 = 0
            
            setDownloadConstraint(enableConstraint: true)
            
            switch ApplicationData.CurrentDownloadBookMode {
            case .WordMeaning:
                bookId = currentWordMeaningBook.Id
                
                break
            case .Tafseer:
                bookId = currentTafseerBook.Id
                
                break
            case .Translation:
                bookId = currentTranslationBook.Id
                
                break
            case .CauseOfRevelation:
                bookId = currentCauseOfRevelationBook.Id
                
                break
            }
            
            BookManager.downloadBook(uiOProgressView: pvOverallProgressView, currentBookId: bookId, currentLanguageId: currentLanguage.Id, completionHandler: {
                self.setDownloadConstraint(enableConstraint: false)
                self.loadDataForBookTableView()
                self.tvBook.reloadData()
            })
        }
    }
    @IBAction func btnCancelDownload_TouchUp(_ sender: Any) {
        BookManager.cancelDownloadBook(yesHandler: {
            self.setDownloadConstraint(enableConstraint: false)
            self.loadDataForBookTableView()
            self.tvBook.reloadData()
        })
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
