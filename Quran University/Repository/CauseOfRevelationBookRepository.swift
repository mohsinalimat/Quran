import Foundation
import SQLite3

class CauseOfRevelationBookRepository : BaseRepository {
    func getCauseOfRevelationBookList() -> [CauseOfRevelationBook] {
        var stmt: OpaquePointer?
        var causeOfRevelationBookList = [CauseOfRevelationBook]()
        let queryString = "SELECT * FROM CauseOfRevelationBook WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let causeOfRevelationBookObject = CauseOfRevelationBook(Id: sqlite3_column_int64(stmt, 0))
            
            causeOfRevelationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            causeOfRevelationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            causeOfRevelationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            causeOfRevelationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            causeOfRevelationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            causeOfRevelationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            causeOfRevelationBookList.append(causeOfRevelationBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookList
    }
    func getCauseOfRevelationBook(Id: Int64) -> CauseOfRevelationBook {
        var stmt: OpaquePointer?
        var causeOfRevelationBookObject = CauseOfRevelationBook()
        let queryString = "SELECT * FROM CauseOfRevelationBook WHERE Id = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return causeOfRevelationBookObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            causeOfRevelationBookObject = CauseOfRevelationBook(Id: sqlite3_column_int64(stmt, 0))
            
            causeOfRevelationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            causeOfRevelationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            causeOfRevelationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            causeOfRevelationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            causeOfRevelationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            causeOfRevelationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookObject
    }
    func getFirstCauseOfRevelationBook() -> CauseOfRevelationBook {
        var stmt: OpaquePointer?
        var causeOfRevelationBookObject = CauseOfRevelationBook()
        let queryString = "SELECT * FROM CauseOfRevelationBook WHERE IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            causeOfRevelationBookObject = CauseOfRevelationBook(Id: sqlite3_column_int64(stmt, 0))
            
            causeOfRevelationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            causeOfRevelationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            causeOfRevelationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            causeOfRevelationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            causeOfRevelationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            causeOfRevelationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookObject
    }
    func getCauseOfRevelationBookList(languageId: Int64) -> [CauseOfRevelationBook] {
        var stmt: OpaquePointer?
        var causeOfRevelationBookList = [CauseOfRevelationBook]()
        let queryString = "SELECT * FROM CauseOfRevelationBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookList
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return causeOfRevelationBookList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let causeOfRevelationBookObject = CauseOfRevelationBook(Id: sqlite3_column_int64(stmt, 0))
            
            causeOfRevelationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            causeOfRevelationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            causeOfRevelationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            causeOfRevelationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            causeOfRevelationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            causeOfRevelationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            causeOfRevelationBookList.append(causeOfRevelationBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookList
    }
    func getFirstCauseOfRevelationBook(languageId: Int64) -> CauseOfRevelationBook {
        var stmt: OpaquePointer?
        var causeOfRevelationBookObject = CauseOfRevelationBook()
        let queryString = "SELECT * FROM CauseOfRevelationBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return causeOfRevelationBookObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            causeOfRevelationBookObject = CauseOfRevelationBook(Id: sqlite3_column_int64(stmt, 0))
            
            causeOfRevelationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            causeOfRevelationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            causeOfRevelationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            causeOfRevelationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            causeOfRevelationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            causeOfRevelationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookObject
    }
    func getCauseOfRevelationBookListForDetail() -> [CauseOfRevelationBook] {
        var stmt: OpaquePointer?
        var causeOfRevelationBookList = [CauseOfRevelationBook]()
        let queryString = "SELECT * FROM CauseOfRevelationBook WHERE Id IN (SELECT CauseOfRevelationBookId FROM CauseOfRevelationBookDetail WHERE IsDeleted = 0) AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let causeOfRevelationBookObject = CauseOfRevelationBook(Id: sqlite3_column_int64(stmt, 0))
            
            causeOfRevelationBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            causeOfRevelationBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            causeOfRevelationBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            causeOfRevelationBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            causeOfRevelationBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            causeOfRevelationBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            causeOfRevelationBookList.append(causeOfRevelationBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookList
    }
}

