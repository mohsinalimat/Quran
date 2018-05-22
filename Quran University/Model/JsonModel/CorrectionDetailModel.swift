import Foundation

struct CorrectionDetailModel: Decodable {
    var Id: Int64
    var TeacherComment: String
    var TeacherAudioFile: String
    var TopRightx: Int64
    var TopRighty: Int64
    var BottomLeftx: Int64
    var BottomLefty: Int64
    
    init() {
        self.Id = 0
        self.TeacherComment = ""
        self.TeacherAudioFile = ""
        self.TopRightx = 0
        self.TopRighty = 0
        self.BottomLeftx = 0
        self.BottomLefty = 0
    }
}
