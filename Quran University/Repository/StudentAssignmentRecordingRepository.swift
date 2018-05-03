import Foundation
import SQLite3

class StudentAssignmentRecordingRepository : BaseRepository {
    func getStudentAssignmentRecordingList() -> [StudentAssignmentRecording] {
        var stmt: OpaquePointer?
        var studentAssignmentRecordingList = [StudentAssignmentRecording]()
        let queryString = "SELECT * FROM StudentAssignmentRecording WHERE IsActive = 1 AND IsDeleted = 0"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return studentAssignmentRecordingList
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let studentAssignmentRecordingObject = StudentAssignmentRecording(Id: sqlite3_column_int64(stmt, 0))
            
//            studentAssignmentRecordingObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
//            studentAssignmentRecordingObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
//            studentAssignmentRecordingObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
            
            studentAssignmentRecordingList.append(studentAssignmentRecordingObject)
        }
        
        sqlite3_finalize(stmt)
        
        return studentAssignmentRecordingList
    }
    func getStudentAssignmentRecording(Id: Int64) -> StudentAssignmentRecording {
        var stmt: OpaquePointer?
        var studentAssignmentRecordingObject = StudentAssignmentRecording()
        let queryString = "SELECT * FROM StudentAssignmentRecording WHERE Id = ? AND IsActive = 1 AND IsDeleted = 0 LIMIT 1"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing select: \(errmsg)")
            return studentAssignmentRecordingObject
        }
        
        if sqlite3_bind_int64(stmt, 1, Id) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return studentAssignmentRecordingObject
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            studentAssignmentRecordingObject = StudentAssignmentRecording(Id: sqlite3_column_int64(stmt, 0))
            
            studentAssignmentRecordingObject.IsActive = sqlite3_column_int64(stmt, 6) == 1 ? true : false
            studentAssignmentRecordingObject.CreatedDate = dateFormatter.date(from: (String(cString: sqlite3_column_text(stmt, 7)!) as String))!
            studentAssignmentRecordingObject.IsDeleted = sqlite3_column_int64(stmt, 8) == 1 ? true : false
        }
        
        sqlite3_finalize(stmt)
        
        return studentAssignmentRecordingObject
    }
    func deleteStudentAssignmentRecording(assignmentId: Int64) -> Bool {
        var stmt: OpaquePointer?
        let queryString = "DELETE FROM StudentAssignmentRecording WHERE Id = ?"
        
        if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("error preparing delete: \(errmsg)")
            return false
        }
        
        if sqlite3_bind_int64(stmt, 1, assignmentId) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure binding Id: \(errmsg)")
            return false
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(database)!)
            print("failure deleting StudentAssignmentRecording: \(errmsg)")
            return false
        }
        
        sqlite3_finalize(stmt)
        
        return true
    }
    func saveStudentAssignmentRecording(studentAssignmentRecordingObject: StudentAssignmentRecording) -> Bool {
        let status = deleteStudentAssignmentRecording(assignmentId: studentAssignmentRecordingObject.Id)
        
        if status {
            var stmt: OpaquePointer?
            let queryString = "INSERT INTO StudentAssignmentRecording (Id) VALUES (?)"
            
            if sqlite3_prepare(database, queryString, -1, &stmt, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("error preparing insert: \(errmsg)")
                return false
            }
            
            sqlite3_bind_int64(stmt, 1, studentAssignmentRecordingObject.Id)
            
            if sqlite3_step(stmt) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(database)!)
                print("failure inserting TranslationBookDetail: \(errmsg)")
                return false
            }
            
            sqlite3_finalize(stmt)
            
            return true
        }
        else {
            return false
        }
    }
}
