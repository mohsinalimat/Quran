import Foundation

class Bookmark {
    var Id: Int64
    var FromSurahId: Int64
    var FromAyatId: Int64
    var ToSurahId: Int64
    var ToAyatId: Int64
    var CreatedDate: Date
    
    init() {
        self.Id = 0
        self.FromSurahId = 0
        self.FromAyatId = 0
        self.ToSurahId = 0
        self.ToAyatId = 0
        self.CreatedDate = Date()
    }
}
