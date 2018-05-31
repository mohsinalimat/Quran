import UIKit

class BRMMyAyatNoteViewController: BaseViewController {
    @IBOutlet weak var txtAyatNote: UITextView!
    @IBOutlet weak var btnDelete: QUButton!
    
    let objRecitation = RecitationManager.getRecitation(recitationIndex: RecitationManager.currentRecitationIndex)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let objMyAyatNote = MyAyatNoteRepository().getMyAyatNote(surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
        
        txtAyatNote.text = objMyAyatNote.AyatNote
    }
    
    @IBAction func btnSave_TouchUp(_ sender: Any) {
        let objMyAyatNote = MyAyatNote()
        
        objMyAyatNote.AyatId = objRecitation.AyatId
        objMyAyatNote.SurahId = objRecitation.SurahId
        objMyAyatNote.AyatNote = txtAyatNote.text
        
        let status = MyAyatNoteRepository().saveMyAyatNote(myAyatNoteObject: objMyAyatNote)
        
        if status {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnDelete_TouchUp(_ sender: Any) {
        let status = MyAyatNoteRepository().deleteMyAyatNote(surahId: objRecitation.SurahId, ayatId: objRecitation.AyatId)
        
        if status {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func btnTopClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClose_TouchUp(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
