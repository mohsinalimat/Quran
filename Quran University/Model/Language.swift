import Foundation

class Language: BaseModel {
    var TitlePLang: String
    var TitleSLang: String
    var OrderNo: Int64
    var IsActive: Bool
    var IsDeleted: Bool
    var CreatedDate: Date
    var IsLanguageLTR: Bool
    var LanguageIcon: String
    
    init() {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.OrderNo = 0
        self.IsActive = false
        self.IsDeleted = false
        self.CreatedDate = Date()
        self.IsLanguageLTR = false
        self.LanguageIcon = ""
        
        super.init(id: 0, name: "")
    }
    init(Id: Int64) {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.OrderNo = 0
        self.IsActive = false
        self.IsDeleted = false
        self.CreatedDate = Date()
        self.IsLanguageLTR = false
        self.LanguageIcon = ""
        
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
