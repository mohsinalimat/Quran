import Foundation

class CorrectionManager {
    static var selectedCorrectionDetailList = [Int32: [CorrectionDetailModel]]()
    
    static func loadCorrectionMode(selectedIdList: [Int32: Int64]) {
        ApplicationData.CorrectionModeOn = true
        
        selectedCorrectionDetailList.removeAll()
        
        for selectedObj in selectedIdList {
            let objCorrection = ApplicationData.CurrentAssignment.Correction.filter { $0.Id == selectedObj.value }.first
            
            selectedCorrectionDetailList[selectedObj.key] = objCorrection?.CorrectionDetail
        }
        
        AyatSelectionManager.generateShowCorrectionSelection(correctionDetailDictionary: selectedCorrectionDetailList)
    }
    static func unloadCorrectionMode() {
        ApplicationData.CorrectionModeOn = false
        
        AyatSelectionManager.removeCorrectionSelection()
    }
}
