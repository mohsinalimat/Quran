import Foundation
import SQLite3

class AppObjectLocationRepository : BaseRepository {
    func deleteAppObjectLocation(appObjectId: Int64, objectId: Int64, objectLocationId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM AppObjectLocation WHERE AppObjectId = ? AND ObjectId = ? AND ObjectLocationId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, appObjectId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AppObjectId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 2, objectId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ObjectId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 3, objectLocationId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ObjectLocationId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting AppObjectLocation: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveAppObjectLocation(appObjectLocationObject: AppObjectLocation) -> Bool {
        let status = deleteAppObjectLocation(appObjectId: appObjectLocationObject.AppObjectId, objectId: appObjectLocationObject.ObjectId, objectLocationId: appObjectLocationObject.ObjectLocationId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO AppObjectLocation (AppObjectId, ObjectId, ObjectLocationId, ObjectLocationText) VALUES (?,?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            sqlite3_bind_int64(stmt, 1, appObjectLocationObject.AppObjectId)
            sqlite3_bind_int64(stmt, 2, appObjectLocationObject.ObjectId)
            sqlite3_bind_int64(stmt, 3, appObjectLocationObject.ObjectLocationId)
            sqlite3_bind_text(stmt, 4, appObjectLocationObject.ObjectLocationText, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("failure inserting AppObjectLocation: \(errmsg)")
                return false
            }
            
            sqlite3_finalize(stmt)
            
            return true
        }
        else {
            return false
        }
    }
    func getAppObjectLocationList(appObjectId: Int64, objectId: Int64) -> [AppObjectLocation] {
        var stmt: OpaquePointer?
        var appObjectLocationList = [AppObjectLocation]()
        let queryString = "SELECT * FROM AppObjectLocation WHERE AppObjectId = ? AND ObjectId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return appObjectLocationList
        }
        
        if sqlite3_bind_int64(stmt, 1, appObjectId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AppObjectId: \(errmsg)")
            return appObjectLocationList
        }
        
        if sqlite3_bind_int64(stmt, 2, objectId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ObjectId: \(errmsg)")
            return appObjectLocationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let appObjectLocationObject = AppObjectLocation()
            
            appObjectLocationObject.AppObjectId = sqlite3_column_int64(stmt, 0)
            appObjectLocationObject.ObjectId = sqlite3_column_int64(stmt, 1)
            appObjectLocationObject.ObjectLocationId = sqlite3_column_int64(stmt, 2)
            appObjectLocationObject.ObjectLocationText = String(cString: sqlite3_column_text(stmt, 3)!) as String
            
            appObjectLocationList.append(appObjectLocationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return appObjectLocationList
    }
}
