import Foundation

struct Correction: Decodable {
    var Id: Int64
    var DeadLineDate: String
    var StudentOnlineSubmissionDate: String?
}
