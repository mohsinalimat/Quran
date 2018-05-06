import Foundation

class AssignmentModel: Decodable {
    var Id: Int64
    var StudentId: Int64
    var classAssignmentStudentId: Int64
    var AssignmentType: String
    var AssignmentTypeSLang: String
    var DeadlineDate: String
    var DelayedDaysString: String
    var IsMarked: Bool
    var Marks: Int64
    var StudentOnlineSubmissionDate: String?
    var StudentSubmissionDate: String?
    var StudentAudioFile: String?
    var titlePLang: String
    var titleSLang: String
    
    var AssignmentStatusTitle: String?
    var AssignmentStatusId: Int32?
    var CourseInfoId: Int64?
    var CourseTitle: String?
    var Number: String?
    var RecordingExists: Bool?
    
    var AssignmentBoundary: [AssignmentBoundaryModel]
    var Correction: [CorrectionModel]
    
    init() {
        self.Id = 0
        self.StudentId = 0
        self.classAssignmentStudentId = 0
        self.AssignmentType = ""
        self.AssignmentTypeSLang = ""
        self.DeadlineDate = ""
        self.DelayedDaysString = ""
        self.IsMarked = false
        self.Marks = 0
        self.titlePLang = ""
        self.titleSLang = ""
        
        self.AssignmentBoundary = [AssignmentBoundaryModel]()
        self.Correction = [CorrectionModel]()
    }
    
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
    var Deadline: Date {
        var deadline = self.DeadlineDate
        
        if self.Correction.count > 0 {
            deadline = self.Correction[0].DeadLineDate
        }
        
        return Utilities.dtJsonDateTime.date(from: deadline)!
    }
    var DeadlineString: String {
        let deadlineString = Utilities.dtPrintDate.string(from: Deadline)
        
        return deadlineString
    }
    var DelayedDays: String {
        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: Date()) else {
            return "0"
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: Deadline) else {
            return "0"
        }

        return String(start - end)
    }
    var Submission: String {
        var submission = self.StudentOnlineSubmissionDate == nil ? "" : self.StudentOnlineSubmissionDate
        
        if self.Correction.count > 0 {
            submission = self.Correction[0].StudentOnlineSubmissionDate == nil ? "" : self.Correction[0].StudentOnlineSubmissionDate
        }
        
        submission = (submission == "" ? submission : Utilities.dtPrintDate.string(from: Utilities.dtJsonPrintDateTime.date(from: submission!)!))
        
        return submission!
    }
    var SubmissionTime: String {
        var submissionTime = self.StudentOnlineSubmissionDate == nil ? "" : self.StudentOnlineSubmissionDate
        
        if self.Correction.count > 0 {
            submissionTime = self.Correction[0].StudentOnlineSubmissionDate == nil ? "" : self.Correction[0].StudentOnlineSubmissionDate
        }
        
        submissionTime = (submissionTime == "" ? submissionTime : Utilities.dtPrintDateTime.string(from: Utilities.dtJsonPrintDateTime.date(from: submissionTime!)!))
        
        return submissionTime!
    }
    var MarkString: String {
        let mark = self.IsMarked ? String(self.Marks) : "-"
        
        return mark
    }
}
