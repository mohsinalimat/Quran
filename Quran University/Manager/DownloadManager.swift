import Foundation
import Alamofire

class DownloadManager {
    typealias methodHandler1 = (_ downloaded: Bool) -> Void
    
    static var pvOverallProgressView = UIProgressView()
    static var pvFileProgressView = UIProgressView()
    
    static func downloadCurrentQuranPage(uiOProgressView: UIProgressView, uiFProgressView: UIProgressView, scriptId: Int64, pageId: Int64, overallProgressFactor: Double, completionHandler: @escaping methodHandler1) {
        pvOverallProgressView = uiOProgressView
        pvFileProgressView = uiFProgressView
        pvFileProgressView.progress = 0
        
        let overallProgress = pvOverallProgressView.progress
        let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getPagePath(scriptId: scriptId, pageId: pageId))
        
        if fileURL == "" {
            Alamofire
                .request(ApplicationMethods.getPageURL(scriptId: scriptId, pageId: pageId))
                .downloadProgress(closure: { (progress) in
                    pvFileProgressView.progress = Float(progress.fractionCompleted)
                    pvOverallProgressView.progress = overallProgress + (pvFileProgressView.progress * Float(overallProgressFactor))
                })
                .validate()
                .responseData(completionHandler: { (response) in
                    var status = false
                    
                    if response.result.isSuccess {
                        if let data = response.result.value {
                            let createdFileURL = DocumentManager.createFileInApplicationDirectory(contents: data, targetFilePath: ApplicationMethods.getPagePath(scriptId: scriptId, pageId: pageId))
                            
                            if createdFileURL != "" {
                                status = true
                            }
                        }
                    }
                    
                    completionHandler(status)
                })
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.10, execute: {
                pvFileProgressView.progress = 1
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.10, execute: {
                    completionHandler(true)
                })
            })
        }
    }
    static func downloadCurrentAyatRecitation(uiOProgressView: UIProgressView, uiFProgressView: UIProgressView, reciterId: Int64, surahId: Int64, recitationName: String, overallProgressFactor: Double, completionHandler: @escaping methodHandler1) {
        pvOverallProgressView = uiOProgressView
        pvFileProgressView = uiFProgressView
        pvFileProgressView.progress = 0
        
        let overallProgress = pvOverallProgressView.progress
        let fileURL = DocumentManager.checkFileInApplicationDirectory(targetFilePath: ApplicationMethods.getRecitationPath(reciterId: reciterId, recitationName: recitationName))

        if fileURL == "" {
            Alamofire
                .request(ApplicationMethods.getRecitationURL(reciterId: reciterId, surahId: surahId, recitationName: recitationName))
                .downloadProgress(closure: { (progress) in
                    pvFileProgressView.progress = Float(progress.fractionCompleted)
                    pvOverallProgressView.progress = overallProgress + (pvFileProgressView.progress * Float(overallProgressFactor))
                })
                .validate()
                .responseData(completionHandler: { (response) in
                    var status = false

                    if response.result.isSuccess {
                        if let data = response.result.value {
                            let createdFileURL = DocumentManager.createFileInApplicationDirectory(contents: data, targetFilePath: ApplicationMethods.getRecitationPath(reciterId: reciterId, recitationName: recitationName))

                            if createdFileURL != "" {
                                status = true
                            }
                        }
                    }

                    completionHandler(status)
                })
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.10, execute: {
                pvFileProgressView.progress = 1

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.10, execute: {
                    completionHandler(true)
                })
            })
        }
    }
    static func cancelDownload() {
        let sessionManager = Alamofire.SessionManager.default
        
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            downloadTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            dataTasks.forEach { $0.cancel() }
        }
    }
}
