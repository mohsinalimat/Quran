import Foundation

class Utilities {
    static let dtJsonDateTime = DateFormatter()
    static let dtJsonPrintDateTime = DateFormatter()
    static let dtPrintDateTime = DateFormatter()
    static let dtPrintDate = DateFormatter()
    
    static func Initialize() {
        Utilities.dtJsonDateTime.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        Utilities.dtJsonDateTime.timeZone = TimeZone(secondsFromGMT: 0)
        Utilities.dtJsonPrintDateTime.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        Utilities.dtJsonPrintDateTime.timeZone = TimeZone(abbreviation: "GMT+1")
        Utilities.dtPrintDateTime.dateFormat = "dd/MM/yyyy h:mm a"
        Utilities.dtPrintDate.dateFormat = "dd/MM/yyyy"
    }
}
