import Foundation

enum LanguageMode: Int32 {
    case Arabic = 1
    case English = 2
}

enum DownloadPageMode: Int32 {
    case Confirm = 0
    case Option = 1
    case Download = 2
}

enum DownloadMode: Int32 {
    case Script = 1
    case Audio = 2
}

enum DownloadCategoryMode: Int32 {
    case Surah = 1
    case Page = 2
    case Juzz = 3
    case Quran = 4
}

enum PageMode: Int32 {
    case From = 1
    case To = 2
}

enum AudioPlayerMode: Int32 {
    case None = 0
    case Ready = 1
    case Play = 2
    case Pause = 3
    case Stop = 4
    case Next = 5
    case Previous = 6
    case Restart = 7
}

enum ViewTag: Int {
    case TopMenu = 100
    case BaseLeftMenu = 200
    case BaseRightMenu = 300
}

enum ContinuousRecitationMode: Int32 {
    case StartSurah = 1
    case StartAyat = 2
    case EndSurah = 3
    case EndAyat = 4
    case AyatRecitationSilence = 5
    case RangeRecitationSilence = 6
    case AyatNumber = 7
    case RangeNumber = 8
}

enum DownloadBookMode: Int32 {
    case WordMeaning = 1
    case Translation = 2
    case Tafseer = 3
    case CauseOfRevelation = 4
}
