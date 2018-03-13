import Foundation
import SQLite3

class WordMeaningBookRepository : BaseRepository {
    func getWordMeaningBookList() -> [WordMeaningBook] {
        var stmt: OpaquePointer?
        var wordMeaningBookList = [WordMeaningBook]()
        let queryString = "SELECT * FROM WordMeaningBook WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let wordMeaningBookObject = WordMeaningBook(Id: sqlite3_column_int64(stmt, 0))
            
            wordMeaningBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            wordMeaningBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            wordMeaningBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            wordMeaningBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            wordMeaningBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            wordMeaningBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            wordMeaningBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            wordMeaningBookList.append(wordMeaningBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookList
    }
    func getWordMeaningBook(Id: Int64) -> WordMeaningBook {
        var stmt: OpaquePointer?
        var wordMeaningBookObject = WordMeaningBook()
        let queryString = "SELECT * FROM WordMeaningBook WHERE Id = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return wordMeaningBookObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            wordMeaningBookObject = WordMeaningBook(Id: sqlite3_column_int64(stmt, 0))
            
            wordMeaningBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            wordMeaningBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            wordMeaningBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            wordMeaningBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            wordMeaningBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            wordMeaningBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            wordMeaningBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookObject
    }
    func getFirstWordMeaningBook() -> WordMeaningBook {
        var stmt: OpaquePointer?
        var wordMeaningBookObject = WordMeaningBook()
        let queryString = "SELECT * FROM WordMeaningBook WHERE IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            wordMeaningBookObject = WordMeaningBook(Id: sqlite3_column_int64(stmt, 0))
            
            wordMeaningBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            wordMeaningBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            wordMeaningBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            wordMeaningBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            wordMeaningBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            wordMeaningBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            wordMeaningBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookObject
    }
    func getWordMeaningBookList(languageId: Int64) -> [WordMeaningBook] {
        var stmt: OpaquePointer?
        var wordMeaningBookList = [WordMeaningBook]()
        let queryString = "SELECT * FROM WordMeaningBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookList
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return wordMeaningBookList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let wordMeaningBookObject = WordMeaningBook(Id: sqlite3_column_int64(stmt, 0))
            
            wordMeaningBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            wordMeaningBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            wordMeaningBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            wordMeaningBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            wordMeaningBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            wordMeaningBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            wordMeaningBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            wordMeaningBookList.append(wordMeaningBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookList
    }
    func getFirstWordMeaningBook(languageId: Int64) -> WordMeaningBook {
        var stmt: OpaquePointer?
        var wordMeaningBookObject = WordMeaningBook()
        let queryString = "SELECT * FROM WordMeaningBook WHERE LanguageId = ? AND IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookObject
        }
        
        if sqlite3_bind_int64(stmt, 1, languageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding LanguageId: \(errmsg)")
            return wordMeaningBookObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            wordMeaningBookObject = WordMeaningBook(Id: sqlite3_column_int64(stmt, 0))
            
            wordMeaningBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            wordMeaningBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            wordMeaningBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            wordMeaningBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            wordMeaningBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            wordMeaningBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            wordMeaningBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookObject
    }
    func getWordMeaningBookListForDetail() -> [WordMeaningBook] {
        var stmt: OpaquePointer?
        var wordMeaningBookList = [WordMeaningBook]()
        let queryString = "SELECT * FROM WordMeaningBook WHERE Id IN (SELECT WordMeaningBookId FROM WordMeaningBookDetail WHERE IsDeleted = 0) AND IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let wordMeaningBookObject = WordMeaningBook(Id: sqlite3_column_int64(stmt, 0))
            
            wordMeaningBookObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            wordMeaningBookObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            wordMeaningBookObject.ScholarPLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            wordMeaningBookObject.ScholarSLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookObject.LanguageId = sqlite3_column_int64(stmt, 5)
            wordMeaningBookObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            wordMeaningBookObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            wordMeaningBookObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            wordMeaningBookList.append(wordMeaningBookObject)
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookList
    }
}

