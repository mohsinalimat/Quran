import Foundation

class TranslationBookDetail {
    var Id: Int64
    var SurahId: Int64
    var AyatOrder: Int64
    var AyatId: Int64
    var AyatTranslation: String
    var TranslationBookId: Int64
    var IsDeleted: Bool
    
    init() {
        self.Id = 0
        self.SurahId = 0
        self.AyatOrder = 0
        self.AyatId = 0
        self.AyatTranslation = ""
        self.TranslationBookId = 0
        self.IsDeleted = false
    }
}
