//
//  ListOrdersViewController.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ListOrdersViewControllerProtocol: AnyObject {
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel)
    func displaySelectedOrder(viewModel: ListOrders.SelectedOrder.ViewModel)
    func displayAddOrder(viewModel: ListOrders.AddOrder.ViewModel)
}

class ListOrdersViewController: UIViewController, ListOrdersViewControllerProtocol {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    var interactor: ListOrdersInteractorProtocol?
    var router: ListOrdersRouterProtocol?
    var displayedOrders: [ListOrders.FetchOrders.ViewModel.DisplayedOrder] = []
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrdersOnLoad()
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }
    
    func fetchOrdersOnLoad() {
        let request = ListOrders.FetchOrders.Request()
        interactor?.fetchOrders(request: request)
    }
    
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel) {
        displayedOrders = viewModel.displayOrders
        tableView.reloadData()
    }
    
    func displaySelectedOrder(viewModel: ListOrders.SelectedOrder.ViewModel) {
        router?.routeToShowOrder(orderID: viewModel.orderID)
    }
    
    func displayAddOrder(viewModel: ListOrders.AddOrder.ViewModel) {
        router?.routeToCreateOrder()
    }
}

extension ListOrdersViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(tableView)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setUpAdditionalConfiguration() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "List Orders"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ListOrdersCell.self, forCellReuseIdentifier: ListOrdersCell.identifier)
    }
    
    @objc func addButton() {
        let request = ListOrders.AddOrder.Request()
        interactor?.addNewOrder(request: request)
    }
}

extension ListOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ListOrdersCell = tableView.dequeueReusableCell(withIdentifier: ListOrdersCell.identifier, for: indexPath) as? ListOrdersCell else { return UITableViewCell()}
        let displayedOrder = displayedOrders[indexPath.row]
        cell.setupCell(title: displayedOrder.name, detail: displayedOrder.total)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let request = ListOrders.SelectedOrder.Request(index: indexPath.row)
        interactor?.selectedOrder(request: request)
    }
    
}
