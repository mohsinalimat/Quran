import Foundation

class AppObjectLocation {
    var AppObjectId: Int64
    var ObjectId: Int64
    var ObjectLocationId: Int64
    var ObjectLocationText: String
    
    init() {
        self.AppObjectId = 0
        self.ObjectId = 0
        self.ObjectLocationId = 0
        self.ObjectLocationText = ""
    }
}
