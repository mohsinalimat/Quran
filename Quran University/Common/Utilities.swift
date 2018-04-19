import Foundation

class Utilities {
    static let dtJsonDateTime = DateFormatter()
    static let dtPrintDateTime = DateFormatter()
    static let dtPrintDate = DateFormatter()
    
    static func Initialize() {
        Utilities.dtJsonDateTime.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        Utilities.dtJsonDateTime.timeZone = TimeZone(abbreviation: "GMT+1")
        Utilities.dtPrintDateTime.dateFormat = "dd/MM/yyyy HH:mm:ss"
        Utilities.dtPrintDate.dateFormat = "dd/MM/yyyy"
    }
}
