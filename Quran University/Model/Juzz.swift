import Foundation

class Juzz: BaseModel {
    var ChapterId: Int64
    var ChapterName: String
    
    init() {
        self.ChapterId = 0
        self.ChapterName = ""
        
        super.init(id: 0, name: "")
    }
    init(chapterId: Int64, chapterName: String) {
        self.ChapterId = chapterId
        self.ChapterName = chapterName
        
        super.init(id: chapterId, name: chapterName)
    }
}
