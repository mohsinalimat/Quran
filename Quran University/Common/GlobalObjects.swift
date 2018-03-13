import Foundation
import UIKit
import AVFoundation

struct ApplicationObject {
    static var MainViewController = UIViewController()
    static var CurrentViewController = UIViewController()
    static var QuranPageImageView = UIImageView()
    static var RecitationAudioPlayer = AVAudioPlayer()
    static var SurahButton = UIButton()
    static var PageButton = UIButton()
    static var JuzzButton = UIButton()
    static var RestartButton = UIButton()
    static var PreviousButton = UIButton()
    static var StopButton = UIButton()
    static var PlayButton = UIButton()
    static var PauseButton = UIButton()
    static var NextButton = UIButton()
}

struct ApplicationData {
    static var CurrentLanguageMode = LanguageMode.English
    static var CurrentDownloadMode = DownloadMode.Script
    static var CurrentDownloadCategoryMode = DownloadCategoryMode.Surah
    static var CurrentDownloadBookMode = DownloadBookMode.Tafseer
    static var CurrentDownloadPageMode = DownloadPageMode.Confirm.hashValue
    static var CurrentScript = ScriptRepository().getScript(Id: 2)
    static var CurrentReciter = ReciterRepository().getReciter(Id: 1)
    static var CurrentSurah = SurahRepository().getSurah(Id: 114)
    static var CurrentPage = PageRepository().getPage(Id: 604)
    static var CurrentJuzz = JuzzRepository().getJuzz(Id: 30)
    static var CurrentPageGroup = PageRepository().getPageGroup(pageId: 600)
    static var WordMeaningBookList = [WordMeaningBook]()
    static var TranslationBookList = [TranslationBook]()
    static var TafseerBookList = [TafseerBook]()
    static var CauseOfRevelationBookList = [CauseOfRevelationBook]()
}
