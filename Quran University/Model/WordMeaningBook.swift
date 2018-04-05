import Foundation

class WordMeaningBook: BaseModel {
    var TitlePLang: String
    var TitleSLang: String
    var ScholarPLang: String
    var ScholarSLang: String
    var LanguageId: Int64
    var IsActive: Bool
    var CreatedDate: Date
    var IsDeleted: Bool
    
    init() {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.ScholarPLang = ""
        self.ScholarSLang = ""
        self.LanguageId = 0
        self.IsActive = false
        self.CreatedDate = Date()
        self.IsDeleted = false
        
        super.init(id: 0, name: "")
    }
    init(Id: Int64) {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.ScholarPLang = ""
        self.ScholarSLang = ""
        self.LanguageId = 0
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
    
    var ScholarName: String {
        var scholarName = ""
        
        switch ApplicationData.CurrentLanguageMode {
        case .English:
            scholarName = self.ScholarPLang
            
            break
        case .Arabic:
            scholarName = self.ScholarSLang
            
            break
        }
        
        return scholarName
    }
}

