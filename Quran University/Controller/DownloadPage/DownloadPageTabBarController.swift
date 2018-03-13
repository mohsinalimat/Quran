import UIKit

class DownloadPageTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.selectedIndex = ApplicationData.CurrentDownloadPageMode
    }
}
