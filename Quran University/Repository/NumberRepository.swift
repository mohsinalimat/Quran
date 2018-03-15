import Foundation
import SQLite3

class NumberRepository : BaseRepository {
    func getNumberList() -> [Number] {
        var numberList = [Number]()
        var i:Int64 = 0
        
        while (i <= 20) {
            let numberObject = Number(Id: i)
            
            numberList.append(numberObject)
            
            i = i + 1
        }
        
        return numberList
    }
    func getFirstNumber() -> Number {
        let numberObject = Number(Id: 0)
        
        return numberObject
    }
    func getNumber(Id: Int64) -> Number {
        let numberObject = Number(Id: Id)
        
        return numberObject
    }
}
