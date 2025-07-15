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
    private var shadowLayer: CAShapeLayer? = nil
    private var setLayer: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .clear
        self.cityImageView.clipsToBounds = true
        shadowView.backgroundColor = .clear
        self.sendSubviewToBack(shadowView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if setLayer == true && shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer?.name = "Shadow"
            makeShadowLayer(layer: shadowLayer!)
            shadowView.layer.insertSublayer(shadowLayer!, at: 0)
        }
    }
    
    private func makeShadowLayer(layer: CAShapeLayer) {
        layer.path = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 25).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowPath = layer.path
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shadowLayer = nil
        cityImageView.kf.cancelDownloadTask()
        setLayer = false
        for sublayer in shadowView.layer.sublayers ?? [] where sublayer.name == "Shadow" {
            sublayer.removeFromSuperlayer()
        }
    }
    
    func set(info: City, prefix: String?) {
        if let url = URL(string: info.image) {
            cityImageView.kf.indicatorType = .activity
            cityImageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.fade(0.3))],
                completionHandler: { [weak self] result in
                    if case .success = result {
                        self?.setLayer = true
                        self?.setNeedsLayout()
                        self?.layoutIfNeeded()
                    }
                }
            )
        } else {
            cityImageView.image =  ImageGen.clockwise?
                .withTintColor(
                    .gray,
                    renderingMode: .alwaysOriginal
                )
        }
        self.cityNameLabel.text = "\(info.name) | \(info.enName)"
        self.cityListlabel.text = info.explain
    }
}
