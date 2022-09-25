//
//  ConverterPresenter.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import Foundation

protocol IConverterPresenter: AnyObject {
    
    init(view: IConverterView, model: IConverterModel, router: IRouter)
    
    func changeFirstCurrency()
    func switchCurrency()
    func changeSecondCurrency()
    func applyAmount(from string: String)
    
}

class ConverterPresenter: IConverterPresenter {
    
    private let model: IConverterModel
    private let router: IRouter
    
    private weak var view: IConverterView?
    
    private var lastAmount = ""
    
    private var selectedFirstCurrency: String? {
        didSet {
            view?.setFirstCurrency(selectedFirstCurrency)
            applyAmount(from: lastAmount)
            if selectedFirstCurrency != oldValue {
                selectedSecondCurrency = nil
            }
        }
    }
    
    private var selectedSecondCurrency: String? {
        didSet {
            view?.setSecondCurrency(selectedSecondCurrency)
            applyAmount(from: lastAmount)
        }
    }
    
    required init(view: IConverterView, model: IConverterModel, router: IRouter) {
        self.view = view
        self.model = model
        self.router = router
        startDataFetch()
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
        guard selectedFirstCurrency != nil, selectedSecondCurrency != nil else { return }
        let temp = selectedFirstCurrency
        selectedFirstCurrency = selectedSecondCurrency
        selectedSecondCurrency = temp
    }
    
    func changeSecondCurrency() {
        guard let currency = selectedFirstCurrency else { return }
        let currencyValues = model.getCurrencyList(compatibleWith: currency)
        let chooseCurrencyModel = ChooseCurrencyModel(
            currencyValues: currencyValues,
            selectedCurrency: selectedSecondCurrency
        )
        router.presentChooseCurrency(model: chooseCurrencyModel, chooseHandler: { [weak self] currency in
            self?.selectedSecondCurrency = currency
        })
    }
    
    func applyAmount(from string: String) {
        lastAmount = string
        guard let doubleValue = NumberFormatter().number(from: string)?.doubleValue,
              let firstCurrency = selectedFirstCurrency, let secondCurrency = selectedSecondCurrency else {
            view?.showResult(nil)
            return
        }
        let result = model.convert(value: doubleValue, ofCurrency: firstCurrency, toCurrency: secondCurrency)
        let resultString = String(format: "%.3f", locale: Locale.current, result)
        view?.showResult(resultString)
    }
    
    private func startDataFetch() {
        router.presentLoader(animated: false)
        model.startCurrencyFetch(completion: { errors in
            if errors.isEmpty {
                self.router.dismissLoader(animated: true)
            } else {
                var errorTexts = (errors as [NSError]).map { $0.localizedDescription + " (\($0.code))" }
                errorTexts = Array(Set(errorTexts))
                let closeHandler = !self.model.isSavedDataAvailable ? nil : {
                    self.router.dismissLoader(animated: true)
                }
                self.router.presentFetchFailedAlert(
                    errorText: errorTexts.joined(separator: "\n"),
                    retryHandler: {
                        self.startDataFetch()
                    },
                    closeHandler: closeHandler
                )
            }
        })
    }
    
}
