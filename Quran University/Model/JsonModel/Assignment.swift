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
        
        return typeTitle
    }
}
