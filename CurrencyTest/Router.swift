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
    func presentLoader(animated: Bool)
    func dismissLoader(animated: Bool)
    func presentFetchFailedAlert(errorText: String, retryHandler: (() -> Void)?, closeHandler: (() -> Void)?)
    
}

class Router: IRouter {
    
    let navigationController: UINavigationController?
    
    private var presentedLoader: UIViewController?
    
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
    
    func presentLoader(animated: Bool) {
        DispatchQueue.main.async {
            guard self.presentedLoader == nil else { return }
            let viewController = LoaderViewController()
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.present(viewController, animated: animated, completion: nil)
            self.presentedLoader = viewController
        }
    }
    
    func dismissLoader(animated: Bool) {
        DispatchQueue.main.async {
            self.presentedLoader?.dismiss(animated: animated, completion: nil)
            self.presentedLoader = nil
        }
    }
    
    func presentFetchFailedAlert(errorText: String, retryHandler: (() -> Void)?, closeHandler: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "Error",
                message: errorText,
                preferredStyle: .alert
            )
            let retryAction = UIAlertAction(title: "Retry", style: .default) { action in
                retryHandler?()
            }
            let closeAction = UIAlertAction(title: "Close", style: .cancel) { action in
                closeHandler?()
            }
            if retryHandler != nil { alertController.addAction(retryAction) }
            if closeHandler != nil { alertController.addAction(closeAction) }
            alertController.preferredAction = alertController.actions.first
            UIViewController.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
