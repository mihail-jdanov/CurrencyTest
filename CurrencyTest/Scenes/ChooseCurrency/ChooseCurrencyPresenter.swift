//
//  ChooseCurrencyPresenter.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import Foundation

protocol IChooseCurrencyPresenter: AnyObject {
    
    var currencyValues: [String] { get }
    var selectedCurrencyIndex: Int? { get }
    
    init(view: IChooseCurrencyView, model: IChooseCurrencyModel,
         router: IRouter, chooseHandler: ((String) -> Void)?)
    
    func selectCurrency(at index: Int)
    
}

class ChooseCurrencyPresenter: IChooseCurrencyPresenter {
    
    var currencyValues: [String] {
        return model.currencyValues
    }
    
    var selectedCurrencyIndex: Int? {
        guard let currency = model.selectedCurrency else { return nil }
        return model.currencyValues.firstIndex(of: currency)
    }
    
    private let model: IChooseCurrencyModel
    private let router: IRouter
    private let chooseHandler: ((String) -> Void)?
    
    private weak var view: IChooseCurrencyView?
    
    required init(view: IChooseCurrencyView, model: IChooseCurrencyModel,
                  router: IRouter, chooseHandler: ((String) -> Void)?) {
        self.view = view
        self.model = model
        self.router = router
        self.chooseHandler = chooseHandler
    }
    
    func selectCurrency(at index: Int) {
        chooseHandler?(currencyValues[index])
        router.closeCurrentController()
    }
    
}
