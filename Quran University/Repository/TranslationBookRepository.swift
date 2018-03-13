import Foundation
import SQLite3

class TranslationBookRepository : BaseRepository {
    func getTranslationBookList() -> [TranslationBook] {
        var stmt: OpaquePointer?
        var translationBookList = [TranslationBook]()
        let queryString = "SELECT * FROM TranslationBook WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let translationBookObject = TranslationBook(Id: sqlite3_column_int64(stmt, 0))
            
            translationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            translationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            translationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            translationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            translationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            translationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            translationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            translationBookList.append(translationBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookList
    }
    func getTranslationBook(Id: Int64) -> TranslationBook {
        var stmt: OpaquePointer?
        var translationBookObject = TranslationBook()
        let queryString = "SELECT * FROM TranslationBook WHERE Id = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return translationBookObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            translationBookObject = TranslationBook(Id: sqlite3_column_int64(stmt, 0))
            
            translationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            translationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            translationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            translationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            translationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            translationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            translationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookObject
    }
    func getFirstTranslationBook() -> TranslationBook {
        var stmt: OpaquePointer?
        var translationBookObject = TranslationBook()
        let queryString = "SELECT * FROM TranslationBook WHERE IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            translationBookObject = TranslationBook(Id: sqlite3_column_int64(stmt, 0))
            
            translationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            translationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            translationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            translationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            translationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            translationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            translationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookObject
    }
    func getTranslationBookList(languageId: Int64) -> [TranslationBook] {
        var stmt: OpaquePointer?
        var translationBookList = [TranslationBook]()
        let queryString = "SELECT * FROM TranslationBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookList
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return translationBookList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let translationBookObject = TranslationBook(Id: sqlite3_column_int64(stmt, 0))
            
            translationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            translationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            translationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            translationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            translationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            translationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            translationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            translationBookList.append(translationBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookList
    }
    func getFirstTranslationBook(languageId: Int64) -> TranslationBook {
        var stmt: OpaquePointer?
        var translationBookObject = TranslationBook()
        let queryString = "SELECT * FROM TranslationBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return translationBookObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            translationBookObject = TranslationBook(Id: sqlite3_column_int64(stmt, 0))
            
            translationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            translationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            translationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            translationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            translationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            translationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            translationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookObject
    }
    func getTranslationBookListForDetail() -> [TranslationBook] {
        var stmt: OpaquePointer?
        var translationBookList = [TranslationBook]()
        let queryString = "SELECT * FROM TranslationBook WHERE Id IN (SELECT TranslationBookId FROM TranslationBookDetail WHERE IsDeleted = 0) AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let translationBookObject = TranslationBook(Id: sqlite3_column_int64(stmt, 0))
            
            translationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            translationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            translationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            translationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            translationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            translationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            translationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            translationBookList.append(translationBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookList
    }
}
