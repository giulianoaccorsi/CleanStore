//
//  ShowOrderViewController.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ShowOrderDisplayLogic: AnyObject {
    func displayOrder(viewModel: ShowOrder.GetOrder.ViewModel)
    func displayOrderToEdit(viewModel: ShowOrder.EditOrder.ViewModel)
}

class ShowOrderViewController: UIViewController, ShowOrderDisplayLogic {
    
    let orderLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "Order ID: "
        return title
    }()
    
    let orderDate: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "Order Date: "
        return title
    }()
    
    let emailAddress: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "Email Address: "
        return title
    }()
    
    let yourName: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "Your Name: "
        return title
    }()
    
    let orderTotal: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "Order Total: "
        return title
    }()
    
    lazy var stackViewOrder: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orderLabel, orderDate, emailAddress, yourName, orderTotal])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        return stack
    }()
    
    let idLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "id"
        return title
    }()
    
    let dateLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "date"
        return title
    }()
    
    let emailLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "email"
        return title
    }()
    
    let nameLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "name"
        return title
    }()
    
    let totalLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.textColor = .black
        title.text = "total"
        return title
    }()
    
    lazy var stackInformation: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [idLabel, dateLabel, emailLabel, nameLabel, totalLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.axis = .vertical
        return stack
    }()
    
    lazy var stackTotal: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stackViewOrder, stackInformation])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        return stack
    }()
    
    var interactor: ShowOrderBusinessLogic?
    var orderID: String
    var router: ShowOrderRoutingLogic?
    
    init(orderID: String) {
        self.orderID = orderID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ShowOrderInteractor(id: self.orderID)
        let presenter = ShowOrderPresenter()
        let router = ShowOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        setUpView()
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func getOrder() {
        let request = ShowOrder.GetOrder.Request()
        interactor?.getOrder(request: request)
    }
    
    func displayOrder(viewModel: ShowOrder.GetOrder.ViewModel) {
        let displayedOrder = viewModel.displayedOrder
        idLabel.text = displayedOrder.id
        dateLabel.text = displayedOrder.date
        emailLabel.text = displayedOrder.email
        nameLabel.text = displayedOrder.name
        totalLabel.text = displayedOrder.total
    }
    
    func displayOrderToEdit(viewModel: ShowOrder.EditOrder.ViewModel) {
        self.router?.routeToCreateOrder(order: viewModel.order)
    }
    
    
    
    @objc func editButton() {
        interactor?.editOrder(request: ShowOrder.EditOrder.Request())
    }
}

extension ShowOrderViewController: ViewConfiguration {
    func buildViewHierarchy() {
        view.addSubview(stackTotal)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            stackTotal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackTotal.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setUpAdditionalConfiguration() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Show Order"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButton))
    }
}
