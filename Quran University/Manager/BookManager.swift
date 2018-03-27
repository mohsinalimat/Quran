import Foundation
import UIKit

class BookManager {
    typealias methodHandler1 = () -> Void
    
    static var pvOverallProgressView = UIProgressView()
    static var bookCompletionHandler:(() -> Void)?
    static var dataTask: URLSessionDataTask?
    static var surahList = [Surah]()
    static var bookId: Int64 = 0
    static var languageId: Int64 = 0
    static var lastSurahId: Int64 = 0
    static var firstSurahId: Int64 = 0
    static var totalDownload: Int = 0
    static var currentDownload: Int = 1
    static var successDownload: Int = 0
    static var errorDownload: Int = 0
    static var overallFileProgressFactor: Double = 0
    static var terminateDownload = false
    
    static func downloadBook(uiOProgressView: UIProgressView, currentBookId: Int64, currentLanguageId: Int64, completionHandler: @escaping methodHandler1) {
        setDownloadConstraint(enableConstraint: true)
        surahList.removeAll()
        
        pvOverallProgressView = uiOProgressView
        bookId = currentBookId
        languageId = currentLanguageId
        bookCompletionHandler = completionHandler
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .WordMeaning:
            surahList = SurahRepository().getSurahList(fromSurahId: 1, toSurahId: 1)
            
            startDummyProgress(progressFactor: 0.01, delayInSeconds: 1)
            
            break
        case .Tafseer:
            surahList = SurahRepository().getSurahList()
            
            break
        case .Translation:
            surahList = SurahRepository().getSurahList()
            
            break
        case .CauseOfRevelation:
            surahList = SurahRepository().getSurahList(fromSurahId: 1, toSurahId: 1)
            
            startDummyProgress(progressFactor: 0.01, delayInSeconds: 1)
            
            break
        }
        
        totalDownload = surahList.count
        overallFileProgressFactor = (1 / Double(totalDownload))
        
        continueDownloadBook()
    }
    static func continueDownloadBook() {
        if terminateDownload {
            setDownloadConstraint(enableConstraint: false)
        }
        else {
            if let surahId = surahList.first?.Id {
                let url = QuranLink.Book(languageId: languageId, bookId: bookId, surahId: surahId)
                
                dataTask = URLSession.shared.dataTask(with: url) { (data, response, err) in
                    var downloadStatus = false
                    let response = response as? HTTPURLResponse
                    
                    if err == nil && response?.statusCode == 200 {
                        do {
//                            let jsonString = String(data: data!, encoding: .utf8)
                            let response = try JSONDecoder().decode(JsonResponse.self, from: data!)
                            var status = false
                            
                            switch ApplicationData.CurrentDownloadBookMode {
                            case .WordMeaning:
                                status = WordMeaningBookDetailRepository().saveWordMeaningBookDetail(maaniMafrudatList: response.MaaniMafrudatList!, bookId: self.bookId)
                                
                                break
                            case .Tafseer:
                                status = TafseerBookDetailRepository().saveTafseerBookDetail(quranTextList: response.QuranTextList!, surahId: surahId, bookId: self.bookId)
                                
                                break
                            case .Translation:
                                status = TranslationBookDetailRepository().saveTranslationBookDetail(quranTextList: response.QuranTextList!, surahId: surahId, bookId: self.bookId)
                                
                                break
                            case .CauseOfRevelation:
                                status = CauseOfRevelationBookDetailRepository().saveCauseOfRevelationBookDetail(asbabNazoolList: response.AsbabNazoolList!, bookId: self.bookId)
                                
                                break
                            }
                            
                            if status {
                                downloadStatus = true
                            }
                        }
                        catch {
                            print("Error: \(error).")
                        }
                    }
                    
                    if downloadStatus {
                        self.successDownload = self.successDownload + 1
                        self.lastSurahId = surahId
                        
                        if self.firstSurahId <= 0 {
                            self.firstSurahId = surahId
                        }
                    }
                    else {
                        self.errorDownload = self.errorDownload + 1
                    }
                    
                    DispatchQueue.main.async {
                        self.pvOverallProgressView.progress = Float(self.overallFileProgressFactor) * Float(self.currentDownload)
                    }
                    
                    self.currentDownload = self.currentDownload + 1
                    
                    self.surahList.remove(at: 0)
                    self.continueDownloadBook()
                }
                
                dataTask?.resume()
            }
            else {
                if self.totalDownload > 0 {
                    if self.errorDownload > 0 {
                        if self.successDownload > 0 {
                            DialogueManager.showInfo(viewController: ApplicationObject.CurrentViewController, message: ApplicationInfoMessage.SOME_BOOK_NOT_DOWNLOAD, okHandler: {
                                self.setDownloadConstraint(enableConstraint: false)
                                bookCompletionHandler!()
                            })
                        }
                        else {
                            DialogueManager.showError(viewController: ApplicationObject.CurrentViewController, message: ApplicationErrorMessage.DOWNLOAD, okHandler: {
                                self.setDownloadConstraint(enableConstraint: false)
                                bookCompletionHandler!()
                            })
                        }
                    }
                    else if self.successDownload > 0 {
                        DialogueManager.showSuccess(viewController: ApplicationObject.CurrentViewController, message: ApplicationSuccessMessage.BOOK_DOWNLOAD, okHandler: {
                            self.setDownloadConstraint(enableConstraint: false)
                            bookCompletionHandler!()
                        })
                    }
                }
            }
        }
    }
    static func cancelDownloadBook(yesHandler: @escaping methodHandler1) {
        DialogueManager.showConfirmation(viewController: ApplicationObject.CurrentViewController, message: ApplicationConfirmMessage.CANCEL_BOOK_DOWNLOAD, yesHandler: {
            self.setDownloadConstraint(enableConstraint: false)
            self.dataTask?.cancel()
            yesHandler()
        })
    }
    static func setDownloadConstraint(enableConstraint: Bool) {
        DispatchQueue.main.async {
            pvOverallProgressView.progress = 0
        }
        
        lastSurahId = 0
        firstSurahId = 0
        totalDownload = 0
        currentDownload = 1
        successDownload = 0
        errorDownload = 0
        
        if enableConstraint {
            terminateDownload = false
        }
        else {
            terminateDownload = true
        }
    }
    static func startDummyProgress(progressFactor: Float, delayInSeconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds, execute: {
            self.pvOverallProgressView.progress = self.pvOverallProgressView.progress + progressFactor
            
            if self.pvOverallProgressView.progress < 0.9 && !terminateDownload {
                startDummyProgress(progressFactor: progressFactor, delayInSeconds: delayInSeconds)
            }
            else if terminateDownload {
                self.pvOverallProgressView.progress = 0
            }
        })
    }
}
