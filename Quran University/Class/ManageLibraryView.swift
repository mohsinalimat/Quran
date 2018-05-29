import UIKit

class ManageLibraryView: UIView, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tvLibraryBook: UITableView!
    
    var currentLibraryBookMode = LibraryBookMode.Tafseer
    var count = 0
    
    func initializeView() {
        tvLibraryBook.delegate = self
        tvLibraryBook.dataSource = self
    }
    func loadView(libraryBookMode: LibraryBookMode) {
        currentLibraryBookMode = libraryBookMode
        
        tvLibraryBook.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentLibraryBookMode {
        case .Tafseer:
            count = ApplicationData.TafseerBookList.count
            
            break
        case .Translation:
            count = ApplicationData.TranslationBookList.count
            
            break
        case .WordMeaning:
            count = ApplicationData.WordMeaningBookList.count
            
            break
        case .CauseOfRevelation:
            count = ApplicationData.CauseOfRevelationBookList.count
            
            break
        default:
            count = 0
            
            break
        }
        
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tvcLibraryBook = tvLibraryBook.dequeueReusableCell(withIdentifier: "tvcLibraryBook") as! LibraryBookTableViewCell
        
        switch currentLibraryBookMode {
        case .Tafseer:
            let objTafseerBook = ApplicationData.TafseerBookList[indexPath.row]
            let objLanguage = LanguageRepository().getLanguage(Id: objTafseerBook.LanguageId)
            
            tvcLibraryBook.lblBook.text = ApplicationLabel.LANGUAGE + ": " + objLanguage.Name + ", " + ApplicationLabel.BOOK + ": " + objTafseerBook.Name
            tvcLibraryBook.lblAyat.text = """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec non felis mi. Nullam et sagittis velit. Nunc vulputate sollicitudin dui sed aliquet. Aenean ut arcu iaculis, euismod libero ut, porttitor nisi. Integer ac lobortis erat, ut mollis lectus. Aliquam et libero dui. Proin sit amet eros non neque pharetra dapibus in in orci. Donec et quam molestie, tincidunt sem eu, molestie ante. Suspendisse at vulputate ipsum. Phasellus convallis lorem quis erat pellentesque, lacinia maximus metus rutrum. Nunc vitae dui ullamcorper, pulvinar nisl porta, volutpat odio.
            """
            
            break
        case .Translation:
            tvcLibraryBook.lblBook.text = "Book 1"
            tvcLibraryBook.lblAyat.text = """
            Sed ut magna vel arcu gravida tincidunt eget et quam. Etiam molestie eros vitae sapien varius, pretium aliquam elit luctus. Praesent faucibus justo eros, nec sagittis urna tempor in. In hac habitasse platea dictumst. Morbi quis ipsum quis metus vulputate volutpat. Sed suscipit egestas mollis. Duis ut arcu tincidunt, finibus sem ut, sollicitudin ipsum.
            """
            
            break
        case .WordMeaning:
            tvcLibraryBook.lblBook.text = "Book 1"
            tvcLibraryBook.lblAyat.text = """
            Mauris non quam in urna porttitor sodales. Pellentesque varius, est ac luctus pretium, nunc quam dapibus lorem, quis auctor tellus tellus eu mi. Pellentesque quis nisi quis lacus porta mollis. Pellentesque finibus lacus nec rhoncus pretium. Maecenas vitae urna sit amet purus iaculis suscipit ut quis lacus. In tempor arcu quis eros efficitur vestibulum. Mauris id mauris ut quam sollicitudin bibendum eu vel sapien. Integer malesuada sem nec sem elementum, non facilisis nunc porta. Morbi a risus ut erat euismod gravida in ac felis. Fusce feugiat ex sit amet erat sagittis imperdiet. Ut aliquet ornare massa in bibendum. Praesent lorem dui, convallis id quam vel, commodo consectetur eros. Sed sed tempor quam. Proin gravida rhoncus sapien, eu luctus urna pharetra ut. Nunc a ex in tellus convallis cursus.
            """
            
            break
        case .CauseOfRevelation:
            tvcLibraryBook.lblBook.text = "Book 1"
            tvcLibraryBook.lblAyat.text = """
            Praesent vestibulum ornare semper. Phasellus vel sagittis justo. Mauris sed porta est. Sed efficitur, leo in sodales venenatis, mauris mi mollis elit, in lobortis velit velit ut lacus. Etiam interdum tincidunt condimentum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Etiam id sem scelerisque, maximus arcu id, bibendum libero.
            """
            
            break
        default:
            tvcLibraryBook.lblBook.text = ""
            tvcLibraryBook.lblAyat.text = ""
            
            break
        }
        
        return tvcLibraryBook
    }
}
