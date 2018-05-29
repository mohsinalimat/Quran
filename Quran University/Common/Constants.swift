import Foundation
import UIKit

struct QuranLink {
    static let Script = "http://media.quranlms.com/AppImages/Scripts/"
    static let Audio = "http://media.quranlms.com/Audio/"
//    static let BaseUrl = "http://m.services.quranlms.com/
    static let BaseAddress = "http://team-server.innotech-sa.com/"
    static let WebAPIUrl = BaseAddress + "QuranWebAPIs/"
    static let WebSiteUrl = BaseAddress + "QuranWeb/"
    static let StudentAssignmentUrl = WebSiteUrl + "Media/Assignments/Student/"
    static let TeacherAssignmentUrl = WebSiteUrl + "Media/Assignments/Teacher/"
    
    static func Book(languageId: Int64, bookId: Int64, surahId: Int64) -> URL {
        var urlAddress = ""
        
        switch ApplicationData.CurrentDownloadBookMode {
        case .CauseOfRevelation:
            urlAddress = WebAPIUrl + "RelatedData/?a=\(bookId)&l=\(languageId)"
            
            break
        case .Tafseer:
            urlAddress = WebAPIUrl + "RelatedData/?l=\(languageId)&t=\(ApplicationData.CurrentDownloadBookMode.rawValue)&m=\(bookId)&n=2&q=\(surahId)"
            
            break
        case .Translation:
            urlAddress = WebAPIUrl + "RelatedData/?l=\(languageId)&t=\(ApplicationData.CurrentDownloadBookMode.rawValue)&m=\(bookId)&n=2&q=\(surahId)"
            
            break
        case .WordMeaning:
            urlAddress = WebAPIUrl + "RelatedData/?l=\(languageId)"
            
            break
        }
        
        return URL(string: urlAddress)!
    }
    static func GetAssignment() -> URL {
        let urlAddress = WebAPIUrl + "Student/?s=1"
        
        return URL(string: urlAddress)!
    }
    static func SubmitAssignment(jsonContent: String) -> URL {
        let urlAddress = WebAPIUrl + "Student/"
        let url = URL(string: urlAddress)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem]()
        
        queryItems.append(URLQueryItem(name: "sas", value: jsonContent))
        
        urlComponents?.queryItems = queryItems
        
        return (urlComponents?.url)!
    }
    static func UploadAssignment() -> String {
        let urlAddress = WebSiteUrl + "Handlers/FileUpload.ashx?commandAction=uploadRecordedAudio"
        
        return urlAddress
    }
}

struct DirectoryStructure {
    static let Database = "Quran University/Database/"
    static let Script = "Quran University/Image/Script/"
    static let Audio = "Quran University/Audio/"
    static let Temp = "Quran University/Temp/"
    static let DefaultScript = "Quran University/Image/Script/2/"
    static let DefaultAudio = "Quran University/Audio/1/"
    static let TempRecordingRecitation = "Quran University/Temp/Recording/Recitation/"
    static let StudentAssignmentRecording = "Quran University/Student/Assignment/Recording/"
    static let TeacherAssignmentRecording = "Quran University/Teacher/Assignment/Recording/"
}

struct BundleFileType {
    static let SQLite = ".sqlite"
    static let MP3 = ".mp3"
    static let PNG = ".png"
}

struct ApplicationConstant {
    static let QuranPageHeight = CGFloat(585)
    static let QuranPageWidth = CGFloat(396)
    static let CorrectionCanvasHeight = CGFloat(555)
    static let CorrectionCanvasWidth = CGFloat(356)
    static let AyatHighlightColor = UIColor.green.cgColor
    static let AyatSelectionColor = UIColor.lightGray.cgColor
    static let AssignmentBoundaryColor = UIColor.red.cgColor
    static let AssignmentMarkColor = UIColor.black.cgColor
    static let CorrectionBoundaryColor = UIColor.black.cgColor
    static let HideMarkColor = UIColor.black.cgColor
    static let RowColor = UIColor(red: 248.0/255.0, green: 234.0/255.0, blue: 195.0/255.0, alpha: 1.0)
    static let RowSelectionColor = UIColor(red: 233.0/255.0, green: 231.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    static let ButtonTextHighlightColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let ButtonTextColor = UIColor(red: 103.0/255.0, green: 89.0/255.0, blue: 55.0/255.0, alpha: 1.0)
    static let DatabaseFile = "QuranUniversity.sqlite"
    static let QuranPageType = ".png"
    static let QuranRecitationType = ".mp3"
}

struct ApplicationLabel {
    static let ERROR = ApplicationData.CurrentLanguageMode == .English ? "Error" : "Error"
    static let INFO = ApplicationData.CurrentLanguageMode == .English ? "Info" : "Info"
    static let SUCCESS = ApplicationData.CurrentLanguageMode == .English ? "Success" : "Success"
    static let CONFIRM = ApplicationData.CurrentLanguageMode == .English ? "Confirm" : "Confirm"
    static let OK = ApplicationData.CurrentLanguageMode == .English ? "OK" : "OK"
    static let YES = ApplicationData.CurrentLanguageMode == .English ? "YES" : "YES"
    static let NO = ApplicationData.CurrentLanguageMode == .English ? "NO" : "NO"
    static let ALERT = ApplicationData.CurrentLanguageMode == .English ? "Alert" : "Alert"
    static let ACCEPTED = ApplicationData.CurrentLanguageMode == .English ? "Accepted" : "Accepted"
    static let LATE = ApplicationData.CurrentLanguageMode == .English ? "Late" : "Late"
    static let DUE = ApplicationData.CurrentLanguageMode == .English ? "Due" : "Due"
    static let NOTSENT = ApplicationData.CurrentLanguageMode == .English ? "NotSent" : "NotSent"
    static let SUBMITTED = ApplicationData.CurrentLanguageMode == .English ? "Submitted" : "Submitted"
    static let CHECKED = ApplicationData.CurrentLanguageMode == .English ? "Checked" : "Checked"
    static let RESUBMITTED = ApplicationData.CurrentLanguageMode == .English ? "Resubmitted" : "Resubmitted"
    static let RECHECKED = ApplicationData.CurrentLanguageMode == .English ? "Rechecked" : "Rechecked"
    static let LANGUAGE = ApplicationData.CurrentLanguageMode == .English ? "Language" : "Language"
    static let BOOK = ApplicationData.CurrentLanguageMode == .English ? "Book" : "Book"
}

struct ApplicationHeading {
    static let SCRIPT_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Script Download" : "Script Download"
    static let RECITATION_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Recitation Download" : "Recitation Download"
    static let DOWNLOAD_EACH_SCRIPT = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for each Script" : "Download Progress for each Script"
    static let DOWNLOAD_TOTAL_SCRIPT = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for total Script" : "Download Progress for total Script"
    static let DOWNLOAD_EACH_RECITATION = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for each Recitation" : "Download Progress for each Recitation"
    static let DOWNLOAD_TOTAL_RECITATION = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for total Recitation" : "Download Progress for total Recitation"
    static let TAFSEER_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Tafseer Download" : "Tafseer Download"
    static let TRANSLATION_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Translation Download" : "Translation Download"
    static let DOWNLOAD_TOTAL_TAFSEER = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for Tafseer" : "Download Progress for Tafseer"
    static let DOWNLOAD_TOTAL_TRANSLATION = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for Translation" : "Download Progress for Translation"
    static let WORDMEANING_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Word Meaning Download" : "Word Meaning Download"
    static let CAUSEOFREVELATION_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Cause of Revelation Download" : "Cause of Revelation Download"
    static let DOWNLOAD_TOTAL_WORDMEANING = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for Word Meaning" : "Download Progress for Word Meaning"
    static let DOWNLOAD_TOTAL_CAUSEOFREVELATION = ApplicationData.CurrentLanguageMode == .English ? "Download Progress for Cause of Revelation" : "Download Progress for Cause of Revelation"
    static let MARKS = ApplicationData.CurrentLanguageMode == .English ? "Marks: " : "Marks: "
}

struct ApplicationErrorMessage {
    static let DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Download interrupted due to invalid request or bad Internet Connection. Please connect to internet and try again!" : "Download interrupted due to invalid request or bad Internet Connection. Please connect to internet and try again!"
    static let INVALIDDATA = ApplicationData.CurrentLanguageMode == .English ? "Invalid data found!" : "Invalid data found!"
    static let UPLOAD = ApplicationData.CurrentLanguageMode == .English ? "Upload interrupted due to bad Internet Connection. Please connect to internet and try again!" : "Upload interrupted due to bad Internet Connection. Please connect to internet and try again!"
}

struct ApplicationInfoMessage {
    static let SELECT_SURAH = ApplicationData.CurrentLanguageMode == .English ? "Please select Surah" : "Please select Surah"
    static let SELECT_PAGE = ApplicationData.CurrentLanguageMode == .English ? "Please select Page" : "Please select Page"
    static let SELECT_JUZZ = ApplicationData.CurrentLanguageMode == .English ? "Please select Juzz" : "Please select Juzz"
    static let INVALID_FROM_PAGE = ApplicationData.CurrentLanguageMode == .English ? "Invalid From Page" : "Invalid From Page"
    static let INVALID_TO_PAGE = ApplicationData.CurrentLanguageMode == .English ? "Invalid To Page" : "Invalid To Page"
    static let INVALID_PAGE_RANGE = ApplicationData.CurrentLanguageMode == .English ? "Invalid Page Range" : "Invalid Page Range"
    static let SOME_SCRIPT_NOT_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Some script files are not downloaded due to some error" : "Some script files are not downloaded due to some error"
    static let SOME_RECITATION_NOT_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Some recitation files are not downloaded due to some error" : "Some recitation files are not downloaded due to some error"
    static let INTERNET_AVAILABLE = ApplicationData.CurrentLanguageMode == .English ? "Internet Available Now" : "Internet Available Now"
    static let INTERNET_NOT_AVAILABLE = ApplicationData.CurrentLanguageMode == .English ? "Internet Not Available" : "Internet Not Available"
    static let SELECT_AYAT = ApplicationData.CurrentLanguageMode == .English ? "Please select Ayah" : "Please select Ayah"
    static let PAGE_SURAH_JUZZ_NOT_AVAILABLE = ApplicationData.CurrentLanguageMode == .English ? "Current Page/Surah/Juzz not available!" : "Current Page/Surah/Juzz not available!"
    static let WANT_TO_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Do you want to download it?" : "Do you want to download it?"
    static let INVALID_START_SURAH = ApplicationData.CurrentLanguageMode == .English ? "Invalid Start Surah" : "Invalid Start Surah"
    static let INVALID_END_SURAH = ApplicationData.CurrentLanguageMode == .English ? "Invalid End Surah" : "Invalid End Surah"
    static let INVALID_START_AYAT = ApplicationData.CurrentLanguageMode == .English ? "Invalid Start Ayah" : "Invalid Start Ayah"
    static let INVALID_END_AYAT = ApplicationData.CurrentLanguageMode == .English ? "Invalid End Ayah" : "Invalid End Ayah"
    static let AYAT_MISSING_DOWNLOAD_SCRIPT_RECITATION = ApplicationData.CurrentLanguageMode == .English ? "Some of the Ayah(s) for selected range is not available. Please download the missing Script, Recitation and try again!" : "Some of the Ayah(s) for selected range is not available. Please download the missing Script, Recitation and try again!"
    static let SELECT_BOOK = ApplicationData.CurrentLanguageMode == .English ? "Please select Book" : "Please select Book"
    static let SOME_BOOK_NOT_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Some book files are not downloaded due to some error" : "Some book files are not downloaded due to some error"
    static let MAX_RECORDING_LIMIT = ApplicationData.CurrentLanguageMode == .English ? "Maximum recording limit is reached" : "Maximum recording limit is reached"
    static let SELECT_PREFERENCE = ApplicationData.CurrentLanguageMode == .English ? "Please select at least one preference to save" : "Please select at least one preference to save"
    static let ACCESS_MICROPHONE = ApplicationData.CurrentLanguageMode == .English ? "Please allow app to access Microphone" : "Please allow app to access Microphone"
    static let SELECT_MISTAKE_CORRECTION = ApplicationData.CurrentLanguageMode == .English ? "Please select Mistake/Correction" : "Please select Mistake/Correction"
    
    static var DEFAULT_RECITER_RECITATION_NOT_AVAILABLE: String {
        return (ApplicationData.CurrentLanguageMode == .English ? "Reciter '\(ApplicationData.CurrentReciter.Name)' Recitations for this page are not available!" : "Reciter '\(ApplicationData.CurrentReciter.Name)' Recitations for this page are not available!")
    }
}

struct ApplicationSuccessMessage {
    static let SCRIPT_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Scripts are downloaded successfully" : "Scripts are downloaded successfully"
    static let RECITATION_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Recitations are downloaded successfully" : "Recitations are downloaded successfully"
    static let BOOK_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Book is downloaded successfully" : "Book is downloaded successfully"
    static let ASSIGNMENT_SUBMIT = ApplicationData.CurrentLanguageMode == .English ? "Assignment is submitted successfully" : "Assignment is submitted successfully"
}

struct ApplicationConfirmMessage {
    static let CANCEL_SCRIPT_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Are you sure you want to cancel Script download?" : "Are you sure you want to cancel Script download?"
    static let CANCEL_RECITATION_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Are you sure you want to cancel Recitation download?" : "Are you sure you want to cancel Recitation download?"
    static let CANCEL_BOOK_DOWNLOAD = ApplicationData.CurrentLanguageMode == .English ? "Are you sure you want to cancel Book download?" : "Are you sure you want to cancel Book download?"
    static let TURN_OFF_ASSIGNMENT_MODE = ApplicationData.CurrentLanguageMode == .English ? "Do you want to turn off assignment mode?" : "Do you want to turn off assignment mode?"
    static let REPLACE_ASSIGNMENT_RECORDING = ApplicationData.CurrentLanguageMode == .English ? "It will replace the existing assignment Recording, Do you want to continue?" : "It will replace the existing assignment Recording, Do you want to continue?"
}

struct AssignmentStatusColor {
    static let DUE_BG = UIColor(red: 248.0/255, green: 214.0/255, blue: 180.0/255, alpha: 1.0)
    static let DUE_B = UIColor(red: 244.0/255, green: 191.0/255, blue: 144.0/255, alpha: 1.0)
    static let LATE_BG = UIColor(red: 246.0/255, green: 162.0/255, blue: 149.0/255, alpha: 1.0)
    static let LATE_B = UIColor(red: 238.0/255, green: 133.0/255, blue: 120.0/255, alpha: 1.0)
    static let NOT_SENT_BG = UIColor(red: 121.0/255, green: 119.0/255, blue: 122.0/255, alpha: 1.0)
    static let NOT_SENT_B = UIColor(red: 202.0/255, green: 200.0/255, blue: 203.0/255, alpha: 1.0)
    static let ACCEPTED_BG = UIColor(red: 192.0/255, green: 214.0/255, blue: 154.0/255, alpha: 1.0)
    static let ACCEPTED_B = UIColor(red: 165.0/255, green: 195.0/255, blue: 107.0/255, alpha: 1.0)
    static let SUBMITTED_BG = UIColor(red: 245.0/255, green: 245.0/255, blue: 245.0/255, alpha: 1.0)
    static let SUBMITTED_B = UIColor(red: 118.0/255, green: 118.0/255, blue: 118.0/255, alpha: 1.0)
    static let CHECKED_BG = UIColor(red: 219.0/255, green: 217.0/255, blue: 220.0/255, alpha: 1.0)
    static let CHECKED_B = UIColor(red: 166.0/255, green: 163.0/255, blue: 171.0/255, alpha: 1.0)
}
