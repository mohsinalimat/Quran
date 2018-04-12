import Foundation

class Assignment: Decodable {
    var AssignmentType: String
    var AssignmentTypeSLang: String
    var DeadlineDate: String
    var DelayedDaysString: String
    var IsMarked: Bool
    var Marks: Int64
    var StudentOnlineSubmissionDate: String?
    var StudentSubmissionDate: String?
    var titlePLang: String
    var titleSLang: String
    
    var AssignmentCurrentStatusTitle: String?
    var AssignStatusId: Int64?
    var AssignmentStatusId: Int32?
    var DeadlineDateValue: Date?
    var CourseInfoId: Int64?
    var CourseTitle: String?
    
    var Correction: [Correction]
    
    var Title: String {
        var title = ""
        
        switch ApplicationData.CurrentLanguageMode {
        case .English:
            title = self.titlePLang
            
            break
        case .Arabic:
            title = self.titleSLang
            
            break
        }
        
        title = (title == "" ? "N/A" : title)
        
        return title
    }
    var TypeTitle: String {
        var typeTitle = ""
        
        switch ApplicationData.CurrentLanguageMode {
        case .English:
            typeTitle = self.AssignmentType
            
            break
        case .Arabic:
            typeTitle = self.AssignmentTypeSLang
            
            break
        }
        
        typeTitle = (typeTitle == "" ? "N/A" : typeTitle)
        
        return typeTitle
    }
    var Deadline: String {
        var deadline = self.DeadlineDate
        
        if self.Correction.count > 1 {
            deadline = self.Correction[1].DeadLineDate
        }
        
        deadline = Utilities.dtPrintDate.string(from: Utilities.dtJsonDateTime.date(from: deadline)!)
        
        return deadline
    }
    var Submission: String {
        var submission = self.StudentOnlineSubmissionDate == nil ? "" : self.StudentOnlineSubmissionDate
        
        if self.Correction.count > 1 {
            submission = self.Correction[1].StudentOnlineSubmissionDate == nil ? "" : self.Correction[1].StudentOnlineSubmissionDate
        }
        
        submission = (submission == "" ? submission : Utilities.dtPrintDate.string(from: Utilities.dtJsonDateTime.date(from: submission!)!))
        
        return submission!
    }
    var SubmissionTime: String {
        var submissionTime = self.StudentOnlineSubmissionDate == nil ? "" : self.StudentOnlineSubmissionDate
        
        if self.Correction.count > 1 {
            submissionTime = self.Correction[1].StudentOnlineSubmissionDate == nil ? "" : self.Correction[1].StudentOnlineSubmissionDate
        }
        
        submissionTime = (submissionTime == "" ? submissionTime : Utilities.dtPrintDateTime.string(from: Utilities.dtJsonDateTime.date(from: submissionTime!)!))
        
        return submissionTime!
    }
}
