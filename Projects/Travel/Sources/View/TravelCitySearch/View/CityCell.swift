//
//  CityCell.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//
import UIKit
import Kingfisher

final class CityCell: UITableViewCell, CellIdentifialble {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityListlabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    private var roundedLayer: CAShapeLayer! = nil
    private var shadowLayer: CAShapeLayer! = nil
    private var setLayer: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .systemBackground
        self.cityImageView.clipsToBounds = true
        shadowView.backgroundColor = .clear
        self.sendSubviewToBack(shadowView)
    }
    
    override func draw(_ rect: CGRect) {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            makeShadowLayer(layer: shadowLayer)
            shadowView.layer.insertSublayer(shadowLayer, at: 0)
        }
        
        if roundedLayer == nil {
            roundedLayer = CAShapeLayer()
            let path = UIBezierPath(
                roundedRect: containerView.bounds,
                byRoundingCorners: [.topLeft, .bottomRight],
                cornerRadii: CGSize(width: 25, height: 25)
            )
            roundedLayer.path = path.cgPath
            containerView.layer.mask = roundedLayer
        }
    }
    
    private func makeShadowLayer(layer: CAShapeLayer) {
        layer.name = "Shadow"
        layer.path = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 25).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = layer.path
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityImageView.kf.cancelDownloadTask()
    }
    
    func set(info: City, contains: String?) {
        load(image: info.image)
        labelSetting(info: info, contains: contains)
    }
    
    private func load(image: String) {
        if let url = URL(string: image) {
            let size = CGSize(width: UIScreen.main.bounds.width, height: 200)
            cityImageView.kf.downSizingImage(url: url, size: size)
        } else {
            cityImageView.image =  ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
    }
    
    private func labelSetting(info: City, contains: String?) {
        self.cityNameLabel.attributedText = makeCityName(info: info, contains: contains)
        self.cityListlabel.attributedText = makeCityList(info: info, contains: contains)
    }
    
    private func makeCityName(info: City, contains: String?) -> NSAttributedString {
        if let contains {
            let nameText = NSMutableAttributedString()
            nameText.append(info.name.highlightKeyword(contains))
            nameText.append(NSAttributedString(string: " | "))
            nameText.append(info.enName.highlightKeyword(contains))
            return nameText
        } else {
            return NSAttributedString(string: "\(info.name) | \(info.enName)")
        }
    }
    
    private func makeCityList(info: City, contains: String?) -> NSAttributedString {
        if let contains {
            let listText = NSMutableAttributedString()
            for (index, text) in info.explain.enumerated() {
                listText.append(text.highlightKeyword(contains))
                if index != info.explain.count - 1 {
                    listText.append(.separator)
                }
            }
            return listText
        } else {
            return NSAttributedString(string: info.explain.joined(separator: ", "))
        }
    }
}
