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
        let appObjectLocationObject = AppObjectLocation()
        let isSelected = (sender as! BEMCheckBox).on
        
        appObjectLocationObject.AppObjectId = Int64(AppObjectCode.Download.rawValue)
        appObjectLocationObject.ObjectLocationId = Id
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            appObjectLocationObject.ObjectId = Int64(ObjectCode.WordMeaning.rawValue)
            
            if isSelected {
                ApplicationData.WordMeaningBookList.append(WordMeaningBookRepository().getWordMeaningBook(Id: Id))
            }
            else {
                ApplicationData.WordMeaningBookList = ApplicationData.WordMeaningBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        case .Tafseer:
            appObjectLocationObject.ObjectId = Int64(ObjectCode.Tafseer.rawValue)
            
            if isSelected {
                ApplicationData.TafseerBookList.append(TafseerBookRepository().getTafseerBook(Id: Id))
            }
            else {
                ApplicationData.TafseerBookList = ApplicationData.TafseerBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        case .Translation:
            appObjectLocationObject.ObjectId = Int64(ObjectCode.Translation.rawValue)
            
            if isSelected {
                ApplicationData.TranslationBookList.append(TranslationBookRepository().getTranslationBook(Id: Id))
            }
            else {
                ApplicationData.TranslationBookList = ApplicationData.TranslationBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        case .CauseOfRevelation:
            appObjectLocationObject.ObjectId = Int64(ObjectCode.CauseOfRevelation.rawValue)
            
            if isSelected {
                ApplicationData.CauseOfRevelationBookList.append(CauseOfRevelationBookRepository().getCauseOfRevelationBook(Id: Id))
            }
            else {
                ApplicationData.CauseOfRevelationBookList = ApplicationData.CauseOfRevelationBookList.lazy.filter { $0.Id != self.Id }
            }
            
            break
        }
        
        if isSelected {
            _ = AppObjectLocationRepository().saveAppObjectLocation(appObjectLocationObject: appObjectLocationObject)
        }
        else {
            _ = AppObjectLocationRepository().deleteAppObjectLocation(appObjectId: appObjectLocationObject.AppObjectId, objectId: appObjectLocationObject.ObjectId, objectLocationId: appObjectLocationObject.ObjectLocationId)
        }
        
        ApplicationObject.MainViewController.loadCurrentLibraryBook()
        
        (self.superview as! UITableView).reloadData()
    }
    @IBAction func btnDelete_TouchUp(_ sender: Any) {
        var objectId: Int64 = 0
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            objectId = Int64(ObjectCode.WordMeaning.rawValue)
            _ = WordMeaningBookDetailRepository().deleteWordMeaningBookDetail(wordMeaningBookId: Id)
            ApplicationData.WordMeaningBookList = ApplicationData.WordMeaningBookList.lazy.filter { $0.Id != self.Id }
            
            break
        case .Tafseer:
            objectId = Int64(ObjectCode.Tafseer.rawValue)
            _ = TafseerBookDetailRepository().deleteTafseerBookDetail(tafseerBookId: Id)
            ApplicationData.TafseerBookList = ApplicationData.TafseerBookList.lazy.filter { $0.Id != self.Id }
            
            break
        case .Translation:
            objectId = Int64(ObjectCode.Translation.rawValue)
            _ = TranslationBookDetailRepository().deleteTranslationBookDetail(translationBookId: Id)
            ApplicationData.TranslationBookList = ApplicationData.TranslationBookList.lazy.filter { $0.Id != self.Id }
            
            break
        case .CauseOfRevelation:
            objectId = Int64(ObjectCode.CauseOfRevelation.rawValue)
            _ = CauseOfRevelationBookDetailRepository().deleteCauseOfRevelationBookDetail(causeOfRevelationBookId: Id)
            ApplicationData.CauseOfRevelationBookList = ApplicationData.CauseOfRevelationBookList.lazy.filter { $0.Id != self.Id }
            
            break
        }
        
        _ = AppObjectLocationRepository().deleteAppObjectLocation(appObjectId: Int64(AppObjectCode.Download.rawValue), objectId: objectId, objectLocationId: Id)
        
        (ApplicationObject.CurrentViewController as! TMDownloadBookViewController).loadDataForBookTableView()
        (self.superview as! UITableView).reloadData()
    }
}
