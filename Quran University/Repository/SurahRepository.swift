import Foundation
import SQLite3

class SurahRepository : BaseRepository {
    func getSurahList() -> [Surah] {
        var stmt: OpaquePointer?
        var surahList = [Surah]()
        let queryString = "SELECT SurahId, SurahName FROM Ayat GROUP BY SurahId"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return surahList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let surahObject = Surah(
                surahId: sqlite3_column_int64(stmt, 0),
                surahName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
            
            surahList.append(surahObject)
        }
        
        sqlite3_finalize(stmt)
        
        return surahList
    }
    func getFirstSurah(pageId: Int64) -> Surah {
        var stmt: OpaquePointer?
        var surahObject = Surah()
        let queryString = "SELECT SurahId, SurahName FROM Ayat WHERE StartingPageNo = ? ORDER BY SurahId LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return surahObject
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return surahObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            surahObject = Surah(
                surahId: sqlite3_column_int64(stmt, 0),
                surahName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
        }
        
        sqlite3_finalize(stmt)
        
        return surahObject
    }
    func getLastSurah(pageId: Int64) -> Surah {
        var stmt: OpaquePointer?
        var surahObject = Surah()
        let queryString = "SELECT SurahId, SurahName FROM Ayat WHERE StartingPageNo = ? ORDER BY SurahId DESC LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return surahObject
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return surahObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            surahObject = Surah(
                surahId: sqlite3_column_int64(stmt, 0),
                surahName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
        }
        
        sqlite3_finalize(stmt)
        
        return surahObject
    }
    func getSurah(Id: Int64) -> Surah {
        var stmt: OpaquePointer?
        var surahObject = Surah()
        let queryString = "SELECT SurahId, SurahName FROM Ayat WHERE SurahId = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return surahObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return surahObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            surahObject = Surah(
                surahId: sqlite3_column_int64(stmt, 0),
                surahName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
        }
        
        sqlite3_finalize(stmt)
        
        return surahObject
    }
    func getSurahList(fromSurahId: Int64, toSurahId: Int64) -> [Surah] {
        var stmt: OpaquePointer?
        var surahList = [Surah]()
        let queryString = "SELECT SurahId, SurahName FROM Ayat WHERE SurahId >= ? AND SurahId <= ? GROUP BY SurahId"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return surahList
        }
        
        if sqlite3_bind_int64(stmt, 1, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return surahList
        }
        
        if sqlite3_bind_int64(stmt, 2, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return surahList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let surahObject = Surah(
                surahId: sqlite3_column_int64(stmt, 0),
                surahName: String(cString: sqlite3_column_text(stmt, 1)!) as String)
            
            surahList.append(surahObject)
        }
        
        sqlite3_finalize(stmt)
        
        return surahList
    }
}
