import Foundation

struct EndPointModel: Decodable {
    var AyatId: Int64
    var EndRow: Int64
    var EndX: Int64
    var EndY: Int64
    
    init() {
        self.AyatId = 0
        self.EndRow = 0
        self.EndX = 0
        self.EndY = 0
    }
}
