import Foundation
import SQLite3

class ScriptRepository : BaseRepository {
    func getScriptList() -> [Script] {
        var stmt: OpaquePointer?
        var scriptList = [Script]()
        let queryString = "SELECT * FROM Script WHERE IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return scriptList
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let scriptObject = Script(Id: sqlite3_column_int64(stmt, 0))
            
            scriptObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            scriptObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            scriptObject.Description = String(cString: sqlite3_column_text(stmt, 3)!) as String
            scriptObject.Company = String(cString: sqlite3_column_text(stmt, 4)!) as String
            scriptObject.Author = String(cString: sqlite3_column_text(stmt, 5)!) as String
            scriptObject.NumberOfPages = sqlite3_column_int64(stmt, 6)
            scriptObject.NumberOfTextPages = sqlite3_column_int64(stmt, 7)
            scriptObject.NumberOfLinesOnPage = sqlite3_column_int64(stmt, 8)
            scriptObject.PageHeight = sqlite3_column_int64(stmt, 9)
            scriptObject.PageWidth = sqlite3_column_int64(stmt, 10)
            scriptObject.RowHeight = sqlite3_column_int64(stmt, 11)
            scriptObject.IsDeleted = sqlite3_column_int64(stmt, 12) == 1 ? true : false
            scriptObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 13)!) as String))!
            scriptObject.Deactivate = sqlite3_column_int64(stmt, 14) == 1 ? true : false
            
            scriptList.append(scriptObject)
        }
        
        sqlite3_finalize(stmt)
        
        return scriptList
    }
    func getScript(Id: Int64) -> Script {
        var stmt: OpaquePointer?
        var scriptObject = Script()
        let queryString = "SELECT * FROM Script WHERE Id = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return scriptObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return scriptObject
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            scriptObject = Script(Id: sqlite3_column_int64(stmt, 0))
            
            scriptObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            scriptObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            scriptObject.Description = String(cString: sqlite3_column_text(stmt, 3)!) as String
            scriptObject.Company = String(cString: sqlite3_column_text(stmt, 4)!) as String
            scriptObject.Author = String(cString: sqlite3_column_text(stmt, 5)!) as String
            scriptObject.NumberOfPages = sqlite3_column_int64(stmt, 6)
            scriptObject.NumberOfTextPages = sqlite3_column_int64(stmt, 7)
            scriptObject.NumberOfLinesOnPage = sqlite3_column_int64(stmt, 8)
            scriptObject.PageHeight = sqlite3_column_int64(stmt, 9)
            scriptObject.PageWidth = sqlite3_column_int64(stmt, 10)
            scriptObject.RowHeight = sqlite3_column_int64(stmt, 11)
            scriptObject.IsDeleted = sqlite3_column_int64(stmt, 12) == 1 ? true : false
            scriptObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 13)!) as String))!
            scriptObject.Deactivate = sqlite3_column_int64(stmt, 14) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return scriptObject
    }
}
