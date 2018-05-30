import Foundation
import SQLite3

class TranslationBookDetailRepository : BaseRepository {
    func getTranslationBookDetailList(translationBookId: Int64) -> [TranslationBookDetail] {
        var stmt: OpaquePointer?
        var translationBookDetailList = [TranslationBookDetail]()
        let queryString = "SELECT * FROM TranslationBookDetail WHERE TranslationBookId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, translationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TranslationBookId: \(errmsg)")
            return translationBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let translationBookDetailObject = TranslationBookDetail()
            
            translationBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            translationBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            translationBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            translationBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            translationBookDetailObject.AyatTranslation = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookDetailObject.TranslationBookId = sqlite3_column_int64(stmt, 5)
            translationBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            translationBookDetailList.append(translationBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookDetailList
    }
    func getTranslationBookDetailList(translationBookId: Int64, surahId: Int64) -> [TranslationBookDetail] {
        var stmt: OpaquePointer?
        var translationBookDetailList = [TranslationBookDetail]()
        let queryString = "SELECT * FROM TranslationBookDetail WHERE TranslationBookId = ? AND SurahId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, translationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TranslationBookId: \(errmsg)")
            return translationBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return translationBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let translationBookDetailObject = TranslationBookDetail()
            
            translationBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            translationBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            translationBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            translationBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            translationBookDetailObject.AyatTranslation = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookDetailObject.TranslationBookId = sqlite3_column_int64(stmt, 5)
            translationBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            translationBookDetailList.append(translationBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookDetailList
    }
    func deleteTranslationBookDetail(translationBookId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM TranslationBookDetail WHERE TranslationBookId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, translationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TranslationBookId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting TranslationBookDetail: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func deleteTranslationBookDetail(translationBookId: Int64, surahId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM TranslationBookDetail WHERE TranslationBookId = ? AND SurahId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, translationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TranslationBookId: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting TranslationBookDetail: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveTranslationBookDetail(quranTextList: [QuranText], surahId: Int64, bookId: Int64) -> Bool {
        let status = deleteTranslationBookDetail(translationBookId: bookId, surahId: surahId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO TranslationBookDetail (Id, SurahId, AyatOrder, AyatId, AyatTranslation, TranslationBookId) VALUES (?,?,?,?,?,?)"

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
                    print("failure inserting TranslationBookDetail: \(errmsg)")
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
    func getTranslationBookDetail(translationBookId: Int64, surahId: Int64, ayatId: Int64) -> TranslationBookDetail {
        var stmt: OpaquePointer?
        let translationBookDetailObject = TranslationBookDetail()
        let queryString = "SELECT * FROM TranslationBookDetail WHERE TranslationBookId = ? AND SurahId = ? AND AyatId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return translationBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 1, translationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding TranslationBookId: \(errmsg)")
            return translationBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return translationBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 3, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return translationBookDetailObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            translationBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            translationBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            translationBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            translationBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            translationBookDetailObject.AyatTranslation = String(cString: sqlite3_column_text(stmt, 4)!) as String
            translationBookDetailObject.TranslationBookId = sqlite3_column_int64(stmt, 5)
            translationBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return translationBookDetailObject
    }
}
