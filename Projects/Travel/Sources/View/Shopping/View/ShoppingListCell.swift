import UIKit


final class ShoppingListCell: UITableViewCell, CellIdentifialble {
    
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    var indexPath: IndexPath?
    var checkAction: ((IndexPath?, Bool) -> Void)?
    var favoriteAction: ((IndexPath?, Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addLayout()
        checkButton.addTarget(self, action: #selector(checkButtonTapped(_:)), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8))
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkButton.isSelected = false
        self.startButton.isSelected = false
        self.contentLabel.text = ""
        self.indexPath = nil
        self.checkAction = nil
        self.favoriteAction = nil
        self.contentView.isHidden = false
    }
    
    @objc private func checkButtonTapped(_ sender: UIButton) {
        let origin = sender.isSelected
        sender.isSelected = !origin
        checkAction?(indexPath, !origin)
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let origin = sender.isSelected
        sender.isSelected = !origin
        favoriteAction?(indexPath, !origin)
    }
    
    private func addLayout() {
        self.contentView.backgroundColor = .systemGray6
        self.contentView.layer.cornerRadius = 8
        
        checkButton.setImage(ImageGen.checkFill, for: .selected)
        checkButton.setImage(ImageGen.check, for: .normal)
        checkButton.setBackgroundColor(.red, for: .selected)
        
        startButton.setImage(ImageGen.starFill, for: .selected)
        startButton.setImage(ImageGen.star, for: .normal)
        startButton.setBackgroundColor(.red, for: .selected)
    }
    
    func changeState(_ isCheck: Bool, _ isStar: Bool, _ content: String) {
        checkButton.isSelected = isCheck
        startButton.isSelected = isStar
        contentLabel.text = content
    }
}

private extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 44, height: 44))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 44, height: 44))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
