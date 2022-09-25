//
//  DecimalNumbersTextField.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 26.09.2022.
//

import UIKit

class DecimalNumbersTextField: UITextField {
    
    override var delegate: UITextFieldDelegate? {
        get {
            return super.delegate
        }
        set {
            print("DecimalNumbersTextField's delegate is used by itself. Unfortunately, you can't change it.")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        super.delegate = self
    }
    
}

extension DecimalNumbersTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let decimalSeparator: String = NumberFormatter().decimalSeparator
        var characterSet = CharacterSet.decimalDigits
        characterSet.insert(charactersIn: decimalSeparator)
        if !string.conforms(to: characterSet) { return false }
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        return newText.numberOfOccurrences(of: .init(decimalSeparator)) < 2
    }
    
}
