import UIKit

class UCDropDownViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var uiPickerView: UIPickerView!
    
    var delegate: ModalDialogueProtocol!
    var dataList = [BaseModel]()
    var selectedValue: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiPickerView.dataSource = self
        self.uiPickerView.delegate = self
        
        if self.presentingViewController is ModalDialogueProtocol {
            self.delegate = self.presentingViewController as! ModalDialogueProtocol
        }
        else {
            for child in (self.presentingViewController?.childViewControllers)! {
                if child is ModalDialogueProtocol {
                    self.delegate = child as! ModalDialogueProtocol
                    
                    break
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        let index = dataList.index(where: { item in
            item.Id == selectedValue
        })
        
        if index != nil {
            self.uiPickerView.selectRow(index!, inComponent: 0, animated: false)
        }
        else if dataList.count > 0 {
            selectedValue = dataList[0].Id
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row].Name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = dataList[row].Id
    }
    
    @IBAction func btnDone_TouchUp(_ sender: Any) {
        self.delegate?.onDoneHandler(Id: selectedValue)
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancel_TouchUp(_ sender: Any) {
        self.delegate?.onCancelHandler?()
        
        self.dismiss(animated: true, completion: nil)
    }
}
