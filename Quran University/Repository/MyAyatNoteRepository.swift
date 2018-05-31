import Foundation
import SQLite3

class MyAyatNoteRepository : BaseRepository {
    func deleteMyAyatNote(surahId: Int64, ayatId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM MyAyatNote WHERE SurahId = ? AND AyatId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 2, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting MyAyatNote: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveMyAyatNote(myAyatNoteObject: MyAyatNote) -> Bool {
        let status = deleteMyAyatNote(surahId: myAyatNoteObject.SurahId, ayatId: myAyatNoteObject.AyatId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO MyAyatNote (SurahId, AyatId, AyatNote) VALUES (?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            sqlite3_bind_int64(stmt, 1, myAyatNoteObject.SurahId)
            sqlite3_bind_int64(stmt, 2, myAyatNoteObject.AyatId)
            sqlite3_bind_text(stmt, 3, myAyatNoteObject.AyatNote, -1, nil)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("failure inserting MyAyatNote: \(errmsg)")
                return false
            }
            
            sqlite3_finalize(stmt)
            
            return true
        }
        else {
            return false
        }
    }
    func getMyAyatNote(surahId: Int64, ayatId: Int64) -> MyAyatNote {
        var stmt: OpaquePointer?
        let myAyatNoteObject = MyAyatNote()
        let queryString = "SELECT * FROM MyAyatNote WHERE SurahId = ? AND AyatId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return myAyatNoteObject
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return myAyatNoteObject
        }
        
        if sqlite3_bind_int64(stmt, 2, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return myAyatNoteObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            myAyatNoteObject.Id = sqlite3_column_int64(stmt, 0)
            myAyatNoteObject.SurahId = sqlite3_column_int64(stmt, 1)
            myAyatNoteObject.AyatId = sqlite3_column_int64(stmt, 2)
            myAyatNoteObject.AyatNote = String(cString: sqlite3_column_text(stmt, 3)!) as String
            myAyatNoteObject.IsDeleted = sqlite3_column_int64(stmt, 4) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return myAyatNoteObject
    }
}
