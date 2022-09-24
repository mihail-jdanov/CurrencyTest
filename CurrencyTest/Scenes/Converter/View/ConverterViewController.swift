//
//  ConverterViewController.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import UIKit

protocol IConverterView: AnyObject {
    
    func setFirstCurrency(_ currency: String?)
    
}

class ConverterViewController: UIViewController, IConverterView {
    
    var presenter: IConverterPresenter?
    
    @IBOutlet private weak var amountTextField: UITextField!
    @IBOutlet private weak var firstCurrencyButton: UIButton!
    @IBOutlet private weak var secondCurrencyButton: UIButton!
    @IBOutlet private weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Currency converter"
    }
    
    func setFirstCurrency(_ currency: String?) {
        firstCurrencyButton.setTitle(currency ?? "Choose...", for: .normal)
    }

}

// MARK: - IBActions
private extension ConverterViewController {
    
    @IBAction func amountTextFieldAction(_ sender: Any) {
        
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
