import Foundation

class Number: BaseModel {
    init() {
        super.init(id: 0, name: "")
    }
    init(Id: Int64) {
        super.init(id: Id, name: String(Id))
    }
}

