import Foundation
import SQLite3

class RecitationRepository : BaseRepository {
    func getRecitationList() -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getRecitationList(surahId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE SurahId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getRecitationList(juzzId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE ChapterId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, juzzId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ChapterId: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getRecitationList(fromPageId: Int64, toPageId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE StartingPageNo >= ? AND EndingPageNo <= ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, fromPageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 2, toPageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding EndingPageNo: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getFirstRecitation(surahId: Int64) -> Recitation {
        var stmt: OpaquePointer?
        var recitationObject = Recitation()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE SurahId = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationObject
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
        }
        
        sqlite3_finalize(stmt)
        
        return recitationObject
    }
    func getRecitation(surahId: Int64, ayatOrder: Int64) -> Recitation {
        var stmt: OpaquePointer?
        var recitationObject = Recitation()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE SurahId = ? AND AyatOrder = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationObject
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationObject
        }
        
        if sqlite3_bind_int64(stmt, 2, ayatOrder) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return recitationObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
        }
        
        sqlite3_finalize(stmt)
        
        return recitationObject
    }
    func getRecitationList(pageId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE StartingPageNo = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getRecitationList(fromSurahId: Int64, toSurahId: Int64, fromAyatOrderId: Int64, toAyatOrderId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE ((SurahId = ? AND AyatOrder >= ?) OR SurahId > ?) AND ((SurahId = ? AND AyatOrder <= ?) OR SurahId < ?)"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 2, fromAyatOrderId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 3, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 4, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 5, toAyatOrderId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 6, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getRecitationList(pageId: Int64, fromSurahId: Int64, fromAyatOrderId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE StartingPageNo = ? AND ((SurahId = ? AND AyatOrder >= ?) OR SurahId > ?)"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 2, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 3, fromAyatOrderId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 4, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
    func getRecitationList(pageId: Int64, toSurahId: Int64, toAyatOrderId: Int64) -> [Recitation] {
        var stmt: OpaquePointer?
        var recitationList = [Recitation]()
        let queryString = "SELECT AyatId, AyatOrder, SurahId, StartingPageNo FROM Ayat WHERE StartingPageNo = ? AND ((SurahId = ? AND AyatOrder <= ?) OR SurahId < ?)"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 2, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 3, toAyatOrderId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return recitationList
        }
        
        if sqlite3_bind_int64(stmt, 4, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return recitationList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let recitationObject = Recitation(
                ayatId: sqlite3_column_int64(stmt, 0),
                ayatOrderId: sqlite3_column_int64(stmt, 1),
                surahId: sqlite3_column_int64(stmt, 2),
                pageId: sqlite3_column_int64(stmt, 3))
            
            recitationList.append(recitationObject)
        }
        
        sqlite3_finalize(stmt)
        
        return recitationList
    }
}
