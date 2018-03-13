import UIKit
import DLRadioButton

class TMAvailableReciterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvReciter: UITableView!
    
    var reciterList = [Reciter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reciterList = ReciterRepository().getReciterList()
        tvReciter.delegate = self
        tvReciter.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reciterList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcReciter = tvReciter.dequeueReusableCell(withIdentifier: "tvcReciter") as! ReciterTableViewCell
        
        tvcReciter.lblName.text = reciterList[indexPath.row].Name
        tvcReciter.rbtnSelection.isSelected = false
        tvcReciter.Id = reciterList[indexPath.row].Id
        
        if reciterList[indexPath.row].Id == ApplicationData.CurrentReciter.Id {
            tvcReciter.lblName.backgroundColor = ApplicationConstant.RowSelectionColor
            tvcReciter.rbtnSelection.backgroundColor = ApplicationConstant.RowSelectionColor
            tvcReciter.rbtnSelection.isSelected = true
        }
        else {
            tvcReciter.lblName.backgroundColor = ApplicationConstant.RowColor
            tvcReciter.rbtnSelection.backgroundColor = ApplicationConstant.RowColor
        }
        
        return tvcReciter
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ApplicationData.CurrentReciter = reciterList[indexPath.row]
        
        tvReciter.reloadData()
    }
    
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
