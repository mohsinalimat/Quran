import Foundation

class Recitation: BaseModel {
    var AyatId: Int64
    var AyatOrderId: Int64
    var SurahId: Int64
    var PageId: Int64
    
    init() {
        self.AyatId = 0
        self.AyatOrderId = 0
        self.SurahId = 0
        self.PageId = 0
        
        super.init(id: 0, name: "")
    }
    init(ayatId: Int64, ayatOrderId: Int64, surahId: Int64, pageId: Int64) {
        self.AyatId = ayatId
        self.AyatOrderId = ayatOrderId
        self.SurahId = surahId
        self.PageId = pageId
        
        super.init(id: ayatOrderId, name: String(ayatOrderId))
    }
    
    var RecitationFileName: String {
        return ApplicationMethods.getRecitationName(surahId: SurahId, ayatOrderId: AyatOrderId)
    }
}
