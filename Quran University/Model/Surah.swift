import Foundation

class Surah: BaseModel {
    var SurahId: Int64
    var SurahName: String
    
    init() {
        self.SurahId = 0
        self.SurahName = ""
        
        super.init(id: 0, name: "")
    }
    init(surahId: Int64, surahName: String) {
        self.SurahId = surahId
        self.SurahName = surahName
        
        super.init(id: surahId, name: surahName)
    }
}
