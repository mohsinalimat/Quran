import Foundation
import UIKit

class AyatSelectionManager {
    static var ayatSelectionList = [CAShapeLayer]()
    
    static func generateAyatSelectionForCurrentPage() {
        ayatSelectionList.removeAll()
        
        let ayatList = AyatRepository().getAyatList(pageId: ApplicationData.CurrentPage.Id)
        let canvasHeight = ApplicationObject.QuranPageImageView.bounds.height
        let canvasWidth = ApplicationObject.QuranPageImageView.bounds.width

        for objAyat in ayatList {
            let xAxisStartPercentage = ((100 / ApplicationConstant.QuranPageWidth) * CGFloat(objAyat.StartingPointX))
            let xAxisEndPercentage = ((100 / ApplicationConstant.QuranPageWidth) * CGFloat(objAyat.EndingPointX))
            let yAxisStartPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.StartingPointY))
            //let yAxisEndPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.EndingPointY))
            let startHeightPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.StartingRowHeight))
            let endHeightPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.EndingRowHeight))
            var xAxisStart = (canvasWidth - ((canvasWidth / 100) * xAxisEndPercentage))
            let xAxisEnd = (canvasWidth - ((canvasWidth / 100) * xAxisStartPercentage))
            var yAxisStart = ((canvasHeight / 100) * yAxisStartPercentage)
            //let yAxisEnd = ((canvasHeight / 100) * yAxisEndPercentage)
            let startHeight = ((canvasHeight / 100) * startHeightPercentage)
            let endHeight = ((canvasHeight / 100) * endHeightPercentage)
            var width = CGFloat(xAxisEnd - xAxisStart)
            var ayatSelection = CAShapeLayer()
            var selectionRectangle = CGRect(x: xAxisStart, y: yAxisStart, width: width, height: startHeight)
            var path = UIBezierPath(roundedRect: selectionRectangle, cornerRadius: 0).cgPath
            
            ayatSelection.isHidden = true
            ayatSelection.opacity = 0.5
            ayatSelection.path = path
            ayatSelection.accessibilityLabel = ApplicationMethods.getRecitationName(surahId: objAyat.SurahId, ayatOrderId: objAyat.AyatOrder)
            
            if objAyat.StartingRowNo == objAyat.EndingRowNo {
                ayatSelectionList.append(ayatSelection)
            }
            else {
                xAxisStart = 0
                width = CGFloat(xAxisEnd - xAxisStart)
                selectionRectangle = CGRect(x: xAxisStart, y: yAxisStart, width: width, height: startHeight)
                path = UIBezierPath(roundedRect: selectionRectangle, cornerRadius: 0).cgPath
                ayatSelection.path = path
                
                ayatSelectionList.append(ayatSelection)
                
                let rowDifference = Int64(objAyat.EndingRowNo - objAyat.StartingRowNo)
                
                for index in 1...rowDifference {
                    ayatSelection = CAShapeLayer()
                    yAxisStart = yAxisStart + endHeight

                    if index != rowDifference {
                        xAxisStart = 0
                        width = canvasWidth
                        selectionRectangle = CGRect(x: xAxisStart, y: yAxisStart, width: width, height: endHeight)
                        path = UIBezierPath(roundedRect: selectionRectangle, cornerRadius: 0).cgPath
                    }
                    else {
                        xAxisStart = (canvasWidth - ((canvasWidth / 100) * xAxisEndPercentage))
                        width = CGFloat(canvasWidth - xAxisStart)
                        selectionRectangle = CGRect(x: xAxisStart, y: yAxisStart, width: width, height: endHeight)
                        path = UIBezierPath(roundedRect: selectionRectangle, cornerRadius: 0).cgPath
                    }

                    ayatSelection.isHidden = true
                    ayatSelection.opacity = 0.5
                    ayatSelection.path = path
                    ayatSelection.accessibilityLabel = ApplicationMethods.getRecitationName(surahId: objAyat.SurahId, ayatOrderId: objAyat.AyatOrder)
                    
                    ayatSelectionList.append(ayatSelection)
                }
            }
        }
    }
    static func showHideAyatSelection(startTouchPoint: CGPoint, lastTouchPoint: CGPoint, touchMoving: Bool) {
        var touchRectangle = CGRect(x: startTouchPoint.x, y: startTouchPoint.y, width: 1, height: 1)
        
        if touchMoving {
            let x = min(startTouchPoint.x, lastTouchPoint.x)
            let y = min(startTouchPoint.y, lastTouchPoint.y)
            let width = fabs(startTouchPoint.x - lastTouchPoint.x)
            let height = fabs(startTouchPoint.y - lastTouchPoint.y)
            
            touchRectangle = CGRect(x: x, y: y, width: width, height: height)
        }
        
        RecitationManager.recitationList.removeAll()
        ayatSelectionList.lazy.forEach { ayatSelection in
            ayatSelection.isHidden = true
            ayatSelection.fillColor = ApplicationConstant.AyatSelectionColor
        }
        
        var ayatSelectionTempList = [CAShapeLayer]()
        var selectionStarted = false
        
        for ayatSelection in ayatSelectionList {
            if ayatSelection.isHidden && (ayatSelection.path?.boundingBoxOfPath.intersects(touchRectangle))! {
                ayatSelectionTempList.forEach { ayatSelectionTemp in
                    ayatSelectionTemp.isHidden = false
                    
                    RecitationManager.appendRecitation(accessibilityLabel: ayatSelectionTemp.accessibilityLabel!)
                }
                
                ayatSelectionList.lazy.filter { $0.isHidden && $0.accessibilityLabel == ayatSelection.accessibilityLabel }.forEach { relatedAyatSelection in
                    relatedAyatSelection.isHidden = false
                }
                
                RecitationManager.appendRecitation(accessibilityLabel: ayatSelection.accessibilityLabel!)
                
                selectionStarted = true
                ayatSelection.isHidden = false
                ayatSelectionTempList = [CAShapeLayer]()
            }
            else if selectionStarted && ayatSelection.isHidden {
                ayatSelectionTempList.append(ayatSelection)
            }
        }
    }
    static func highlightAyatSelection(recitationName: String) {
        ayatSelectionList.lazy.filter { $0.isHidden == false }.forEach { ayatSelection in
            if ayatSelection.accessibilityLabel == recitationName {
                ayatSelection.fillColor = ApplicationConstant.AyatHighlightColor
            }
            else {
                ayatSelection.fillColor = ApplicationConstant.AyatSelectionColor
            }
        }
    }
    static func highlightAyatSelectionRange(recitationList: [Recitation]) {
        RecitationManager.recitationList.removeAll()
        ayatSelectionList.lazy.forEach { ayatSelection in
            ayatSelection.isHidden = true
            ayatSelection.fillColor = ApplicationConstant.AyatSelectionColor
        }
        
        for recitationObject in recitationList {
            ayatSelectionList.lazy.filter { $0.accessibilityLabel == recitationObject.RecitationFileName }.forEach { ayatSelection in
                ayatSelection.isHidden = false
                
                RecitationManager.appendRecitation(accessibilityLabel: ayatSelection.accessibilityLabel!)
            }
        }
        
        highlightAyatSelection(recitationName: RecitationManager.recitationList.first!)
    }
    static func getAyatSelectionList(recitationName: String) -> [CAShapeLayer] {
        var lstAyatSelection = [CAShapeLayer]()
        
        if ayatSelectionList.count > 0 {
            ayatSelectionList.lazy.filter { $0.isHidden == false }.forEach { ayatSelection in
                if ayatSelection.accessibilityLabel == recitationName {
                    lstAyatSelection.append(ayatSelection)
                }
            }
        }
        
        return lstAyatSelection
    }
}
