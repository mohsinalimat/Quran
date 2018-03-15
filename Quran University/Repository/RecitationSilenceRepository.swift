import Foundation
import SQLite3

class RecitationSilenceRepository : BaseRepository {
    func getRecitationSilenceList() -> [RecitationSilence] {
        var stmt: OpaquePointer?
        var recitationSilenceList = [RecitationSilence]()
        let queryString = "SELECT * FROM RecitationSilence WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationSilenceList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationSilenceObject = RecitationSilence(Id: sqlite3_column_int64(stmt, 0))
            
            recitationSilenceObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            recitationSilenceObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            recitationSilenceObject.SilenceInSecond = sqlite3_column_double(stmt, 3)
            recitationSilenceObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            recitationSilenceObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 5)!) as String))!
            recitationSilenceObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            recitationSilenceList.append(recitationSilenceObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationSilenceList
    }
    func getFirstRecitationSilence() -> RecitationSilence {
        var stmt: OpaquePointer?
        var recitationSilenceObject = RecitationSilence()
        let queryString = "SELECT * FROM RecitationSilence WHERE IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationSilenceObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            recitationSilenceObject = RecitationSilence(Id: sqlite3_column_int64(stmt, 0))
            
            recitationSilenceObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            recitationSilenceObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            recitationSilenceObject.SilenceInSecond = sqlite3_column_double(stmt, 3)
            recitationSilenceObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            recitationSilenceObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 5)!) as String))!
            recitationSilenceObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return recitationSilenceObject
    }
    func getRecitationSilence(Id: Int64) -> RecitationSilence {
        var stmt: OpaquePointer?
        var recitationSilenceObject = RecitationSilence()
        let queryString = "SELECT * FROM RecitationSilence WHERE Id = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationSilenceObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationSilenceObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            recitationSilenceObject = RecitationSilence(Id: sqlite3_column_int64(stmt, 0))
            
            recitationSilenceObject.TitlePLang = String(cString: sqlite3_column_text(stmt, 1)!) as String
            recitationSilenceObject.TitleSLang = String(cString: sqlite3_column_text(stmt, 2)!) as String
            recitationSilenceObject.SilenceInSecond = sqlite3_column_double(stmt, 3)
            recitationSilenceObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            recitationSilenceObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 5)!) as String))!
            recitationSilenceObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return recitationSilenceObject
    }
}
