import Foundation
import SQLite3

class CauseOfRevelationBookDetailRepository : BaseRepository {
    func getCauseOfRevelationBookDetailList(causeOfRevelationBookId: Int64) -> [CauseOfRevelationBookDetail] {
        var stmt: OpaquePointer?
        var causeOfRevelationBookDetailList = [CauseOfRevelationBookDetail]()
        let queryString = "SELECT * FROM CauseOfRevelationBookDetail WHERE CauseOfRevelationBookId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, causeOfRevelationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding CauseOfRevelationBookId: \(errmsg)")
            return causeOfRevelationBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let causeOfRevelationBookDetailObject = CauseOfRevelationBookDetail()
            
            causeOfRevelationBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            causeOfRevelationBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            causeOfRevelationBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            causeOfRevelationBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            causeOfRevelationBookDetailObject.AyatCauseOfRevelation = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookDetailObject.CauseOfRevelationBookId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            causeOfRevelationBookDetailList.append(causeOfRevelationBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookDetailList
    }
    func getCauseOfRevelationBookDetailList(causeOfRevelationBookId: Int64, surahId: Int64) -> [CauseOfRevelationBookDetail] {
        var stmt: OpaquePointer?
        var causeOfRevelationBookDetailList = [CauseOfRevelationBookDetail]()
        let queryString = "SELECT * FROM CauseOfRevelationBookDetail WHERE CauseOfRevelationBookId = ? AND SurahId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, causeOfRevelationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding CauseOfRevelationBookId: \(errmsg)")
            return causeOfRevelationBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return causeOfRevelationBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let causeOfRevelationBookDetailObject = CauseOfRevelationBookDetail()
            
            causeOfRevelationBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            causeOfRevelationBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            causeOfRevelationBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            causeOfRevelationBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            causeOfRevelationBookDetailObject.AyatCauseOfRevelation = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookDetailObject.CauseOfRevelationBookId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            
            causeOfRevelationBookDetailList.append(causeOfRevelationBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookDetailList
    }
    func deleteCauseOfRevelationBookDetail(causeOfRevelationBookId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM CauseOfRevelationBookDetail WHERE CauseOfRevelationBookId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, causeOfRevelationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding CauseOfRevelationBookId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting CauseOfRevelationBookDetail: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveCauseOfRevelationBookDetail(asbabNazoolList: [AsbabNazool], bookId: Int64) -> Bool {
        let status = deleteCauseOfRevelationBookDetail(causeOfRevelationBookId: bookId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO CauseOfRevelationBookDetail (Id, SurahId, AyatOrder, AyatId, AyatCauseOfRevelation, CauseOfRevelationBookId) VALUES (?,?,?,?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            var i: Int64 = 3
            
            for asbabNazoolObject in asbabNazoolList {
                sqlite3_bind_int64(stmt, 1, asbabNazoolObject.Id)
                sqlite3_bind_int64(stmt, 2, asbabNazoolObject.CatSurahId)
                sqlite3_bind_int64(stmt, 3, i)
                sqlite3_bind_int64(stmt, 4, asbabNazoolObject.CatAyatId)
                sqlite3_bind_text(stmt, 5, asbabNazoolObject.AsbabNozoulText, -1, nil)
                sqlite3_bind_int64(stmt, 6, bookId)
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(database)!)
                    print("failure inserting CauseOfRevelationBookDetail: \(errmsg)")
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
    func getCauseOfRevelationBookDetail(causeOfRevelationBookId: Int64, surahId: Int64, ayatId: Int64) -> CauseOfRevelationBookDetail {
        var stmt: OpaquePointer?
        let causeOfRevelationBookDetailObject = CauseOfRevelationBookDetail()
        let queryString = "SELECT * FROM CauseOfRevelationBookDetail WHERE CauseOfRevelationBookId = ? AND SurahId = ? AND AyatId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return causeOfRevelationBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 1, causeOfRevelationBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding CauseOfRevelationBookId: \(errmsg)")
            return causeOfRevelationBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return causeOfRevelationBookDetailObject
        }
        
        if sqlite3_bind_int64(stmt, 3, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return causeOfRevelationBookDetailObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            causeOfRevelationBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            causeOfRevelationBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            causeOfRevelationBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            causeOfRevelationBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            causeOfRevelationBookDetailObject.AyatCauseOfRevelation = String(cString: sqlite3_column_text(stmt, 4)!) as String
            causeOfRevelationBookDetailObject.CauseOfRevelationBookId = sqlite3_column_int64(stmt, 5)
            causeOfRevelationBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 6) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return causeOfRevelationBookDetailObject
    }
}

