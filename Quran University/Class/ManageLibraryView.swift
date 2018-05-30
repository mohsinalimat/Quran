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
        
        tvLibraryBook.reloadData()
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
        
        switch currentLibraryBookMode {
        case .Tafseer:
            let objTafseerBook = ApplicationData.TafseerBookList[indexPath.row]
            let objLanguage = LanguageRepository().getLanguage(Id: objTafseerBook.LanguageId)
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let objTafseerBookDetail = TafseerBookDetailRepository().getTafseerBookDetail(tafseerBookId: objTafseerBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
//            let bookText = NSMutableAttributedString(string: ApplicationLabel.LANGUAGE + ": ")
//            var temp = NSMutableAttributedString(string: objLanguage.Name)
//            var bookRange = NSRange(location: 0, length: 0)
//            var startIndex = bookText.length
//
//            bookText.append(temp)
//            bookRange = NSRange(location: startIndex, length: temp.length)
//            bookText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.gray, range: bookRange)
//
//            bookText.append(NSMutableAttributedString(string: ", " + ApplicationLabel.BOOK + ": "))
//            startIndex = bookText.length
//            temp = NSMutableAttributedString(string: objTafseerBook.Name)
//
//            bookText.append(temp)
//            bookRange = NSRange(location: startIndex, length: temp.length)
//            bookText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: bookRange)
//
//            tvcLibraryBook.lblBook.attributedText = bookText
            tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "' , " + ApplicationLabel.BOOK + ": '" + objTafseerBook.Name + "'"
            tvcLibraryBook.lblAyat.text = objTafseerBookDetail.AyatTafseer
            
            if !objLanguage.IsLanguageLTR {
                tvcLibraryBook.lblAyat.textAlignment = .right
            }
            
            break
        case .Translation:
            let objTranslationBook = ApplicationData.TranslationBookList[indexPath.row]
            let objLanguage = LanguageRepository().getLanguage(Id: objTranslationBook.LanguageId)
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let objTranslationBookDetail = TranslationBookDetailRepository().getTranslationBookDetail(translationBookId: objTranslationBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
            
            tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "' , " + ApplicationLabel.BOOK + ": '" + objTranslationBook.Name + "'"
            tvcLibraryBook.lblAyat.text = objTranslationBookDetail.AyatTranslation
            
            if !objLanguage.IsLanguageLTR {
                tvcLibraryBook.lblAyat.textAlignment = .right
            }
            
            break
        case .WordMeaning:
            let objWordMeaningBook = ApplicationData.WordMeaningBookList[indexPath.row]
            let objLanguage = LanguageRepository().getLanguage(Id: objWordMeaningBook.LanguageId)
            let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
            let lstWordMeaningBookDetail = WordMeaningBookDetailRepository().getWordMeaningBookDetailList(wordMeaningBookId: objWordMeaningBook.Id, surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
            let ayatText = NSMutableAttributedString(string: "")
            
            tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": '" + objLanguage.Name + "'"
            
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
            
            if !objLanguage.IsLanguageLTR {
                tvcLibraryBook.lblAyat.textAlignment = .right
            }
            
            break
        case .CauseOfRevelation:
            tvcLibraryBook.lblBook.text = "Book 1"
            tvcLibraryBook.lblAyat.text = """
            Praesent vestibulum ornare semper. Phasellus vel sagittis justo. Mauris sed porta est. Sed efficitur, leo in sodales venenatis, mauris mi mollis elit, in lobortis velit velit ut lacus. Etiam interdum tincidunt condimentum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam id sem scelerisque, maximus arcu id, bibendum libero.
            """
            
            break
        default:
            tvcLibraryBook.lblBook.text = ""
            tvcLibraryBook.lblAyat.text = ""
            
            break
        }
        
        return tvcLibraryBook
    }
}
