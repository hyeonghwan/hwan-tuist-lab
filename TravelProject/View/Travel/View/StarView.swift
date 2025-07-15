import UIKit

final class StarView: UIView {

    var fillPercentage: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    private let emptyStarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = ImageGen.starFill
        iv.tintColor = .lightGray
        return iv
    }()

    private let filledStarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = ImageGen.starFill
        iv.tintColor = .systemYellow
        return iv
    }()
    
    private let fillMaskLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        self.addSubview(emptyStarImageView)
        self.addSubview(filledStarImageView)
        fillMaskLayer.backgroundColor = UIColor.white.cgColor
        filledStarImageView.layer.mask = fillMaskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emptyStarImageView.frame = bounds
        filledStarImageView.frame = bounds
        let maskWidth = bounds.width * fillPercentage
        fillMaskLayer.frame = CGRect(x: 0, y: 0, width: maskWidth, height: bounds.height)
    }
}
