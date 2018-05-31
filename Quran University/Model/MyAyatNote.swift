import Foundation

class MyAyatNote {
    var Id: Int64
    var SurahId: Int64
    var AyatId: Int64
    var AyatNote: String
    var IsDeleted: Bool
    
    init() {
        self.Id = 0
        self.SurahId = 0
        self.AyatId = 0
        self.AyatNote = ""
        self.IsDeleted = false
    }
}
