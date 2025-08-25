

import UIKit
import Kingfisher

final class MagazineCell: UITableViewCell, CellIdentifialble {
    @IBOutlet weak var titleImageVIew: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleImageVIew.layer.cornerRadius = 12
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleImageVIew.image = nil
        self.title.text = nil
        self.subTitle.text = nil
        self.date.text = nil
    }
    
    
    func set(info: Magazine) {
        if let url = URL(string: info.photoImage) {
            let size = CGSize(width: UIScreen.main.bounds.width, height: 200)
            titleImageVIew.kf.downSizingImage(url: url, size: size)
        } else {
            titleImageVIew.image = ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
        
        self.title.text = info.title
        self.subTitle.text = info.subTitle
        self.date.text = info.date.toFormatted()
    }
}
