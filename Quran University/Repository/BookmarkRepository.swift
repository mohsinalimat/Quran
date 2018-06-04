import Foundation
import SQLite3

class BookmarkRepository : BaseRepository {
    func deleteBookmark(Id: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM Bookmark WHERE Id = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting Bookmark: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func deleteBookmark(fromSurahId: Int64, fromAyatId: Int64, toSurahId: Int64, toAyatId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM Bookmark WHERE FromSurahId = ? AND FromAyatId = ? AND ToSurahId = ? AND ToAyatId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding FromSurahId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 2, fromAyatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding FromAyatId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 3, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ToSurahId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 4, toAyatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ToAyatId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting Bookmark: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveBookmark(bookmarkObject: Bookmark) -> Bool {
        let status = deleteBookmark(fromSurahId: bookmarkObject.FromSurahId, fromAyatId: bookmarkObject.FromAyatId, toSurahId: bookmarkObject.ToSurahId, toAyatId: bookmarkObject.ToAyatId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO Bookmark (FromSurahId, FromAyatId, ToSurahId, ToAyatId, CreatedDate) VALUES (?,?,?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            sqlite3_bind_int64(stmt, 1, bookmarkObject.FromSurahId)
            sqlite3_bind_int64(stmt, 2, bookmarkObject.FromAyatId)
            sqlite3_bind_int64(stmt, 3, bookmarkObject.ToSurahId)
            sqlite3_bind_int64(stmt, 4, bookmarkObject.ToAyatId)
            sqlite3_bind_text(stmt, 5, bookmarkObject.CreatedDate.toString(dateFormat: dateFormatter.dateFormat), -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("failure inserting Bookmark: \(errmsg)")
                return false
            }
            
            sqlite3_finalize(stmt)
            
            return true
        }
        else {
            return false
        }
    }
    func getBookmarkList() -> [Bookmark] {
        var stmt: OpaquePointer?
        var bookmarkList = [Bookmark]()
        let queryString = "SELECT * FROM Bookmark"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return bookmarkList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let bookmarkObject = Bookmark()
            
            bookmarkObject.Id = sqlite3_column_int64(stmt, 0)
            bookmarkObject.FromSurahId = sqlite3_column_int64(stmt, 1)
            bookmarkObject.FromAyatId = sqlite3_column_int64(stmt, 2)
            bookmarkObject.ToSurahId = sqlite3_column_int64(stmt, 3)
            bookmarkObject.ToAyatId = sqlite3_column_int64(stmt, 4)
            bookmarkObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 5)!) as String))!
            
            bookmarkList.append(bookmarkObject)
        }
        
        sqlite3_finalize(stmt)
        
        return bookmarkList
    }
    func getBookmark(Id: Int64) -> Bookmark {
        var stmt: OpaquePointer?
        let bookmarkObject = Bookmark()
        let queryString = "SELECT * FROM Bookmark WHERE Id = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return bookmarkObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return bookmarkObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            bookmarkObject.Id = sqlite3_column_int64(stmt, 0)
            bookmarkObject.FromSurahId = sqlite3_column_int64(stmt, 1)
            bookmarkObject.FromAyatId = sqlite3_column_int64(stmt, 2)
            bookmarkObject.ToSurahId = sqlite3_column_int64(stmt, 3)
            bookmarkObject.ToAyatId = sqlite3_column_int64(stmt, 4)
            bookmarkObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 5)!) as String))!
        }
        
        sqlite3_finalize(stmt)
        
        return bookmarkObject
    }
}
