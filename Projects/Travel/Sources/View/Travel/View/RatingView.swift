import UIKit

@IBDesignable
final class RatingView: UIView {

    @IBInspectable var rating: Double = 0.0 {
        didSet {
            updateRating()
        }
    }
    
    @IBInspectable var starSpacing: CGFloat = 2 {
        didSet {
            stackView.spacing = starSpacing
        }
    }
    
    private var starViews: [StarView] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = starSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
    }

    private func configureLayout() {
        for _ in 0..<5 {
            let star = StarView()
            starViews.append(star)
            stackView.addArrangedSubview(star)
        }
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        updateRating()
    }

    private func updateRating() {
        for (index, starView) in starViews.enumerated() {
            let starValue = Double(index + 1)
            
            if rating >= starValue {
                starView.fillPercentage = 1.0
            } else if rating > starValue - 1 {
                starView.fillPercentage = CGFloat(rating - floor(rating))
            } else {
                starView.fillPercentage = 0.0
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureLayout()
    }
}
