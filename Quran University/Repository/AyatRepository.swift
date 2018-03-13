import Foundation
import SQLite3

class AyatRepository : BaseRepository {
    func getAyatList(pageId: Int64) -> [Ayat] {
        var stmt: OpaquePointer?
        var ayatList = [Ayat]()
        let queryString = "SELECT * FROM Ayat WHERE StartingPageNo = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return ayatList
        }
        
        if sqlite3_bind_int64(stmt, 1, pageId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding StartingPageNo: \(errmsg)")
            return ayatList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let ayatObject = Ayat()
            
            ayatObject.ChapterNo = sqlite3_column_int64(stmt, 0)
            ayatObject.ChapterId = sqlite3_column_int64(stmt, 1)
            ayatObject.ChapterName = String(cString: sqlite3_column_text(stmt, 2)!) as String
            ayatObject.SurahNo = sqlite3_column_int64(stmt, 3)
            ayatObject.SurahName = String(cString: sqlite3_column_text(stmt, 4)!) as String
            ayatObject.SurahId = sqlite3_column_int64(stmt, 5)
            ayatObject.SurahStartingPageNo = sqlite3_column_int64(stmt, 6)
            ayatObject.SurahEndingPageNo = sqlite3_column_int64(stmt, 7)
            ayatObject.AyatId = sqlite3_column_int64(stmt, 8)
            ayatObject.AyatOrder = sqlite3_column_int64(stmt, 9)
            ayatObject.AyatText = String(cString: sqlite3_column_text(stmt, 10)!) as String
            ayatObject.StartingPointX = sqlite3_column_double(stmt, 11)
            ayatObject.EndingPointX = sqlite3_column_double(stmt, 12)
            ayatObject.StartingPointY = sqlite3_column_double(stmt, 13)
            ayatObject.EndingPointY = sqlite3_column_double(stmt, 14)
            ayatObject.StartingPageNo = sqlite3_column_int64(stmt, 15)
            ayatObject.EndingPageNo = sqlite3_column_int64(stmt, 16)
            ayatObject.StartingRowNo = sqlite3_column_int64(stmt, 17)
            ayatObject.EndingRowNo = sqlite3_column_int64(stmt, 18)
            ayatObject.StartingRowHeight = sqlite3_column_double(stmt, 19)
            ayatObject.EndingRowHeight = sqlite3_column_double(stmt, 20)
            
            ayatList.append(ayatObject)
        }
        
        sqlite3_finalize(stmt)
        
        return ayatList
    }
}
