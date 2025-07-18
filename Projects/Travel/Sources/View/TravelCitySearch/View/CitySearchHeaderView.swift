//
//  HeaderView.swift
//  TravelProject
//
//  Created by hwan on 7/15/25.
//

import UIKit
import Combine

final class CitySearchHeaderView: UICollectionReusableView, CellIdentifialble {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var retainSearchField: Bool = false {
        didSet {
            if retainSearchField {
                self.setNeedsDisplay()
            }
        }
    }
    var subscriptions = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.loadXib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscriptions.removeAll()
    }
    
    override func draw(_ rect: CGRect) {
        if retainSearchField {
            searchField.becomeFirstResponder()
        }
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

fileprivate extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
