import Foundation
import UIKit

class AyatSelectionManager {
    static var ayatSelectionList = [CAShapeLayer]()
    static var assignmentBoundaryList = [CAShapeLayer]()
    static var correctionSelectionList = [CAShapeLayer]()
    static var correctionBoundaryList = [CAShapeLayer]()
    
    static func generateAyatSelectionForCurrentPage() {
        removeAyatSelection()
        
        let ayatList = AyatRepository().getAyatList(pageId: ApplicationData.CurrentPage.Id)
        let canvasHeight = ApplicationObject.QuranPageImageView.bounds.height
        let canvasWidth = ApplicationObject.QuranPageImageView.bounds.width

        for objAyat in ayatList {
            let xAxisStartPercentage = ((100 / ApplicationConstant.QuranPageWidth) * CGFloat(objAyat.StartingPointX))
            let xAxisEndPercentage = ((100 / ApplicationConstant.QuranPageWidth) * CGFloat(objAyat.EndingPointX))
            let yAxisStartPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.StartingPointY))
            let startHeightPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.StartingRowHeight))
            let endHeightPercentage = ((100 / ApplicationConstant.QuranPageHeight) * CGFloat(objAyat.EndingRowHeight))
            var xAxisStart = (canvasWidth - ((canvasWidth / 100) * xAxisEndPercentage))
            let xAxisEnd = (canvasWidth - ((canvasWidth / 100) * xAxisStartPercentage))
            var yAxisStart = ((canvasHeight / 100) * yAxisStartPercentage)
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
        
        for objAyatSelection in ayatSelectionList {
            ApplicationObject.QuranPageImageView.layer.addSublayer(objAyatSelection)
        }
    }
    static func removeAyatSelection() {
        for ayatSelection in ayatSelectionList {
            ayatSelection.removeFromSuperlayer()
        }
        
        ayatSelectionList.removeAll()
        RecitationManager.recitationList.removeAll()
    }
    static func generateBoundaryForCurrentAssignment() {
        removeAssignmentBoundary()
        
        let startPoint = ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0]
        let endPoint = ApplicationData.CurrentAssignment.AssignmentBoundary[0].EndPoint[0]
        var startAyatSelection = CAShapeLayer()
        var endAyatSelection = CAShapeLayer()

        for ayatSelection in ayatSelectionList {
            let recitationObject = ApplicationMethods.getRecitaion(recitationLabel: ayatSelection.accessibilityLabel!)

            if recitationObject.AyatId == startPoint.AyatId {
                if startAyatSelection.accessibilityLabel == nil {
                    startAyatSelection = ayatSelection
                }
                
                endAyatSelection = ayatSelection
            }
            else if recitationObject.AyatId == endPoint.AyatId {
                endAyatSelection = ayatSelection
            }
        }
        
        // Assignment Start
        
        var assignmentBoundary = CAShapeLayer()
        var selectionRect = (startAyatSelection.path?.boundingBoxOfPath)!
        var assignmentRect = CGRect(x: selectionRect.maxX - 3, y: selectionRect.origin.y, width: 3, height: selectionRect.size.height)
        var assignmentPath = UIBezierPath(roundedRect: assignmentRect, cornerRadius: 0).cgPath
        
        assignmentBoundary.opacity = 1
        assignmentBoundary.path = assignmentPath
        assignmentBoundary.fillColor = ApplicationConstant.AssignmentBoundaryColor
        
        ApplicationObject.QuranPageImageView.layer.addSublayer(assignmentBoundary)
        assignmentBoundaryList.append(assignmentBoundary)
        
        assignmentBoundary = CAShapeLayer()
        selectionRect = (startAyatSelection.path?.boundingBoxOfPath)!
        assignmentRect = CGRect(x: selectionRect.maxX - 6, y: selectionRect.origin.y, width: 3, height: 3)
        assignmentPath = UIBezierPath(roundedRect: assignmentRect, cornerRadius: 0).cgPath
        
        assignmentBoundary.opacity = 1
        assignmentBoundary.path = assignmentPath
        assignmentBoundary.fillColor = ApplicationConstant.AssignmentBoundaryColor
        
        ApplicationObject.QuranPageImageView.layer.addSublayer(assignmentBoundary)
        assignmentBoundaryList.append(assignmentBoundary)
        
        assignmentBoundary = CAShapeLayer()
        selectionRect = (startAyatSelection.path?.boundingBoxOfPath)!
        assignmentRect = CGRect(x: selectionRect.maxX - 6, y: selectionRect.origin.y + selectionRect.size.height - 3, width: 3, height: 3)
        assignmentPath = UIBezierPath(roundedRect: assignmentRect, cornerRadius: 0).cgPath
        
        assignmentBoundary.opacity = 1
        assignmentBoundary.path = assignmentPath
        assignmentBoundary.fillColor = ApplicationConstant.AssignmentBoundaryColor
        
        ApplicationObject.QuranPageImageView.layer.addSublayer(assignmentBoundary)
        assignmentBoundaryList.append(assignmentBoundary)
        
        // Assignment Start
        
        // Assignment End
        
        assignmentBoundary = CAShapeLayer()
        selectionRect = (endAyatSelection.path?.boundingBoxOfPath)!
        assignmentRect = CGRect(x: selectionRect.minX, y: selectionRect.origin.y, width: 3, height: selectionRect.size.height)
        assignmentPath = UIBezierPath(roundedRect: assignmentRect, cornerRadius: 0).cgPath

        assignmentBoundary.opacity = 1
        assignmentBoundary.path = assignmentPath
        assignmentBoundary.fillColor = ApplicationConstant.AssignmentBoundaryColor

        ApplicationObject.QuranPageImageView.layer.addSublayer(assignmentBoundary)
        assignmentBoundaryList.append(assignmentBoundary)
        
        assignmentBoundary = CAShapeLayer()
        selectionRect = (endAyatSelection.path?.boundingBoxOfPath)!
        assignmentRect = CGRect(x: selectionRect.minX + 3, y: selectionRect.origin.y, width: 3, height: 3)
        assignmentPath = UIBezierPath(roundedRect: assignmentRect, cornerRadius: 0).cgPath
        
        assignmentBoundary.opacity = 1
        assignmentBoundary.path = assignmentPath
        assignmentBoundary.fillColor = ApplicationConstant.AssignmentBoundaryColor
        
        ApplicationObject.QuranPageImageView.layer.addSublayer(assignmentBoundary)
        assignmentBoundaryList.append(assignmentBoundary)
        
        assignmentBoundary = CAShapeLayer()
        selectionRect = (endAyatSelection.path?.boundingBoxOfPath)!
        assignmentRect = CGRect(x: selectionRect.minX + 3, y: selectionRect.origin.y + selectionRect.size.height - 3, width: 3, height: 3)
        assignmentPath = UIBezierPath(roundedRect: assignmentRect, cornerRadius: 0).cgPath
        
        assignmentBoundary.opacity = 1
        assignmentBoundary.path = assignmentPath
        assignmentBoundary.fillColor = ApplicationConstant.AssignmentBoundaryColor
        
        ApplicationObject.QuranPageImageView.layer.addSublayer(assignmentBoundary)
        assignmentBoundaryList.append(assignmentBoundary)
        
        // Assignment End
    }
    static func removeAssignmentBoundary() {
        for assignmentBoundary in assignmentBoundaryList {
            assignmentBoundary.removeFromSuperlayer()
        }
        
        assignmentBoundaryList.removeAll()
    }
    static func showHideAyatSelection(startTouchPoint: CGPoint, lastTouchPoint: CGPoint, touchMoving: Bool) {
        hideAyatSelection()
        
        var touchRectangle = CGRect(x: startTouchPoint.x, y: startTouchPoint.y, width: 1, height: 1)
        
        if touchMoving {
            let x = min(startTouchPoint.x, lastTouchPoint.x)
            let y = min(startTouchPoint.y, lastTouchPoint.y)
            let width = fabs(startTouchPoint.x - lastTouchPoint.x)
            let height = fabs(startTouchPoint.y - lastTouchPoint.y)
            
            touchRectangle = CGRect(x: x, y: y, width: width, height: height)
        }
        
        var ayatSelectionTempList = [CAShapeLayer]()
        var selectionStarted = false
        
        for ayatSelection in ayatSelectionList {
            if ayatSelection.isHidden && (ayatSelection.path?.boundingBoxOfPath.intersects(touchRectangle))! {
                var continueStatus = true
                
                if ApplicationData.AssignmentModeOn {
                    let recitationObject = ApplicationMethods.getRecitaion(recitationLabel: ayatSelection.accessibilityLabel!)
                    
                    continueStatus = false
                    
                    if (recitationObject.AyatId >= ApplicationData.CurrentAssignment.AssignmentBoundary[0].StartPoint[0].AyatId &&
                        recitationObject.AyatId <= ApplicationData.CurrentAssignment.AssignmentBoundary[0].EndPoint[0].AyatId) {
                        continueStatus = true
                    }
                }
                
                if continueStatus {
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
        hideAyatSelection()
        
        for recitationObject in recitationList {
            ayatSelectionList.lazy.filter { $0.accessibilityLabel == recitationObject.RecitationFileName }.forEach { ayatSelection in
                ayatSelection.isHidden = false
                
                RecitationManager.appendRecitation(accessibilityLabel: ayatSelection.accessibilityLabel!)
            }
        }
        
        highlightAyatSelection(recitationName: RecitationManager.recitationList.first!)
    }
    static func hideAyatSelection() {
        ayatSelectionList.lazy.forEach { ayatSelection in
            ayatSelection.isHidden = true
            ayatSelection.opacity = 0.5
            ayatSelection.fillColor = ApplicationConstant.AyatSelectionColor
        }
        
        RecitationManager.recitationList.removeAll()
    }
    static func markAyatSelectionRange(recitationList: [Recitation]) {
        hideAyatSelection()
        
        for recitationObject in recitationList {
            ayatSelectionList.lazy.filter { $0.accessibilityLabel == recitationObject.RecitationFileName }.forEach { ayatSelection in
                ayatSelection.isHidden = false
                ayatSelection.opacity = 1.0
                ayatSelection.fillColor = ApplicationConstant.AssignmentMarkColor
                
                RecitationManager.appendRecitation(accessibilityLabel: ayatSelection.accessibilityLabel!)
            }
        }
    }
    static func removeCorrectionSelection() {
        for correctionSelection in correctionSelectionList {
            correctionSelection.removeFromSuperlayer()
        }
        
        correctionSelectionList.removeAll()
    }
    static func generateShowCorrectionSelection(correctionDetailDictionary: [Int32: [CorrectionDetailModel]]) {
        hideAyatSelection()
        removeCorrectionSelection()
        
        let canvasHeight = ApplicationObject.QuranPageImageView.bounds.height
        let canvasWidth = ApplicationObject.QuranPageImageView.bounds.width
        
        for objCorrectionDetailDictionary in correctionDetailDictionary {
            let correctionDetailList = objCorrectionDetailDictionary.value
            
            for objCorrectionDetail in correctionDetailList {
                let xAxisStartPercentage = ((100 / ApplicationConstant.CorrectionCanvasWidth) * CGFloat(objCorrectionDetail.TopRightx))
                let xAxisEndPercentage = ((100 / ApplicationConstant.CorrectionCanvasWidth) * CGFloat(objCorrectionDetail.BottomLeftx))
                let yAxisStartPercentage = ((100 / ApplicationConstant.CorrectionCanvasHeight) * CGFloat(objCorrectionDetail.TopRighty))
                let startHeightPercentage = ((100 / ApplicationConstant.CorrectionCanvasHeight) * CGFloat(objCorrectionDetail.BottomLefty - objCorrectionDetail.TopRighty))
                let xAxisStart = (canvasWidth - ((canvasWidth / 100) * xAxisEndPercentage))
                let xAxisEnd = (canvasWidth - ((canvasWidth / 100) * xAxisStartPercentage))
                let yAxisStart = ((canvasHeight / 100) * yAxisStartPercentage)
                let startHeight = ((canvasHeight / 100) * startHeightPercentage)
                let width = CGFloat(xAxisEnd - xAxisStart)
                let correctionSelection = CAShapeLayer()
                let selectionRectangle = CGRect(x: xAxisStart, y: yAxisStart, width: width, height: startHeight)
                let path = UIBezierPath(roundedRect: selectionRectangle, cornerRadius: 0).cgPath
                
                correctionSelection.isHidden = false
                correctionSelection.fillColor = ApplicationMethods.getCorrectionBGColor(number: objCorrectionDetailDictionary.key).cgColor
                correctionSelection.opacity = 0.5
                correctionSelection.path = path
                correctionSelection.accessibilityLabel = String(objCorrectionDetail.Id) + "-" + String(objCorrectionDetailDictionary.key)
                
                correctionSelectionList.append(correctionSelection)
            }
        }
        
        for correctionSelection in correctionSelectionList {
            ApplicationObject.QuranPageImageView.layer.addSublayer(correctionSelection)
        }
    }
    static func resetCorrectionSelection() {
        for correctionSelection in correctionSelectionList {
            let arrCorrection = correctionSelection.accessibilityLabel?.components(separatedBy: "-")
            let number = Int32(arrCorrection![1])!
            
            correctionSelection.fillColor = ApplicationMethods.getCorrectionBGColor(number: number).cgColor
        }
    }
    static func removeCorrectionBoundary() {
        for correctionBoundary in correctionBoundaryList {
            correctionBoundary.removeFromSuperlayer()
        }
        
        correctionBoundaryList.removeAll()
    }
    static func selectCorrection(startTouchPoint: CGPoint, endTouchPoint: CGPoint) {
        resetCorrectionSelection()
        removeCorrectionBoundary()
        
        let startTouchRectangle = CGRect(x: startTouchPoint.x, y: startTouchPoint.y, width: 1, height: 1)
        let endTouchRectangle = CGRect(x: endTouchPoint.x, y: endTouchPoint.y, width: 1, height: 1)
        
        for correctionSelection in correctionSelectionList {
            if (correctionSelection.path?.boundingBoxOfPath.intersects(startTouchRectangle))! &&
                (correctionSelection.path?.boundingBoxOfPath.intersects(endTouchRectangle))! {
                var correctionBoundary = CAShapeLayer()
                var selectionRect = (correctionSelection.path?.boundingBoxOfPath)!
                var correctionRect = CGRect(x: selectionRect.minX, y: selectionRect.origin.y, width: selectionRect.size.width, height: 3)
                var correctionPath = UIBezierPath(roundedRect: correctionRect, cornerRadius: 0).cgPath
                let arrCorrection = correctionSelection.accessibilityLabel?.components(separatedBy: "-")
                
                correctionBoundary.opacity = 1
                correctionBoundary.path = correctionPath
                correctionBoundary.fillColor = ApplicationConstant.CorrectionBoundaryColor
                
                ApplicationObject.QuranPageImageView.layer.addSublayer(correctionBoundary)
                correctionBoundaryList.append(correctionBoundary)
                
                correctionBoundary = CAShapeLayer()
                selectionRect = (correctionSelection.path?.boundingBoxOfPath)!
                correctionRect = CGRect(x: selectionRect.minX, y: selectionRect.origin.y + selectionRect.size.height - 3, width: selectionRect.size.width, height: 3)
                correctionPath = UIBezierPath(roundedRect: correctionRect, cornerRadius: 0).cgPath
                
                correctionBoundary.opacity = 1
                correctionBoundary.path = correctionPath
                correctionBoundary.fillColor = ApplicationConstant.CorrectionBoundaryColor
                
                ApplicationObject.QuranPageImageView.layer.addSublayer(correctionBoundary)
                ApplicationObject.MainViewController.loadCorrectionDetailView(correctionDetailId: Int32(arrCorrection![0])!, correctionKey: Int32(arrCorrection![1])!)
                correctionBoundaryList.append(correctionBoundary)
            }
        }
    }
    
    static func getAyatSelection(recitationName: String) -> [CAShapeLayer] {
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
