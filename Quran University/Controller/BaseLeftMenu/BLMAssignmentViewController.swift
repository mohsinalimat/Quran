import UIKit

class BLMAssignmentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let tvcReciter = tvReciter.dequeueReusableCell(withIdentifier: "tvcReciter") as! ReciterTableViewCell
//
//        tvcReciter.lblName.text = reciterList[indexPath.row].Name
//        tvcReciter.rbtnSelection.isSelected = false
//        tvcReciter.Id = reciterList[indexPath.row].Id
//
//        if reciterList[indexPath.row].Id == ApplicationData.CurrentReciter.Id {
//            tvcReciter.lblName.backgroundColor = ApplicationConstant.RowSelectionColor
//            tvcReciter.rbtnSelection.backgroundColor = ApplicationConstant.RowSelectionColor
//            tvcReciter.rbtnSelection.isSelected = true
//        }
//        else {
//            tvcReciter.lblName.backgroundColor = ApplicationConstant.RowColor
//            tvcReciter.rbtnSelection.backgroundColor = ApplicationConstant.RowColor
//        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        ApplicationData.CurrentReciter = reciterList[indexPath.row]
//
//        tvReciter.reloadData()
    }
}
