import Foundation
import UIKit

class AssignmentManager {
    static var assignmentList = [Assignment]()
    static var dataTask: URLSessionDataTask?
    
    static func populateStudentAssignment() {
//        dataTask = URLSession.shared.dataTask(with: QuranLink.Assignment) { (data, response, err) in
//            var downloadStatus = false
//            let response = response as? HTTPURLResponse
//
//            if err == nil && response?.statusCode == 200 {
//                do {
//                    //                            let jsonString = String(data: data!, encoding: .utf8)
//                    let response = try JSONDecoder().decode(JsonResponse.self, from: data!)
//                    var status = false
//
//                    switch ApplicationData.CurrentDownloadBookMode {
//                    case .WordMeaning:
//                        status = WordMeaningBookDetailRepository().saveWordMeaningBookDetail(maaniMafrudatList: response.MaaniMafrudatList!, bookId: self.bookId)
//
//                        break
//                    case .Tafseer:
//                        status = TafseerBookDetailRepository().saveTafseerBookDetail(quranTextList: response.QuranTextList!, surahId: surahId, bookId: self.bookId)
//
//                        break
//                    case .Translation:
//                        status = TranslationBookDetailRepository().saveTranslationBookDetail(quranTextList: response.QuranTextList!, surahId: surahId, bookId: self.bookId)
//
//                        break
//                    case .CauseOfRevelation:
//                        status = CauseOfRevelationBookDetailRepository().saveCauseOfRevelationBookDetail(asbabNazoolList: response.AsbabNazoolList!, bookId: self.bookId)
//
//                        break
//                    }
//
//                    if status {
//                        downloadStatus = true
//                    }
//                }
//                catch {
//                    print("Error: \(error).")
//                }
//            }
//        }
//
//        dataTask?.resume()
    }
}
