import Foundation

class RecitationPreference {
    var Id: Int64
    var RepeatFor: Int64
    var SilenceInSecond: Double
    var Number: Int64
    var IsActive: Bool
    var CreatedDate: Date
    var IsDeleted: Bool
    
    init() {
        self.Id = 0
        self.RepeatFor = 0
        self.SilenceInSecond = 0
        self.Number = 0
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
    }
}
