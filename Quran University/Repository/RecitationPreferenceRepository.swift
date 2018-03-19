import Foundation
import SQLite3

class RecitationPreferenceRepository : BaseRepository {
    func getRecitationPreferenceList() -> [RecitationPreference] {
        var stmt: OpaquePointer?
        var recitationPreferenceList = [RecitationPreference]()
        let queryString = "SELECT * FROM RecitationPreference WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationPreferenceList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationPreferenceObject = RecitationPreference()
            
            recitationPreferenceObject.Id = sqlite3_column_int64(stmt, 0)
            recitationPreferenceObject.RepeatFor = sqlite3_column_int64(stmt, 1)
            recitationPreferenceObject.SilenceInSecond = sqlite3_column_double(stmt, 2)
            recitationPreferenceObject.Number = sqlite3_column_int64(stmt, 3)
            recitationPreferenceObject.IsActive = sqlite3_column_int64(stmt, 4) == 1 ? true : false
            recitationPreferenceObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 5)!) as String))!
            recitationPreferenceObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            recitationPreferenceList.append(recitationPreferenceObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationPreferenceList
    }
    func deleteRecitationPreference() -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM RecitationPreference"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting RecitationPreference: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveRecitationPreference(recitationPreferenceList: [RecitationPreference]) -> Bool {
        let status = deleteRecitationPreference()
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO RecitationPreference (RepeatFor, SilenceInSecond, Number) VALUES (?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            for recitationPreferenceObject in recitationPreferenceList {
                sqlite3_bind_int64(stmt, 1, recitationPreferenceObject.RepeatFor)
                sqlite3_bind_double(stmt, 2, recitationPreferenceObject.SilenceInSecond)
                sqlite3_bind_int64(stmt, 3, recitationPreferenceObject.Number)
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(database)!)
                    print("failure inserting RecitationPreference: \(errmsg)")
                    return false
                }
                
                sqlite3_reset(stmt)
            }
            
            sqlite3_finalize(stmt)
            
            return true
        }
        else {
            return false
        }
    }
}
