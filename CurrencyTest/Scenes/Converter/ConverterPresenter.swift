//
//  ConverterPresenter.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import Foundation

protocol IConverterPresenter: AnyObject {
    
    init(view: IConverterView, model: IConverterModel, router: IRouter)
    
    func setAmount(to value: String)
    func changeFirstCurrency()
    func switchCurrency()
    func changeSecondCurrency()
    
}

class ConverterPresenter: IConverterPresenter {
    
    private let model: IConverterModel
    private let router: IRouter
    
    private weak var view: IConverterView?
    
    private var selectedFirstCurrency: String? {
        didSet {
            view?.setFirstCurrency(selectedFirstCurrency)
        }
    }
    
    required init(view: IConverterView, model: IConverterModel, router: IRouter) {
        self.view = view
        self.model = model
        self.router = router
    }
    
    func setAmount(to value: String) {
        guard let number = Double(value) else { return }
        print(number)
    }
    
    func changeFirstCurrency() {
        let currencyValues = model.getCurrencyList()
        let chooseCurrencyModel = ChooseCurrencyModel(
            currencyValues: currencyValues,
            selectedCurrency: selectedFirstCurrency
        )
        router.presentChooseCurrency(model: chooseCurrencyModel, chooseHandler: { [weak self] currency in
            self?.selectedFirstCurrency = currency
        })
    }
    
    func switchCurrency() {
        
    }
    
    func changeSecondCurrency() {
        
    }
    
}
