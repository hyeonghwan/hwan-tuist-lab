import UIKit
import Kingfisher

protocol VCIdentifiable {
    static var id: String { get }
}
extension VCIdentifiable {
    static var id: String {
        String(describing: Self.self)
    }
}

final class TouristAttractionViewController: UIViewController, VCIdentifiable {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var otherTouristGoButton: UIButton!
    var info: Travel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "관광지 화면"
        
        otherTouristGoButton.addTarget(
            self,
            action: #selector(buttonTapped(_:)),
            for: .touchUpInside
        )
        addLayout()
        
        if let info {
            set(info: info)
        }
    }
    
    func set(info: Travel) {
        if let url = URL(string: info.travel_image ?? "") {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(
              with: url,
              placeholder: nil,
              options: [.transition(.fade(1.2))],
              completionHandler: nil
            )
        } else {
            imageView.image =  ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
        self.titleLabel.text = info.title
        self.descriptionLabel.text = info.description
    }
    
    private func addLayout() {
        self.otherTouristGoButton.layer.cornerRadius = 12
        self.imageView.layer.cornerRadius = 12
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
