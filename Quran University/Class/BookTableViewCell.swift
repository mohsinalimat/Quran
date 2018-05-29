import UIKit
import BEMCheckBox

class BookTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var chkSelect: BEMCheckBox!
    @IBOutlet weak var btnDelete: UIButton!
    
    var Id: Int64 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func chkSelect_ValueChanged(_ sender: Any) {
        let isSelected = (sender as! BEMCheckBox).on
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            if isSelected {
                ApplicationData.WordMeaningBookList.append(WordMeaningBookRepository().getWordMeaningBook(Id: Id))
            }
            else {
                ApplicationData.WordMeaningBookList = ApplicationData.WordMeaningBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        case .Tafseer:
            if isSelected {
                ApplicationData.TafseerBookList.append(TafseerBookRepository().getTafseerBook(Id: Id))
            }
            else {
                ApplicationData.TafseerBookList = ApplicationData.TafseerBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        case .Translation:
            if isSelected {
                ApplicationData.TranslationBookList.append(TranslationBookRepository().getTranslationBook(Id: Id))
            }
            else {
                ApplicationData.TranslationBookList = ApplicationData.TranslationBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        case .CauseOfRevelation:
            if isSelected {
                ApplicationData.CauseOfRevelationBookList.append(CauseOfRevelationBookRepository().getCauseOfRevelationBook(Id: Id))
            }
            else {
                ApplicationData.CauseOfRevelationBookList = ApplicationData.CauseOfRevelationBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        }
        
        (self.superview as! UITableView).reloadData()
    }
    @IBAction func btnDelete_TouchUp(_ sender: Any) {
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            _ = WordMeaningBookDetailRepository().deleteWordMeaningBookDetail(wordMeaningBookId: Id)
            ApplicationData.WordMeaningBookList = ApplicationData.WordMeaningBookList.lazy.filter { $0.Id != self.Id }
            
            break
        case .Tafseer:
            _ = TafseerBookDetailRepository().deleteTafseerBookDetail(tafseerBookId: Id)
            ApplicationData.TafseerBookList = ApplicationData.TafseerBookList.lazy.filter { $0.Id != self.Id }
            
            break
        case .Translation:
            _ = TranslationBookDetailRepository().deleteTranslationBookDetail(translationBookId: Id)
            ApplicationData.TranslationBookList = ApplicationData.TranslationBookList.lazy.filter { $0.Id != self.Id }
            
            break
        case .CauseOfRevelation:
            _ = CauseOfRevelationBookDetailRepository().deleteCauseOfRevelationBookDetail(causeOfRevelationBookId: Id)
            ApplicationData.CauseOfRevelationBookList = ApplicationData.CauseOfRevelationBookList.lazy.filter { $0.Id != self.Id }
            
            break
        }
        
        (ApplicationObject.CurrentViewController as! TMDownloadBookViewController).loadDataForBookTableView()
        (self.superview as! UITableView).reloadData()
    }
}
