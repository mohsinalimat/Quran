import Foundation
import SQLite3

class TafseerBookDetailRepository : BaseRepository {
    func getTafseerBookDetailList(tafseerBookId: Int64) -> [TafseerBookDetail] {
        var stmt: OpaquePointer?
        var tafseerBookDetailList = [TafseerBookDetail]()
        let queryString = "SELECT * FROM TafseerBookDetail WHERE TafseerBookId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, tafseerBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TafseerBookId: \(errmsg)")
            return tafseerBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let tafseerBookDetailObject = TafseerBookDetail()
            
            tafseerBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            tafseerBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            tafseerBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            tafseerBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            tafseerBookDetailObject.AyatTafseer = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookDetailObject.TafseerBookId = sqlite3_column_int64(stmt, 5)
            tafseerBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            tafseerBookDetailList.append(tafseerBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookDetailList
    }
    func getTafseerBookDetailList(tafseerBookId: Int64, surahId: Int64) -> [TafseerBookDetail] {
        var stmt: OpaquePointer?
        var tafseerBookDetailList = [TafseerBookDetail]()
        let queryString = "SELECT * FROM TafseerBookDetail WHERE TafseerBookId = ? AND SurahId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, tafseerBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TafseerBookId: \(errmsg)")
            return tafseerBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return tafseerBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let tafseerBookDetailObject = TafseerBookDetail()
            
            tafseerBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            tafseerBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            tafseerBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            tafseerBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            tafseerBookDetailObject.AyatTafseer = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookDetailObject.TafseerBookId = sqlite3_column_int64(stmt, 5)
            tafseerBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            tafseerBookDetailList.append(tafseerBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookDetailList
    }
    func deleteTafseerBookDetail(tafseerBookId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM TafseerBookDetail WHERE TafseerBookId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, tafseerBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TafseerBookId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting TafseerBookDetail: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func deleteTafseerBookDetail(tafseerBookId: Int64, surahId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM TafseerBookDetail WHERE TafseerBookId = ? AND SurahId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, tafseerBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TafseerBookId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting TafseerBookDetail: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveTafseerBookDetail(quranTextList: [QuranText], surahId: Int64, bookId: Int64) -> Bool {
        let status = deleteTafseerBookDetail(tafseerBookId: bookId, surahId: surahId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO TafseerBookDetail (Id, SurahId, AyatOrder, AyatId, AyatTafseer, TafseerBookId) VALUES (?,?,?,?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            var i: Int64 = 3
            
            for quranTextObject in quranTextList {
                sqlite3_bind_int64(stmt, 1, quranTextObject.Id)
                sqlite3_bind_int64(stmt, 2, surahId)
                sqlite3_bind_int64(stmt, 3, i)
                sqlite3_bind_int64(stmt, 4, quranTextObject.CatAyatId)
                sqlite3_bind_text(stmt, 5, quranTextObject.Text, -1, nil)
                sqlite3_bind_int64(stmt, 6, bookId)
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(database)!)
                    print("failure inserting TafseerBookDetail: \(errmsg)")
                    return false
                }
                
                sqlite3_reset(stmt)
                
                i = i + 1
            }
            
            sqlite3_finalize(stmt)
            
            return true
        }
        else {
            return false
        }
    }
    func getTafseerBookDetail(tafseerBookId: Int64, surahId: Int64, ayatId: Int64) -> TafseerBookDetail {
        var stmt: OpaquePointer?
        let tafseerBookDetailObject = TafseerBookDetail()
        let queryString = "SELECT * FROM TafseerBookDetail WHERE TafseerBookId = ? AND SurahId = ? AND AyatId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return tafseerBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 1, tafseerBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TafseerBookId: \(errmsg)")
            return tafseerBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return tafseerBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 3, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return tafseerBookDetailObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            tafseerBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            tafseerBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            tafseerBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            tafseerBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            tafseerBookDetailObject.AyatTafseer = String(cString: sqlite3_column_text(stmt, 4)!) as String
            tafseerBookDetailObject.TafseerBookId = sqlite3_column_int64(stmt, 5)
            tafseerBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return tafseerBookDetailObject
    }
}
