import UIKit
import Kingfisher

final class TravelCell: UITableViewCell, CellIdentifialble {
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var countingLabel: UILabel!
    @IBOutlet weak var imageContainerVIew: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    var likeAction: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityImageView.layer.cornerRadius = 8
        likeButton.layer.zPosition = 1
        likeButton.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
        likeButton.setImage(ImageGen.heart, for: .normal)
        likeButton.setImage(ImageGen.heartFill, for: .selected)
    }
    
    @objc private func likeTapped(_ sender: UIButton) {
        let origin = likeButton.isSelected
        likeButton.isSelected = !origin
        likeAction?(likeButton.isSelected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cityImageView.image = nil
        self.titleLabel.text = " "
        self.descriptionLabel.text = " "
        self.ratingView.rating = 0
        self.countingLabel.text = nil
        likeButton.isSelected = false
        separatorInset = .zero
    }
    
    func set(info: Travel) {
        let like = info.like ?? false
        likeButton.isSelected = like
        if let url = URL(string: info.travel_image ?? "") {
            cityImageView.kf.indicatorType = .activity
            cityImageView.kf.setImage(
              with: url,
              placeholder: nil,
              options: [.transition(.fade(1.2))],
              completionHandler: nil
            )
        } else {
            cityImageView.image =  ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
        self.titleLabel.text = info.title
        self.descriptionLabel.text = info.description
        self.ratingView.rating = info.grade ?? 0
        let random = info.count.formatted(.number)
        let save = (info.save ?? 0).formatted(.number)
        self.countingLabel.text = "(\(random)) • 저장 \(save)"
    }
}
