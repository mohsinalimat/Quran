import Foundation

class CauseOfRevelationBookDetail {
    var Id: Int64
    var SurahId: Int64
    var AyatOrder: Int64
    var AyatId: Int64
    var AyatCauseOfRevelation: String
    var CauseOfRevelationBookId: Int64
    var IsDeleted: Bool
    
    init() {
        self.Id = 0
        self.SurahId = 0
        self.AyatOrder = 0
        self.AyatId = 0
        self.AyatCauseOfRevelation = ""
        self.CauseOfRevelationBookId = 0
        self.IsDeleted = false
    }
}
