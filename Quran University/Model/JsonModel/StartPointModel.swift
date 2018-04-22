import Foundation

struct StartPointModel: Decodable {
    var AyatId: Int64
    var StartRow: Int64
    var StartX: Int64
    var StartY: Int64
    
    init() {
        self.AyatId = 0
        self.StartRow = 0
        self.StartX = 0
        self.StartY = 0
    }
}
