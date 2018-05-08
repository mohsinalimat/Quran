import Foundation
import UIKit

class UploadAssignmentView: UIView {
    @IBOutlet weak var pvUploadFileProgressView: UIProgressView!
    
    typealias methodHandler1 = () -> Void
    
    var fileProgressFactor: Float = 0
    
    func uploadRecording(completionHandler: @escaping methodHandler1) {
        fileProgressFactor = (1 / 3)
        
        AssignmentManager.uploadAssignment(uiProgressView: pvUploadFileProgressView, progressFactor: fileProgressFactor, completionHandler: { uploadStatus in
            if uploadStatus {
                let jsonContent = """
                {
                    "ClassAssignmentStudentId": \(ApplicationData.CurrentAssignment.classAssignmentStudentId),
                    "StudentSubmissionDate": "2017-01-02T00:43:00",
                    "StudentOnlineSubmissionDate": "2017-01-02T00:43:00",
                    "StudentAudioFile": \(ApplicationMethods.getCurrentStudentAssignmentRecordingName()),
                    "Iscorrection": \(ApplicationData.CurrentAssignment.Correction.count > 0 ? 1 : 0)
                }
                """
                let dataTask = URLSession.shared.dataTask(with: QuranLink.SubmitAssignment(jsonContent: jsonContent)) { (data, response, err) in
                    let response = response as? HTTPURLResponse
                    
                    DispatchQueue.main.async {
                        self.pvUploadFileProgressView.progress = self.pvUploadFileProgressView.progress + self.fileProgressFactor
                    }
                    
                    if err == nil && response?.statusCode == 200 {
                        do {
//                            let jsonString = String(data: data!, encoding: .utf8)
                            let jResponse = try JSONDecoder().decode(JsonResponse.self, from: data!)
                            
                            if jResponse.Status == 2 {
                                
                            }
                            else {
                                
                            }
                        }
                        catch {
                            print("Error: \(error).")
                        }
                    }
                    
                    completionHandler()
                }
                
                dataTask.resume()
            }
            else {
                
            }
            
            completionHandler()
        })
    }
}
