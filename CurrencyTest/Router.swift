//
//  Router.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 25.09.2022.
//

import UIKit

protocol IRouter: AnyObject {
    
    var navigationController: UINavigationController? { get }
    
    func presentInitial()
    func presentChooseCurrency(model: IChooseCurrencyModel, chooseHandler: ((String) -> Void)?)
    func closeCurrentController()
    
}

class Router: IRouter {
    
    let navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentInitial() {
        let viewController = ConverterViewController()
        let model = ConverterModel()
        let presenter = ConverterPresenter(view: viewController, model: model, router: self)
        viewController.presenter = presenter
        navigationController?.viewControllers = [viewController]
    }
    
    func presentChooseCurrency(model: IChooseCurrencyModel, chooseHandler: ((String) -> Void)?) {
        let viewController = ChooseCurrencyViewController()
        let presenter = ChooseCurrencyPresenter(
            view: viewController,
            model: model,
            router: self,
            chooseHandler: chooseHandler
        )
        viewController.presenter = presenter
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func closeCurrentController() {
        navigationController?.popViewController(animated: true)
    }
    
}
