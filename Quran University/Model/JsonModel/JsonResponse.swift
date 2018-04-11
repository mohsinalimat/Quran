import Foundation

struct JsonResponse: Decodable {
    var QuranTextList: [QuranText]?
    var AsbabNazoolList: [AsbabNazool]?
    var MaaniMafrudatList: [MaaniMafrudat]?
    var Course: [Course]?
}
