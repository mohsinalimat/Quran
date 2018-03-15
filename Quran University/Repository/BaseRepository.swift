import Foundation
import SQLite3

class BaseRepository {
    var database: OpaquePointer?
    let dateFormatter = DateFormatter()
    
    init() {
        let filePath = DocumentManager.checkFileInApplicationDirectory(targetFilePath: DirectoryStructure.Database + ApplicationConstant.DatabaseFile)
        
        if sqlite3_open(filePath, &database) != SQLITE_OK {
            print("error opening database")
        }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
    }
}
