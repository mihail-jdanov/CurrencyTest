//
//  ConverterViewController.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import UIKit

protocol IConverterView: AnyObject {
        
    func setFirstCurrency(_ currency: String?)
    func setSecondCurrency(_ currency: String?)
    func showResult(_ value: Double?)
    
}

class ConverterViewController: UIViewController, IConverterView {
    
    var presenter: IConverterPresenter?
    
    private let defaultCurrencyButtonTitle = "Choose..."
    
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var firstCurrencyButton: UIButton!
    @IBOutlet private weak var secondCurrencyButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency converter"
    }
    
    func setFirstCurrency(_ currency: String?) {
        firstCurrencyButton.setTitle(currency ?? defaultCurrencyButtonTitle, for: .normal)
        secondCurrencyButton.isEnabled = currency != nil
    }
    
    func setSecondCurrency(_ currency: String?) {
        secondCurrencyButton.setTitle(currency ?? defaultCurrencyButtonTitle, for: .normal)
    }
    
    func showResult(_ value: Double?) {
        guard let value = value else {
            resultLabel.text = " "
            return
        }
        resultLabel.text = "Result: \(value)"
    }

}

// MARK: - IBActions
private extension ConverterViewController {
    
    @IBAction func amountTextFieldAction(_ sender: Any) {
        presenter?.applyAmount(from: amountTextField.text ?? "")
    }
    
    @IBAction func firstCurrencyButtonAction(_ sender: Any) {
        presenter?.changeFirstCurrency()
    }
    
    @IBAction func switchCurrencyButtonAction(_ sender: Any) {
        presenter?.switchCurrency()
    }
    
    @IBAction func secondCurrencyButtonAction(_ sender: Any) {
        presenter?.changeSecondCurrency()
    }
    
}
