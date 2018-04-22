import Foundation

struct CorrectionModel: Decodable {
    var Id: Int64
    var DeadLineDate: String
    var StudentOnlineSubmissionDate: String?
    var DelayedDaysString: String
    
    init() {
        self.Id = 0
        self.DeadLineDate = ""
        self.DelayedDaysString = ""
    }
}
