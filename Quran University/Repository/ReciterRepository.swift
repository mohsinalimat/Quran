import Foundation
import SQLite3

class ReciterRepository : BaseRepository {
    func getReciterList() -> [Reciter] {
        var stmt: OpaquePointer?
        var reciterList = [Reciter]()
        let queryString = "SELECT * FROM Reciter WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return reciterList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let reciterObject = Reciter(Id: sqlite3_column_int64(stmt, 0))
            
            reciterObject.UserLoginInfo = sqlite3_column_int64(stmt, 1)
            reciterObject.ReciterNamePLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            reciterObject.ReciterNameSLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            reciterObject.DescPLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            reciterObject.DescSLang = String(cString: sqlite3_column_text(stmt, 5)!) as String
            reciterObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            reciterObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            reciterObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            reciterList.append(reciterObject)
        }
        
        sqlite3_finalize(stmt)
        
        return reciterList
    }
    func getReciter(Id: Int64) -> Reciter {
        var stmt: OpaquePointer?
        var reciterObject = Reciter()
        let queryString = "SELECT * FROM Reciter WHERE Id = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return reciterObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return reciterObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            reciterObject = Reciter(Id: sqlite3_column_int64(stmt, 0))
            
            reciterObject.UserLoginInfo = sqlite3_column_int64(stmt, 1)
            reciterObject.ReciterNamePLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            reciterObject.ReciterNameSLang = String(cString: sqlite3_column_text(stmt, 3)!) as String
            reciterObject.DescPLang = String(cString: sqlite3_column_text(stmt, 4)!) as String
            reciterObject.DescSLang = String(cString: sqlite3_column_text(stmt, 5)!) as String
            reciterObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            reciterObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            reciterObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return reciterObject
    }
}
