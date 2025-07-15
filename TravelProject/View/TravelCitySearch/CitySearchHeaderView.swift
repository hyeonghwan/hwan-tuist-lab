//
//  HeaderView.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import UIKit

final class CitySearchHeaderView: UIView {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXib()
    }
}

extension UIView {
    func loadXib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        guard let customView = nibs?.first as? UIView else { return }
        customView.frame = self.bounds
        self.addSubview(customView)
    }
}
