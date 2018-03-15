import Foundation
import SQLite3

class TafseerBookRepository : BaseRepository {
    func getTafseerBookList() -> [TafseerBook] {
        var stmt: OpaquePointer?
        var tafseerBookList = [TafseerBook]()
        let queryString = "SELECT * FROM TafseerBook WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let tafseerBookObject = TafseerBook(Id: sqlite3_column_int64(stmt, 0))
            
            tafseerBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            tafseerBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            tafseerBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            tafseerBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            tafseerBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            tafseerBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            tafseerBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            tafseerBookList.append(tafseerBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookList
    }
    func getTafseerBook(Id: Int64) -> TafseerBook {
        var stmt: OpaquePointer?
        var tafseerBookObject = TafseerBook()
        let queryString = "SELECT * FROM TafseerBook WHERE Id = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return tafseerBookObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            tafseerBookObject = TafseerBook(Id: sqlite3_column_int64(stmt, 0))
            
            tafseerBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            tafseerBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            tafseerBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            tafseerBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            tafseerBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            tafseerBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            tafseerBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookObject
    }
    func getFirstTafseerBook() -> TafseerBook {
        var stmt: OpaquePointer?
        var tafseerBookObject = TafseerBook()
        let queryString = "SELECT * FROM TafseerBook WHERE IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            tafseerBookObject = TafseerBook(Id: sqlite3_column_int64(stmt, 0))
            
            tafseerBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            tafseerBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            tafseerBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            tafseerBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            tafseerBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            tafseerBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            tafseerBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookObject
    }
    func getTafseerBookList(languageId: Int64) -> [TafseerBook] {
        var stmt: OpaquePointer?
        var tafseerBookList = [TafseerBook]()
        let queryString = "SELECT * FROM TafseerBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookList
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return tafseerBookList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let tafseerBookObject = TafseerBook(Id: sqlite3_column_int64(stmt, 0))
            
            tafseerBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            tafseerBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            tafseerBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            tafseerBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            tafseerBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            tafseerBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            tafseerBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            tafseerBookList.append(tafseerBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookList
    }
    func getFirstTafseerBook(languageId: Int64) -> TafseerBook {
        var stmt: OpaquePointer?
        var tafseerBookObject = TafseerBook()
        let queryString = "SELECT * FROM TafseerBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return tafseerBookObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            tafseerBookObject = TafseerBook(Id: sqlite3_column_int64(stmt, 0))
            
            tafseerBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            tafseerBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            tafseerBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            tafseerBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            tafseerBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            tafseerBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            tafseerBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookObject
    }
    func getTafseerBookListForDetail() -> [TafseerBook] {
        var stmt: OpaquePointer?
        var tafseerBookList = [TafseerBook]()
        let queryString = "SELECT * FROM TafseerBook WHERE Id IN (SELECT TafseerBookId FROM TafseerBookDetail WHERE IsDeleted = 0) AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let tafseerBookObject = TafseerBook(Id: sqlite3_column_int64(stmt, 0))
            
            tafseerBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            tafseerBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            tafseerBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            tafseerBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            tafseerBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            tafseerBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            tafseerBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            tafseerBookList.append(tafseerBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookList
    }
}
