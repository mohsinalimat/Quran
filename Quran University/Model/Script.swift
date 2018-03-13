import Foundation

class Script: BaseModel {
    var TitlePLang: String
    var TitleSLang: String
    var Description: String
    var Company: String
    var Author: String
    var NumberOfPages: Int64
    var NumberOfTextPages: Int64
    var NumberOfLinesOnPage: Int64
    var PageHeight: Int64
    var PageWidth: Int64
    var RowHeight: Int64
    var IsDeleted: Bool
    var CreatedDate: Date
    var Deactivate: Bool
    
    init() {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.Description = ""
        self.Company = ""
        self.Author = ""
        self.NumberOfPages = 0
        self.NumberOfTextPages = 0
        self.NumberOfLinesOnPage = 0
        self.PageHeight = 0
        self.PageWidth = 0
        self.RowHeight = 0
        self.IsDeleted = false
        self.CreatedDate = Date()
        self.Deactivate = false
        
        super.init(id: 0, name: "")
    }
    
    init(Id: Int64) {
        self.TitlePLang = ""
        self.TitleSLang = ""
        self.Description = ""
        self.Company = ""
        self.Author = ""
        self.NumberOfPages = 0
        self.NumberOfTextPages = 0
        self.NumberOfLinesOnPage = 0
        self.PageHeight = 0
        self.PageWidth = 0
        self.RowHeight = 0
        self.IsDeleted = false
        self.CreatedDate = Date()
        self.Deactivate = false
        
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
