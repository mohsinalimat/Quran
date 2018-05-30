import UIKit

class ManageLibraryView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvLibraryBook: UITableView!
    
    var currentLibraryBookMode = LibraryBookMode.Tafseer
    var count = 0
    
    func initializeView() {
        tvLibraryBook.delegate = self
        tvLibraryBook.dataSource = self
    }
    func loadView(libraryBookMode: LibraryBookMode) {
        currentLibraryBookMode = libraryBookMode
        tvLibraryBook.isHidden = false
        
        if libraryBookMode != .None {
            tvLibraryBook.reloadData()
        }
        else {
            tvLibraryBook.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentLibraryBookMode {
        case .Tafseer:
            count = ApplicationData.TafseerBookList.count
            
            break
        case .Translation:
            count = ApplicationData.TranslationBookList.count
            
            break
        case .WordMeaning:
            count = ApplicationData.WordMeaningBookList.count
            
            break
        case .CauseOfRevelation:
            count = ApplicationData.CauseOfRevelationBookList.count
            
            break
        default:
            count = 0
            
            break
        }
        
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcLibraryBook = tvLibraryBook.dequeueReusableCell(withIdentifier: "tvcLibraryBook") as! LibraryBookTableViewCell
        var objLanguage = Language(Id: 0)
        let number = Int32(indexPath.row) + 1 // Int32(arc4random_uniform(18)) + 1
        var dataExists = false
        
        tvcLibraryBook.lblBook.text = ""
        tvcLibraryBook.lblAyat.text = ""
        tvcLibraryBook.lblBook.backgroundColor = UIColor.white
        tvcLibraryBook.lblAyat.backgroundColor = UIColor.white
        
        switch currentLibraryBookMode {
        case .Tafseer:
            let objTafseerBook = ApplicationData.TafseerBookList[indexPath.row]
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let objTafseerBookDetail = TafseerBookDetailRepository().getTafseerBookDetail(tafseerBookId: objTafseerBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
            
            if objTafseerBookDetail.Id > 0 {
                objLanguage = LanguageRepository().getLanguage(Id: objTafseerBook.LanguageId)
                tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "' , " + ApplicationLabel.BOOK + ": '" + objTafseerBook.Name + "'"
                tvcLibraryBook.lblAyat.text = objTafseerBookDetail.AyatTafseer + "\n"
                dataExists = true
            }
            
            break
        case .Translation:
            let objTranslationBook = ApplicationData.TranslationBookList[indexPath.row]
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let objTranslationBookDetail = TranslationBookDetailRepository().getTranslationBookDetail(translationBookId: objTranslationBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
            
            if objTranslationBookDetail.Id > 0 {
                objLanguage = LanguageRepository().getLanguage(Id: objTranslationBook.LanguageId)
                tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "' , " + ApplicationLabel.BOOK + ": '" + objTranslationBook.Name + "'"
                tvcLibraryBook.lblAyat.text = objTranslationBookDetail.AyatTranslation + "\n"
                dataExists = true
            }
            
            break
        case .WordMeaning:
            let objWordMeaningBook = ApplicationData.WordMeaningBookList[indexPath.row]
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let lstWordMeaningBookDetail = WordMeaningBookDetailRepository().getWordMeaningBookDetailList(wordMeaningBookId: objWordMeaningBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
            
            if lstWordMeaningBookDetail.count > 0 {
                let ayatText = NSMutableAttributedString(string: "")
                
                objLanguage = LanguageRepository().getLanguage(Id: objWordMeaningBook.LanguageId)
                tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "'"
                dataExists = true
                
                for objWordMeaningBookDetail in lstWordMeaningBookDetail {
                    let ayatWord = NSAttributedString(string: objWordMeaningBookDetail.AyatWord + " : ")
                    let ayatMeaning = NSAttributedString(string: objWordMeaningBookDetail.AyatMeaning + "\n")
                    
                    ayatText.append(ayatWord)
                    
                    let startIndex = ayatText.length
                    
                    ayatText.append(ayatMeaning)
                    
                    let ayatMeaningRange = NSRange(location: startIndex, length: ayatMeaning.length)
                    
                    ayatText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: ayatMeaningRange)
                }
                
                tvcLibraryBook.lblAyat.attributedText = ayatText
            }
            
            break
        case .CauseOfRevelation:
            let objCauseOfRevelationBook = ApplicationData.CauseOfRevelationBookList[indexPath.row]
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let objCauseOfRevelationBookDetail = CauseOfRevelationBookDetailRepository().getCauseOfRevelationBookDetail(causeOfRevelationBookId: objCauseOfRevelationBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
            
            if objCauseOfRevelationBookDetail.Id > 0 {
                objLanguage = LanguageRepository().getLanguage(Id: objCauseOfRevelationBook.LanguageId)
                tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "'"
                tvcLibraryBook.lblAyat.text = objCauseOfRevelationBookDetail.AyatCauseOfRevelation + "\n"
                dataExists = true
            }
            
            break
        default:
            break
        }
        
        if !objLanguage.IsLanguageLTR {
            tvcLibraryBook.lblAyat.textAlignment = .right
        }
        
        if dataExists {
            tvcLibraryBook.lblBook.backgroundColor = ApplicationMethods.getCorrectionBColor(number: number)
            tvcLibraryBook.lblAyat.backgroundColor = ApplicationMethods.getCorrectionBGColor(number: number)
        }
        
        return tvcLibraryBook
    }
}
