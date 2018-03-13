import Foundation

class WordMeaningBookDetail {
    var Id: Int64
    var SurahId: Int64
    var AyatOrder: Int64
    var AyatId: Int64
    var AyatWord: String
    var AyatMeaning: String
    var WordMeaningBookId: Int64
    var IsDeleted: Bool
    
    init() {
        self.Id = 0
        self.SurahId = 0
        self.AyatOrder = 0
        self.AyatId = 0
        self.AyatWord = ""
        self.AyatMeaning = ""
        self.WordMeaningBookId = 0
        self.IsDeleted = false
    }
}

