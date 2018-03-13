import UIKit

class UCDualDropDownViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var uiPrimaryPickerView: UIPickerView!
    @IBOutlet weak var uiSecondaryPickerView: UIPickerView!
    
    var delegate: ModalDialogueProtocol!
    var primaryDataList = [BaseModel]()
    var secondaryDataList = [BaseModel]()
    var primaryValue: Int64 = 0
    var secondaryValue: Int64 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiPrimaryPickerView.dataSource = self
        self.uiSecondaryPickerView.dataSource = self
        self.uiPrimaryPickerView.delegate = self
        self.uiSecondaryPickerView.delegate = self
        
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
        let primaryIndex = primaryDataList.index(where: { item in
            item.Id == primaryValue
        })
        let secondaryIndex = secondaryDataList.index(where: { item in
            item.Id == secondaryValue
        })
        
        if primaryIndex != nil {
            self.uiPrimaryPickerView.selectRow(primaryIndex!, inComponent: 0, animated: false)
        }
        else if primaryDataList.count > 0 {
            primaryValue = primaryDataList[0].Id
        }
        
        if secondaryIndex != nil {
            self.uiSecondaryPickerView.selectRow(secondaryIndex!, inComponent: 0, animated: false)
        }
        else if secondaryDataList.count > 0 {
            secondaryValue = secondaryDataList[0].Id
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == uiPrimaryPickerView {
            return primaryDataList.count
        }
        else if pickerView == uiSecondaryPickerView {
            return secondaryDataList.count
        }
        
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == uiPrimaryPickerView {
            return primaryDataList[row].Name
        }
        else if pickerView == uiSecondaryPickerView {
            return secondaryDataList[row].Name
        }
        
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == uiPrimaryPickerView {
            primaryValue = primaryDataList[row].Id
            
            let valueToMatch = ((primaryValue / 100) <= 0 ? 1 : (primaryValue / 100)) * 100
            
            for i in 1...secondaryDataList.count {
                let index = (i - 1)
                
                if valueToMatch == secondaryDataList[index].Id {
                    secondaryValue = secondaryDataList[index].Id
                    
                    self.uiSecondaryPickerView.selectRow(index, inComponent: 0, animated: false)
                    
                    break
                }
            }
        }
        else if pickerView == uiSecondaryPickerView {
            secondaryValue = secondaryDataList[row].Id
            
            let index = primaryDataList.index(where: { item in
                item.Id == (secondaryValue + 1)
            })
            
            if index != nil {
                primaryValue = primaryDataList[index!].Id
                
                self.uiPrimaryPickerView.selectRow(index!, inComponent: 0, animated: false)
            }
        }
    }
    
    @IBAction func btnDone_TouchUp(_ sender: Any) {
        self.delegate?.onDoneHandler?(PriId: primaryValue, SecId: secondaryValue)
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnCancel_TouchUp(_ sender: Any) {
        self.delegate?.onCancelHandler?()
        
        self.dismiss(animated: true, completion: nil)
    }
}
