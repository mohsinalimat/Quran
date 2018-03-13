import Foundation
import SQLite3

class LanguageRepository : BaseRepository {
    func getLanguageList() -> [Language] {
        var stmt: OpaquePointer?
        var languageList = [Language]()
        let queryString = "SELECT * FROM Language WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return languageList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let languageObject = Language(Id: sqlite3_column_int64(stmt, 0))
            
            languageObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            languageObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            languageObject.OrderNo = sqlite3_column_int64(stmt, 3)
            languageObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            languageObject.IsDeleted = sqlite3_column_int64(stmt, 5) == 1 ? true : false
            languageObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 6)!) as String))!
            languageObject.IsLanguageLTR = sqlite3_column_int64(stmt, 7) == 1 ? true : false
            languageObject.LanguageIcon = String(cString: sqlite3_column_text(stmt, 8)!) as String
            
            languageList.append(languageObject)
        }
        
        sqlite3_finalize(stmt)
        
        return languageList
    }
    func getLanguage(Id: Int64) -> Language {
        var stmt: OpaquePointer?
        var languageObject = Language()
        let queryString = "SELECT * FROM Language WHERE Id = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return languageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return languageObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            languageObject = Language(Id: sqlite3_column_int64(stmt, 0))
            
            languageObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            languageObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            languageObject.OrderNo = sqlite3_column_int64(stmt, 3)
            languageObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            languageObject.IsDeleted = sqlite3_column_int64(stmt, 5) == 1 ? true : false
            languageObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 6)!) as String))!
            languageObject.IsLanguageLTR = sqlite3_column_int64(stmt, 7) == 1 ? true : false
            languageObject.LanguageIcon = String(cString: sqlite3_column_text(stmt, 8)!) as String
        }
        
        sqlite3_finalize(stmt)
        
        return languageObject
    }
    func getFirstLanguage() -> Language {
        var stmt: OpaquePointer?
        var languageObject = Language()
        let queryString = "SELECT * FROM Language WHERE IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return languageObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            languageObject = Language(Id: sqlite3_column_int64(stmt, 0))
            
            languageObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            languageObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            languageObject.OrderNo = sqlite3_column_int64(stmt, 3)
            languageObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            languageObject.IsDeleted = sqlite3_column_int64(stmt, 5) == 1 ? true : false
            languageObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 6)!) as String))!
            languageObject.IsLanguageLTR = sqlite3_column_int64(stmt, 7) == 1 ? true : false
            languageObject.LanguageIcon = String(cString: sqlite3_column_text(stmt, 8)!) as String
        }
        
        sqlite3_finalize(stmt)
        
        return languageObject
    }
}
