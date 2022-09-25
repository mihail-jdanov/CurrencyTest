//
//  LoaderViewController.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 25.09.2022.
//

import UIKit

class LoaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        createIndicator()
    }
    
    private func createIndicator() {
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.color = .white
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        indicatorView.startAnimating()
    }

}
