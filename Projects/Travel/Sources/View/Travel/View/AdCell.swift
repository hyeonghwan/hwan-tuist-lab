import UIKit

final class AdCell: UITableViewCell, CellIdentifialble {
    
    @IBOutlet weak var adTopRight: UIButton!
    @IBOutlet weak var adLabel: UILabel!
    @IBOutlet weak var containerVIew: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        adTopRight.layer.cornerRadius = 8
        containerVIew.layer.cornerRadius = 8
    }
    
    func set(info: Travel) {
        self.adLabel.text = info.title
        self.containerVIew.backgroundColor = [UIColor.red, UIColor.green, UIColor.systemPink, UIColor.yellow, UIColor.purple].randomElement()!.withAlphaComponent(0.3)
    }
}
