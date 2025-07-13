import UIKit

final class ThreeSixNineViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countlabel: UILabel!
    
    private let digitFormatter = DigitFormatter(map: ["3" : "👏", "6": "👏", "9": "👏"])
    private var current: Int = 0
    private var count = 0 {
        didSet {
            countlabel.text = "박수: \(self.count)개"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        self.textField.delegate = self
        countlabel.text = "박수: 0개"
    }
    
    @IBAction func keyboardDismiss(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    private func submit() {
        var current = current
        let origin = textField.text ?? "-1"
        
        textField.text = nil
        
        if current + 1 == Int(origin) ?? 0 {
            current += 1
            self.current = current
            
            appendString()
            
            if current == 100 {
                gameEnd()
            }
        } else {
            let controller = alert("땡", "틀렸습니다.!~")
                .retry(clearAction())
                .`continue`()
            present(controller, animated: true)
        }
    }
    
    private func appendString() {
        if self.textView.text.isEmpty {
            self.textView.text.append(contentsOf: "\(current)")
        } else {
            let array = digitFormatter.format(current)
            self.count += array.filter { "👏" == $0 }.count
            self.textView.text.append(contentsOf: ", \(array.joined())")
        }
    }
    
    func clearAction() -> ((UIAlertAction) -> Void) {
        return { [weak self] action in
            self?.textView.text = ""
            self?.current = 0
            self?.count = 0
        }
    }
    
    private func gameEnd() {
        let controller = alert("끝까지 깸", "추카")
            .clear(clearAction())
        
        present(controller, animated: true)
    }
}

extension ThreeSixNineViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
}

extension UIViewController {
    func alert(_ title: String, _ message: String) -> UIAlertController {
        UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
    }
}

extension UIAlertController {

    func ok(_ action: @escaping (UIAlertAction) -> Void) -> Self {
        self.addAction(
            UIAlertAction(
                title: "확인",
                style: .default,
                handler: action
            )
        )
        return self
    }
    
    func retry(_ action: @escaping (UIAlertAction) -> Void) -> Self {
        self.addAction(
            UIAlertAction(
                title: "다시하기",
                style: .default,
                handler: action
            )
        )
        return self
    }
    
    func `continue`() -> Self {
        self.addAction(
            UIAlertAction(
                title: "계속하기",
                style: .default)
        )
        return self
    }
    
    func clear(_ action: @escaping (UIAlertAction) -> Void) -> Self {
        self.addAction(
            UIAlertAction(
                title: "확인",
                style: .default,
                handler: action
            )
        )
        return self
    }
}
