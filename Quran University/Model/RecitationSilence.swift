import Foundation

class RecitationSilence : BaseModel {
    var TitlePLang: String
    var TitleSLang: String
    var SilenceInSecond: Double
    var IsActive: Bool
    var CreatedDate: Date
    var IsDeleted: Bool
    
    init() {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.SilenceInSecond = 0
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
        
        super.init(id: 0, name: "")
    }
    init(Id: Int64) {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.SilenceInSecond = 0
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
        
        super.init(id: Id, name: "")
    }
    
    override var Name: String {
        var name = ""
        
        switch ApplicationData.CurrentLanguageMode {
        case .English:
            name = self.TitlePLang
            
            break
        case .Arabic:
            name = self.TitleSLang
            
            break
        }
        
        return name
    }
}
