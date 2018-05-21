import UIKit

class CorrectionDetailView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvCorrectionDetailComment: UITableView!
    @IBOutlet weak var btnPlayPause: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcCorrectionDetailComment = tvCorrectionDetailComment.dequeueReusableCell(withIdentifier: "tvcCorrectionDetailComment") as! CorrectionDetailCommentTableViewCell
        
        tvcCorrectionDetailComment.lblComment.text = "Test"
        tvcCorrectionDetailComment.vCommentColor.backgroundColor = UIColor.blue
        
        return tvcCorrectionDetailComment
    }
    
    func initializeView() {
        tvCorrectionDetailComment.delegate = self
        tvCorrectionDetailComment.dataSource = self
    }
    func loadView() {
        
    }
    
    @IBAction func btnPlayPause_TouchUp(_ sender: Any) {
        
    }
}
