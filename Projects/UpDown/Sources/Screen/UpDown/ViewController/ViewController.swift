//
//  ViewController.swift
//  UpDown
//
//  Created by hwan on 7/18/25.
//  Copyright © 2025 com.hwan. All rights reserved.
//

import UIKit


final class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textField: BottomLayerTextField!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        startButton.addTarget(self, action: #selector(moveToVC(_:)), for: .touchUpInside)
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(textDidChange(_:)),
                name: UITextField.textDidChangeNotification,
                object: textField
            )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc private func moveToVC(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: UpDownGameViewController.id) as! UpDownGameViewController
        let text = textField.text!.replacingOccurrences(of: ",", with: "")
        if let num = Int(text) {
            if num < 1 {
                showAlert(title: "Limit", message: "0보다 큰 값이여야 합니다.")
                return
            }
            vc.items = (1...num).map { $0 }
            self.textField.text = ""
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            showAlert(title: "입력", message: "숫자만 입력해 주세요")
        }
    }
    
    @objc
    private func textDidChange(_ notification: Notification) {
        guard
            let textField = notification.object as? UITextField,
            let number = maxDigit(textField)
        else {
            return
        }
        let text = number.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else {
            textField.text = ""
            return
        }
        textField.text = number.formattedNumber()
    }
    
    private func maxDigit(_ textField: UITextField) -> String? {
        let maxLength = 5
        let text = textField.text!.replacingOccurrences(of: ",", with: "")
        if text.count > maxLength {
            textField.resignFirstResponder()
            if text.count >= maxLength {
                let index = text.index(text.startIndex, offsetBy: maxLength)
                let newString = text[text.startIndex..<index]
                return String(newString)
            }
            return nil
        } else {
            return text
        }
    }
    
    @IBAction func keyboardDismiss(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func configureLayout() {
         let awayFromTopConstraints = [
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
         ]
         view.keyboardLayoutGuide.setConstraints(awayFromTopConstraints, activeWhenAwayFrom: .top)
    }
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension Numeric {
    func formattedNumber() -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "en_US")
        
        guard let nsNumber = self as? NSNumber,
              let formatted = numberFormatter.string(from: nsNumber) else {
            return nil
        }
        
        return formatted
    }
}
