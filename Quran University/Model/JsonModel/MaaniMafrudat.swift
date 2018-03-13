import Foundation

struct MaaniMafrudat: Decodable {
    var Id: Int64
    var SurahId: Int64
    var AyatNo: Int64
    var CatAyatId: Int64
    var OrderinAyat: Int64
    var WordText: String
    var MeaningText: String
    var CatLanguageId: Int64
    var LanguagePTitle: String
    var LanguageSTitle: String
    var BookTitlePlang: String
    var BookTitleSLang: String
}

