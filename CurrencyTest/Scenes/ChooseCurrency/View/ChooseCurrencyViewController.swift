//
//  ChooseCurrencyViewController.swift
//  CurrencyTest
//
//  Created by Михаил Жданов on 24.09.2022.
//

import UIKit

protocol IChooseCurrencyView: AnyObject {
    
    
    
}

class ChooseCurrencyViewController: UIViewController, IChooseCurrencyView {
    
    var presenter: IChooseCurrencyPresenter?
    
    private let cellReuseIdentifier = "TableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose currency"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }

}

extension ChooseCurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.currencyValues.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = presenter?.currencyValues[indexPath.row]
        let isSelected = presenter?.selectedCurrencyIndex == indexPath.row
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectCurrency(at: indexPath.row)
    }
    
}
