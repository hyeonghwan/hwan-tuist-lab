import UIKit

//3) 세번째 탭바 : 369 게임 구현하기
// 1. 텍스트필드에 숫자를 입력 후 엔터를 입력하면, 1부터 입력한 숫자까지 369를 계산합니다.
// 2. 1부터 선택한 숫자까지 UITextView 에 보여줍니다. 숫자와
// 박수가 작성된 회색 레이블이 UITextView 이며, 사용자가 직접 편집을 할 수 없도록 프로퍼티를통해 속성을 조절해주세요.
// 3. 만일 100을 입력한 경우, 1, 2, 3 … 33, 34 … 100 까지 작성이 되어 있으실거에요. 3, 6, 9 숫자가 포함된 숫자들은 👏 로 대체해주세요.
//  ( 예: 33 을 👏 로, 16 을 👏 로 대체 )
// 4. (옵션) 3번에서는 3, 6, 9 숫자가 포함된 숫자들은 전부 👏 로 대체해주었습니다.
//     이제는 3, 6, 9 숫자 만 대체해봅니다 ( 예: 33 은 👏 👏 , 16은 1👏 , 49는 4👏 )
// 5. (옵션) 4번에 작성된 전체 박수의 갯수를 레이블을 통해 표현해주세요.

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
