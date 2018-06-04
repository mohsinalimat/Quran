import Foundation

class ApplicationDataManager {
    static func initApplicationData() {
        populateTafseerBookSelection()
        populateTranslationBookSelection()
        populateWordMeaningBookSelection()
        populateCauseOfRevelationBookSelection()
    }
    static func populateTafseerBookSelection() {
        let appObjectLocationList = AppObjectLocationRepository().getAppObjectLocationList(appObjectId: Int64(AppObjectCode.Download.rawValue), objectId: Int64(ObjectCode.Tafseer.rawValue))
        
        for appObjectLocationObject in appObjectLocationList {
            let tafseerBookObject = TafseerBookRepository().getTafseerBook(Id: appObjectLocationObject.ObjectLocationId)
            
            ApplicationData.TafseerBookList.append(tafseerBookObject)
        }
    }
    static func populateTranslationBookSelection() {
        let appObjectLocationList = AppObjectLocationRepository().getAppObjectLocationList(appObjectId: Int64(AppObjectCode.Download.rawValue), objectId: Int64(ObjectCode.Translation.rawValue))
        
        for appObjectLocationObject in appObjectLocationList {
            let translationBookObject = TranslationBookRepository().getTranslationBook(Id: appObjectLocationObject.ObjectLocationId)
            
            ApplicationData.TranslationBookList.append(translationBookObject)
        }
    }
    static func populateWordMeaningBookSelection() {
        let appObjectLocationList = AppObjectLocationRepository().getAppObjectLocationList(appObjectId: Int64(AppObjectCode.Download.rawValue), objectId: Int64(ObjectCode.WordMeaning.rawValue))
        
        for appObjectLocationObject in appObjectLocationList {
            let wordMeaningBookObject = WordMeaningBookRepository().getWordMeaningBook(Id: appObjectLocationObject.ObjectLocationId)
            
            ApplicationData.WordMeaningBookList.append(wordMeaningBookObject)
        }
    }
    static func populateCauseOfRevelationBookSelection() {
        let appObjectLocationList = AppObjectLocationRepository().getAppObjectLocationList(appObjectId: Int64(AppObjectCode.Download.rawValue), objectId: Int64(ObjectCode.CauseOfRevelation.rawValue))
        
        for appObjectLocationObject in appObjectLocationList {
            let causeOfRevelationBookObject = CauseOfRevelationBookRepository().getCauseOfRevelationBook(Id: appObjectLocationObject.ObjectLocationId)
            
            ApplicationData.CauseOfRevelationBookList.append(causeOfRevelationBookObject)
        }
    }
}
