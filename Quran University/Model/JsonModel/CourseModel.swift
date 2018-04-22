import Foundation

struct CourseModel: Decodable {
    var TitlePLang: String
    var TitleSLang: String
    
    var Assignment: [AssignmentModel]?
    
    var Title: String {
        var title = ""
        
        switch ApplicationData.CurrentLanguageMode {
        case .English:
            title = self.TitlePLang
            
            break
        case .Arabic:
            title = self.TitleSLang
            
            break
        }
        
        return title
    }
}
