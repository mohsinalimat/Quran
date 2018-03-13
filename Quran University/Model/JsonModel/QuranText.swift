import Foundation

struct QuranText: Decodable {
    var Id: Int64
    var CatAyatId: Int64
    var Text: String
    var CatLanguageId: Int64
    var ScholarId: Int64
    var IsQuranText: Bool
    var IsTafseer: Bool
    var LanguageIsLTR: Bool
}
