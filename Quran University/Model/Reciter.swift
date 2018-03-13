import Foundation

class Reciter: BaseModel {
    var UserLoginInfo: Int64
    var ReciterNamePLang: String
    var ReciterNameSLang: String
    var DescPLang: String
    var DescSLang: String
    var IsActive: Bool
    var CreatedDate: Date
    var IsDeleted: Bool
    
    init() {
        self.UserLoginInfo = 0
        self.ReciterNamePLang = ""
        self.ReciterNameSLang = ""
        self.DescPLang = ""
        self.DescSLang = ""
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
        
        super.init(id: 0, name: "")
    }
    
    init(Id: Int64) {
        self.UserLoginInfo = 0
        self.ReciterNamePLang = ""
        self.ReciterNameSLang = ""
        self.DescPLang = ""
        self.DescSLang = ""
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
        
        super.init(id: Id, name: "")
    }
    
    override var Name: String {
        var name = ""
        
        switch ApplicationData.CurrentLanguageMode {
        case .English:
            name = self.ReciterNamePLang

            break
        case .Arabic:
            name = self.ReciterNameSLang
            
            break
        }
        
        return name
    }
}
