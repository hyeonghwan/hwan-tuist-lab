import UIKit

final class AddPurcasedCell: UITableViewCell, CellIdentifialble {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var action: ((String) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        addButton.addTarget(self, action: #selector(addItem(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    private func configureLayout() {
        self.contentView.backgroundColor = .systemGray6
        self.contentView.layer.cornerRadius = 8
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        submit()
    }
    
    @objc private func addItem(_ sender: UIButton) {
        submit()
    }
    
    private func submit() {
        let text = textField.text!
        textField.text = ""
        action?(text)
    }
}
