import Foundation
import UIKit

class AssignmentManager {
    typealias methodHandler1 = () -> Void
    
    static var assignmentList = [Assignment]()
    static var dataTask: URLSessionDataTask?
    
    static func populateStudentAssignment(completionHandler: @escaping methodHandler1) {
        dataTask = URLSession.shared.dataTask(with: QuranLink.Assignment()) { (data, response, err) in
            let response = response as? HTTPURLResponse

            if err == nil && response?.statusCode == 200 {
                do {
//                    let jsonString = String(data: data!, encoding: .utf8)
                    let response = try JSONDecoder().decode(JsonResponse.self, from: data!)
                    let dateFormatter = DateFormatter()
                    var filterAssignmentList = [Assignment]()
                    
                    assignmentList = [Assignment]()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    
                    for objCourse in response.Course! {
                        for objAssignment in objCourse.Assignment! {
                            var assignmentCurrentStatus = ""
                            var assignmentStatusId = AssignmentStatus.Accepted
                
                            objAssignment.Correction.sort(by: { $0.Id < $1.Id }) // .sort(sort_by('Id', false, parseInt)
                
                            if objAssignment.IsMarked {
                                assignmentCurrentStatus = ApplicationLabel.ACCEPTED
                                assignmentStatusId = AssignmentStatus.Accepted
                            }
                            else if !objAssignment.IsMarked {
                                if objAssignment.StudentOnlineSubmissionDate == nil && objAssignment.StudentSubmissionDate == nil {
                                    if dateFormatter.date(from: objAssignment.DeadlineDate)! < Date() {
                                        assignmentCurrentStatus = ApplicationLabel.LATE
                                        assignmentStatusId = AssignmentStatus.Late
                                    }
                                    else {
                                        assignmentCurrentStatus = ApplicationLabel.DUE
                                        assignmentStatusId = AssignmentStatus.Due
                                    }
                                }
                                else if objAssignment.StudentOnlineSubmissionDate == nil && objAssignment.StudentSubmissionDate != nil {
                                    assignmentCurrentStatus = ApplicationLabel.NOTSENT
                                    assignmentStatusId = AssignmentStatus.NotSent
                                }
                                else if objAssignment.StudentOnlineSubmissionDate != nil && objAssignment.StudentSubmissionDate != nil {
                                    if objAssignment.Correction.count == 0 {
                                        assignmentCurrentStatus = ApplicationLabel.SUBMITTED
                                        assignmentStatusId = AssignmentStatus.Submitted
                                    }
                                    else if objAssignment.Correction.count > 0 {
                                        let latestCorrection = objAssignment.Correction[objAssignment.Correction.count - 1];
                
                                        if objAssignment.Correction.count == 1 {
                                            if objAssignment.Correction[0].StudentOnlineSubmissionDate == nil {
                                                assignmentCurrentStatus = ApplicationLabel.CHECKED
                                                assignmentStatusId = AssignmentStatus.Checked
                                            }
                                            else if objAssignment.Correction[0].StudentOnlineSubmissionDate != nil {
                                                assignmentCurrentStatus = ApplicationLabel.RESUBMITTED
                                                assignmentStatusId = AssignmentStatus.Resubmitted
                                            }
                                        }
                                        else if objAssignment.Correction.count > 1 {
                                            if latestCorrection.StudentOnlineSubmissionDate != nil {
                                                assignmentCurrentStatus = ApplicationLabel.RESUBMITTED
                                                assignmentStatusId = AssignmentStatus.Resubmitted
                                            }
                                            else if latestCorrection.StudentOnlineSubmissionDate == nil {
                                                assignmentCurrentStatus = ApplicationLabel.RECHECKED
                                                assignmentStatusId = AssignmentStatus.Rechecked
                                            }
                                        }
                                    }
                                }
                            }
                    
                            let addRow = true
        //
        //            if (applyfilter !== undefined && applyfilter) {
        //                var chkBoxes = $('#dvAssignmentListing input:checked');
        //
        //                if (chkBoxes.length > 0) {
        //                    addRow = false;
        //
        //                    $('#dvAssignmentListing input:checked').each(function () {
        //                        var assignmentStatusId = parseInt($(this).attr('value'));
        //
        //                        if (assignStatus === assignmentStatusId) {
        //                            addRow = true;
        //
        //                            return false;
        //                        }
        //                    });
        //                }
        //            }
        //
                            if addRow {
                                objAssignment.AssignmentCurrentStatusTitle = assignmentCurrentStatus
                                objAssignment.AssignmentStatusId = assignmentStatusId.rawValue
                                objAssignment.DeadlineDateValue = dateFormatter.date(from: objAssignment.DeadlineDate)
                                objAssignment.CourseInfoId = objCourse.CourseInfoId
                                objAssignment.CourseTitle = objCourse.Title

                                objAssignment.Correction.sort(by: { $0.Id > $1.Id }) // sort_by('Id', true, parseInt)

                                filterAssignmentList.append(objAssignment)
                            }
                        }
                    }
                    
                    //var count = filterAssignmentList.count
                    
                    assignmentList = filterAssignmentList.sorted(by: { $0.DeadlineDateValue! > $1.DeadlineDateValue! }) // sort_by('DeadlineDateValue', true)

//                    for objAssignment in filterAssignmentList {
//        var assignmentObj1 = lstFilteredAssignment[k];
//        var pageId = assignmentObj1.AssignmentAyat[0].PageNo;
//        var correctionId = (assignmentObj1.Correction.length === 0 ? 0 : assignmentObj1.Correction[0].Id);
//        var row = $('#tmplAssigmentAccordion', '#dvTemplates').clone();
//        var deadlineDate = assignmentObj1.DeadlineDate;
//        var studentOnlineSubmissionDate = assignmentObj1.StudentOnlineSubmissionDate;
//        var ayatID = [];
//        var ayatAudioName = [];
//
//        if (assignmentObj1.Correction.length > 1) {
//            deadlineDate = assignmentObj1.Correction[1].DeadLineDate;
//            studentOnlineSubmissionDate = assignmentObj1.Correction[1].StudentOnlineSubmissionDate;
//        }
//
//        $(assignmentObj1.AssignmentAyat).each(function (index, value) {
//            ayatID.push(value.Id);
//            ayatAudioName.push(value.AudioFileName);
//        });
//
//        var assignmentTitle = (languageMode === "arabic" ? assignmentObj1.titleSLang : assignmentObj1.titlePLang);
//        var assignmentType = (languageMode === "arabic" ? assignmentObj1.AssignmentTypeSLang : assignmentObj1.AssignmentType);
//        var assignNumber = (count > 9 ? count : ("0" + count));
//
//        assignmentTitle = (assignmentTitle === "" ? "N/A" : assignmentTitle);
//        assignmentType = (assignmentType === "" ? "N/A" : assignmentType);
//
//        $('h3', row)
//            .attr('id', 'assignStatusId-' + assignmentObj1.AssignStatusId)
//            .html("<span class='assignmentNumber'>" + assignNumber + "</span>" + assignmentTitle);
//        $('#spnType', row).html(assignmentType);
//        $('#spnStatus', row).html(assignmentObj1.AssignmentCurrentStatusTitle);
//        $('#spnDeadline', row).html((deadlineDate === null ? "-" : new Date(deadlineDate).format("mediumDate")));
//        $('#spnSubmittedDate', row).html((studentOnlineSubmissionDate === null ? "-" : new Date(studentOnlineSubmissionDate).format("mediumDate")));
//        $('#spnDelayDays', row).html(assignmentObj1.DelayedDaysString);
//        $('#spnMarks', row).html((assignmentObj1.IsMarked ? assignmentObj1.Marks : "-"));
//        $('#lnkView', row)
//            .attr('pageId', pageId)
//            .attr('ayatID', ayatID)
//            .attr('ayatAudioName', ayatAudioName)
//            .attr('assignmentId', assignmentObj1.classAssignmentStudentId)
//            .attr('courseId', assignmentObj1.CourseId)
//            .attr('studentId', localStorage.getItem("loginUserId"))
//            .attr('correctionId', correctionId)
//            .attr('onclick', 'saveAssignmentDataToLocalStorage(this, ' + assignmentObj1.classAssignmentStudentId + ',' + assignmentObj1.CourseInfoId + ',' + localStorage.getItem("loginUserId") + ',' + correctionId + ');');
//
//
//
//        count = count - 1
//    }
                }
                catch {
                    print("Error: \(error).")
                }
            }
            
            completionHandler()
        }

        dataTask?.resume()
    }
}
