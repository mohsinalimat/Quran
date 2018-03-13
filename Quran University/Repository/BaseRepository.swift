import Foundation
import SQLite3

class BaseRepository {
    var database: OpaquePointer?
    
    init() {
        let filePath = DocumentManager.checkFileInApplicationDirectory(targetFilePath: DirectoryStructure.Database + ApplicationConstant.DatabaseFile)
        
        if sqlite3_open(filePath, &database) != SQLITE_OK {
            print("error opening database")
        }
    }
}
