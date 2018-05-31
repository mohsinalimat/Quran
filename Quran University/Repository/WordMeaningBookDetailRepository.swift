import Foundation
import SQLite3

class WordMeaningBookDetailRepository : BaseRepository {
    func getWordMeaningBookDetailList(wordMeaningBookId: Int64) -> [WordMeaningBookDetail] {
        var stmt: OpaquePointer?
        var wordMeaningBookDetailList = [WordMeaningBookDetail]()
        let queryString = "SELECT * FROM WordMeaningBookDetail WHERE WordMeaningBookId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, wordMeaningBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding WordMeaningBookId: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let wordMeaningBookDetailObject = WordMeaningBookDetail()
            
            wordMeaningBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            wordMeaningBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            wordMeaningBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            wordMeaningBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            wordMeaningBookDetailObject.AyatWord = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookDetailObject.AyatMeaning = String(cString: sqlite3_column_text(stmt, 5)!) as String
            wordMeaningBookDetailObject.WordMeaningBookId = sqlite3_column_int64(stmt, 6)
            wordMeaningBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 7) == 1 ? true : false
            
            wordMeaningBookDetailList.append(wordMeaningBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookDetailList
    }
    func getWordMeaningBookDetailList(wordMeaningBookId: Int64, surahId: Int64) -> [WordMeaningBookDetail] {
        var stmt: OpaquePointer?
        var wordMeaningBookDetailList = [WordMeaningBookDetail]()
        let queryString = "SELECT * FROM WordMeaningBookDetail WHERE WordMeaningBookId = ? AND SurahId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, wordMeaningBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding WordMeaningBookId: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let wordMeaningBookDetailObject = WordMeaningBookDetail()
            
            wordMeaningBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            wordMeaningBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            wordMeaningBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            wordMeaningBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            wordMeaningBookDetailObject.AyatWord = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookDetailObject.AyatMeaning = String(cString: sqlite3_column_text(stmt, 5)!) as String
            wordMeaningBookDetailObject.WordMeaningBookId = sqlite3_column_int64(stmt, 6)
            wordMeaningBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 7) == 1 ? true : false
            
            wordMeaningBookDetailList.append(wordMeaningBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookDetailList
    }
    func deleteWordMeaningBookDetail(wordMeaningBookId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM WordMeaningBookDetail WHERE WordMeaningBookId = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, wordMeaningBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding WordMeaningBookId: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting WordMeaningBookDetail: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveWordMeaningBookDetail(maaniMafrudatList: [MaaniMafrudat], bookId: Int64) -> Bool {
        let status = deleteWordMeaningBookDetail(wordMeaningBookId: bookId)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO WordMeaningBookDetail (Id, SurahId, AyatOrder, AyatId, AyatWord, AyatMeaning, WordMeaningBookId) VALUES (?,?,?,?,?,?,?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            var i: Int64 = 3
            
            for maaniMafrudatObject in maaniMafrudatList {
                sqlite3_bind_int64(stmt, 1, maaniMafrudatObject.Id)
                sqlite3_bind_int64(stmt, 2, maaniMafrudatObject.SurahId)
                sqlite3_bind_int64(stmt, 3, i)
                sqlite3_bind_int64(stmt, 4, maaniMafrudatObject.CatAyatId)
                sqlite3_bind_text(stmt, 5, maaniMafrudatObject.WordText, -1, nil)
                sqlite3_bind_text(stmt, 6, maaniMafrudatObject.MeaningText, -1, nil)
                sqlite3_bind_int64(stmt, 7, bookId)
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(database)!)
                    print("failure inserting WordMeaningBookDetail: \(errmsg)")
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
    func getWordMeaningBookDetailList(wordMeaningBookId: Int64, surahId: Int64, ayatId: Int64) -> [WordMeaningBookDetail] {
        var stmt: OpaquePointer?
        var wordMeaningBookDetailList = [WordMeaningBookDetail]()
        let queryString = "SELECT * FROM WordMeaningBookDetail WHERE WordMeaningBookId = ? AND SurahId = ? AND AyatId = ? AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 1, wordMeaningBookId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding WordMeaningBookId: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 2, surahId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding SurahId: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        if sqlite3_bind_int64(stmt, 3, ayatId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding AyatId: \(errmsg)")
            return wordMeaningBookDetailList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let wordMeaningBookDetailObject = WordMeaningBookDetail()
            
            wordMeaningBookDetailObject.Id = sqlite3_column_int64(stmt, 0)
            wordMeaningBookDetailObject.SurahId = sqlite3_column_int64(stmt, 1)
            wordMeaningBookDetailObject.AyatOrder = sqlite3_column_int64(stmt, 2)
            wordMeaningBookDetailObject.AyatId = sqlite3_column_int64(stmt, 3)
            wordMeaningBookDetailObject.AyatWord = String(cString: sqlite3_column_text(stmt, 4)!) as String
            wordMeaningBookDetailObject.AyatMeaning = String(cString: sqlite3_column_text(stmt, 5)!) as String
            wordMeaningBookDetailObject.WordMeaningBookId = sqlite3_column_int64(stmt, 6)
            wordMeaningBookDetailObject.IsDeleted = sqlite3_column_int64(stmt, 7) == 1 ? true : false
            
            wordMeaningBookDetailList.append(wordMeaningBookDetailObject)
        }
        
        sqlite3_finalize(stmt)
        
        return wordMeaningBookDetailList
    }
}
