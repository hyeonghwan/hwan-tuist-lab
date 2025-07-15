
import UIKit

final class AdViewController: UIViewController, VCIdentifiable {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    var adText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let adText {
            self.descriptionLabel.text = adText
        }
    }
    
    @IBAction func popButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
