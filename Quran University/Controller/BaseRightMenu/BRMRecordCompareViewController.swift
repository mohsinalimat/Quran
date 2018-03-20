import UIKit
import ASWaveformPlayerView

class BRMRecordCompareViewController: BaseViewController {
    @IBOutlet weak var vMicrophone: UIView!
    @IBOutlet weak var vAyat: UIView!
    
    var ayatWaveform: ASWaveformPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAyat()
    }
    
    func loadAyat() {
        do {
            ayatWaveform = try ASWaveformPlayerView(audioURL: RecitationManager.getCurrentRecitationFileURL(),
                                                    sampleCount: 1024,
                                                    amplificationFactor: 2500)
            
            ayatWaveform?.normalColor = .lightGray
            ayatWaveform?.progressColor = .orange
            ayatWaveform?.allowSpacing = false
            ayatWaveform?.translatesAutoresizingMaskIntoConstraints = false
            
            vAyat.addSubview(ayatWaveform!)
            
            NSLayoutConstraint.activate([ayatWaveform!.centerXAnchor.constraint(equalTo: vAyat.centerXAnchor),
                                         ayatWaveform!.centerYAnchor.constraint(equalTo: vAyat.centerYAnchor),
                                         ayatWaveform!.heightAnchor.constraint(equalToConstant: 128),
                                         ayatWaveform!.leadingAnchor.constraint(equalTo: vAyat.leadingAnchor),
                                         ayatWaveform!.trailingAnchor.constraint(equalTo: vAyat.trailingAnchor)])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func btnPlayAyat_TouchUp(_ sender: Any) {
        //loadAyat()
        ayatWaveform?.audioPlayer.play()
    }
}
