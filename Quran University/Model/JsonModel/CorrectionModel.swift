import Foundation

struct CorrectionModel: Decodable {
    var Id: Int64
    var DeadLineDate: String
    var StudentOnlineSubmissionDate: String?
    var DelayedDaysString: String
    var StudentAudioFile: String?
    var StaffCheckDate: String?
    
    var CorrectionDetail: [CorrectionDetailModel]
    
    init() {
        self.Id = 0
        self.DeadLineDate = ""
        self.DelayedDaysString = ""
        self.StudentAudioFile = ""
        
        self.CorrectionDetail = [CorrectionDetailModel]()
    }

    var Submission: String {
        var submission = self.StudentOnlineSubmissionDate == nil ? "" : self.StudentOnlineSubmissionDate
        
        submission = (submission == "" ? submission : Utilities.dtPrintDate.string(from: Utilities.dtJsonPrintDateTime.date(from: submission!)!))
        
        return submission!
    }
    var StaffCheck: String {
        var staffCheck = self.StaffCheckDate == nil ? "" : self.StaffCheckDate
        
        staffCheck = (staffCheck == "" ? staffCheck : Utilities.dtPrintDate.string(from: Utilities.dtJsonPrintDateTime.date(from: staffCheck!)!))
        
        return staffCheck!
    }
}
