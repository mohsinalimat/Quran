import Foundation

class Page: BaseModel {
    var PageId: Int64
    var PageName: String
    
    init() {
        self.PageId = 0
        self.PageName = ""
        
        super.init(id: 0, name: "")
    }
    
    init(pageId: Int64) {
        self.PageId = pageId
        self.PageName = String(pageId)
        
        super.init(id: pageId, name: self.PageName)
    }
}
