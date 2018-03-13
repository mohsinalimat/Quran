import Foundation
import SQLite3

class JuzzRepository : BaseRepository {
    func getJuzzList() -> [Juzz] {
        var stmt: OpaquePointer?
        var juzzList = [Juzz]()
        let queryString = "SELECT ChapterId, ChapterName FROM Ayat GROUP BY ChapterId"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return juzzList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let juzzObject = Juzz(
                chapterId: sqlite3_column_int64(stmt, 0),
                chapterName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
            
            juzzList.append(juzzObject)
        }
        
        sqlite3_finalize(stmt)
        
        return juzzList
    }
    func getFirstJuzz(pageId: Int64) -> Juzz {
        var stmt: OpaquePointer?
        var juzzObject = Juzz()
        let queryString = "SELECT ChapterId, ChapterName FROM Ayat WHERE StartingPageNo = ? ORDER BY ChapterId LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return juzzObject
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return juzzObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            juzzObject = Juzz(
                chapterId: sqlite3_column_int64(stmt, 0),
                chapterName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
        }
        
        sqlite3_finalize(stmt)
        
        return juzzObject
    }
    func getLastJuzz(pageId: Int64) -> Juzz {
        var stmt: OpaquePointer?
        var juzzObject = Juzz()
        let queryString = "SELECT ChapterId, ChapterName FROM Ayat WHERE StartingPageNo = ? ORDER BY ChapterId DESC LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return juzzObject
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return juzzObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            juzzObject = Juzz(
                chapterId: sqlite3_column_int64(stmt, 0),
                chapterName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
        }
        
        sqlite3_finalize(stmt)
        
        return juzzObject
    }
    func getJuzz(Id: Int64) -> Juzz {
        var stmt: OpaquePointer?
        var juzzObject = Juzz()
        let queryString = "SELECT ChapterId, ChapterName FROM Ayat WHERE ChapterId = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return juzzObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ChapterId: \(errmsg)")
            return juzzObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            juzzObject = Juzz(
                chapterId: sqlite3_column_int64(stmt, 0),
                chapterName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
        }
        
        sqlite3_finalize(stmt)
        
        return juzzObject
    }
}
