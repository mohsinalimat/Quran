import Foundation

class StudentAssignmentRecording {
    var Id: Int64
    var IsActive: Bool
    var CreatedDate: Date
    var IsDeleted: Bool
    
    init() {
        self.Id = 0
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
    }
    init(Id: Int64) {
        self.Id = Id
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
    }
}
