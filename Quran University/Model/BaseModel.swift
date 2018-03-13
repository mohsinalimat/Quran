import Foundation

class BaseModel {
    private var _id: Int64
    private var _name: String
    
    var Id: Int64 {
        return _id
    }
    var Name: String {
        return _name
    }
    
    init(id: Int64, name: String) {
        self._id = id
        self._name = name
    }
}
