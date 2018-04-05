import Foundation
import UIKit

class AssignmentManager {
    typealias methodHandler1 = () -> Void
    
    static var assignmentList = [Assignment]()
    static var dataTask: URLSessionDataTask?
    
    static func populateStudentAssignment(completionHandler: @escaping methodHandler1) {
        dataTask = URLSession.shared.dataTask(with: QuranLink.Assignment()) { (data, response, err) in
            let response = response as? HTTPURLResponse

            if err == nil && response?.statusCode == 200 {
                do {
                    //                            let jsonString = String(data: data!, encoding: .utf8)
                    let response = try JSONDecoder().decode(JsonResponse.self, from: data!)
                }
                catch {
                    print("Error: \(error).")
                }
            }
            
            completionHandler()
        }

        dataTask?.resume()
    }
}
