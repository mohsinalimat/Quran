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
    case ListenRepeat = 400
    case RecordCompare = 500
    case RecordedAssignment = 600
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

enum RecitationRepeatFor: Int32 {
    case Ayat = 1
    case Range = 2
}

enum AudioPlayMode: Int32 {
    case Playing = 1
    case Paused = 2
}

enum RecordComparePlayMode: Int32 {
    case Recording = 1
    case Ayat = 2
}

enum FooterSectionMode: Int32 {
    case Player = 1
    case Recording = 2
    case AssignmentRecording = 3
}

enum RecordCompareMode: Int32 {
    case Ready = 1
    case RRefresh = 2
    case RRecord = 3
    case RStop = 4
    case GPlay = 5
    case GRefresh = 6
}

enum RecordUploadMode: Int32 {
    case Record = 1
    case Stop = 2
    case Play = 3
    case Pause = 4
}

enum AssignmentStatus: Int32 {
    case Due = 1
    case Late = 2
    case NotSent = 3
    case Accepted = 4
    case SubmittedResubmitted = 5
    case CheckedRechecked = 6
    case Submitted = 7
    case Resubmitted = 8
    case Checked = 9
    case Rechecked = 10
}

enum FileMissingMode: Int32 {
    case None = 0
    case All = 1
    case Audio = 2
    case Script = 3
}
