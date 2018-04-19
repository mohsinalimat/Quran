import Foundation
import SQLite3

class PageRepository : BaseRepository {
    func getPageList() -> [Page] {
        var stmt: OpaquePointer?
        var pageList = [Page]()
        let queryString = "SELECT StartingPageNo FROM Ayat GROUP BY StartingPageNo"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
            
            pageList.append(pageObject)
        }
        
        sqlite3_finalize(stmt)
        
        return pageList
    }
    func getPageList(surahId: Int64) -> [Page] {
        var stmt: OpaquePointer?
        var pageList = [Page]()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE SurahId = ? GROUP BY StartingPageNo"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return pageList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
            
            pageList.append(pageObject)
        }
        
        sqlite3_finalize(stmt)
        
        return pageList
    }
    func getPageList(juzzId: Int64) -> [Page] {
        var stmt: OpaquePointer?
        var pageList = [Page]()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE ChapterId = ? GROUP BY StartingPageNo"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 1, juzzId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ChapterId: \(errmsg)")
            return pageList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
            
            pageList.append(pageObject)
        }
        
        sqlite3_finalize(stmt)
        
        return pageList
    }
    func getPageList(fromPageId: Int64, toPageId: Int64) -> [Page] {
        var stmt: OpaquePointer?
        var pageList = [Page]()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE StartingPageNo >= ? AND EndingPageNo <= ? GROUP BY StartingPageNo"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 1, fromPageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 2, toPageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding EndingPageNo: \(errmsg)")
            return pageList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
            
            pageList.append(pageObject)
        }
        
        sqlite3_finalize(stmt)
        
        return pageList
    }
    func getPage(Id: Int64) -> Page {
        var stmt: OpaquePointer?
        var pageObject = Page()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE StartingPageNo = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return pageObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
        }
        
        sqlite3_finalize(stmt)
        
        return pageObject
    }
    func getFirstPage(surahId: Int64) -> Page {
        var stmt: OpaquePointer?
        var pageObject = Page()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE SurahId = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return pageObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
        }
        
        sqlite3_finalize(stmt)
        
        return pageObject
    }
    func getFirstPage(juzzId: Int64) -> Page {
        var stmt: OpaquePointer?
        var pageObject = Page()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE ChapterId = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, juzzId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding ChapterId: \(errmsg)")
            return pageObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
        }
        
        sqlite3_finalize(stmt)
        
        return pageObject
    }
    func getFirstPage(ayatId: Int64) -> Page {
        var stmt: OpaquePointer?
        var pageObject = Page()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE AyatId = ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return pageObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
        }
        
        sqlite3_finalize(stmt)
        
        return pageObject
    }
    func getNextPage(Id: Int64) -> Page {
        var stmt: OpaquePointer?
        var pageObject = Page()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE StartingPageNo > ? LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return pageObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
        }
        
        sqlite3_finalize(stmt)
        
        return pageObject
    }
    func getPreviousPage(Id: Int64) -> Page {
        var stmt: OpaquePointer?
        var pageObject = Page()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE StartingPageNo < ? ORDER BY StartingPageNo DESC LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return pageObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
        }
        
        sqlite3_finalize(stmt)
        
        return pageObject
    }
    func getPageList(fromSurahId: Int64, toSurahId: Int64, startAyatOrderId: Int64, endAyatOrderId: Int64) -> [Page] {
        var stmt: OpaquePointer?
        var pageList = [Page]()
        let queryString = "SELECT StartingPageNo FROM Ayat WHERE SurahId BETWEEN ? AND ? AND AyatOrder BETWEEN ? AND ? GROUP BY StartingPageNo"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 1, fromSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 2, toSurahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 3, startAyatOrderId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return pageList
        }
        
        if sqlite3_bind_int64(stmt, 4, endAyatOrderId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatOrder: \(errmsg)")
            return pageList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let pageObject = Page(pageId: sqlite3_column_int64(stmt, 0))
            
            pageList.append(pageObject)
        }
        
        sqlite3_finalize(stmt)
        
        return pageList
    }
    func getPageGroupList() -> [Page] {
        var pageGroupList = [Page]()
        
        for index in 1...6 {
            let pageGroupObject = Page(pageId: Int64(index * 100))
            
            pageGroupList.append(pageGroupObject)
        }
        
        return pageGroupList
    }
    func getPageGroup(pageId: Int64) -> Page {
        let valueToFind = ((pageId / 100) <= 0 ? 1 : (pageId / 100)) * 100
        let pageGroupObject = Page(pageId: valueToFind)
        
        return pageGroupObject
    }
}
