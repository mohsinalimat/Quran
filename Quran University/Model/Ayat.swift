import Foundation

class Ayat {
    var ChapterNo: Int64
    var ChapterId: Int64
    var ChapterName: String
    var SurahNo: Int64
    var SurahName: String
    var SurahId: Int64
    var SurahStartingPageNo: Int64
    var SurahEndingPageNo: Int64
    var AyatId: Int64
    var AyatOrder: Int64
    var AyatText: String
    var StartingPointX: Double
    var EndingPointX: Double
    var StartingPointY: Double
    var EndingPointY: Double
    var StartingPageNo: Int64
    var EndingPageNo: Int64
    var StartingRowNo: Int64
    var EndingRowNo: Int64
    var StartingRowHeight: Double
    var EndingRowHeight: Double
    
    init() {
        self.ChapterNo = 0
        self.ChapterId = 0
        self.ChapterName = ""
        self.SurahNo = 0
        self.SurahName = ""
        self.SurahId = 0
        self.SurahStartingPageNo = 0
        self.SurahEndingPageNo = 0
        self.AyatId = 0
        self.AyatOrder = 0
        self.AyatText = ""
        self.StartingPointX = 0
        self.EndingPointX = 0
        self.StartingPointY = 0
        self.EndingPointY = 0
        self.StartingPageNo = 0
        self.EndingPageNo = 0
        self.StartingRowNo = 0
        self.EndingRowNo = 0
        self.StartingRowHeight = 0
        self.EndingRowHeight = 0
    }
}
