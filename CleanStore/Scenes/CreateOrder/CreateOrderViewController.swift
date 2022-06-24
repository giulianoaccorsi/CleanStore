//
//  CreateOrderViewController.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol CreateOrderDisplayLogic: AnyObject {
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
}

class CreateOrderViewController: UIViewController, CreateOrderDisplayLogic {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    let shippingMethodPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    lazy var expirationDatePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.addTarget(self, action: #selector(expirationDatePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    
    var interactor: CreateOrderBusinessLogic?
    var router: (NSObjectProtocol & CreateOrderRoutingLogic & CreateOrderDataPassing)?
    var textFieldsTags: [Int] = []
    var dateFromPresenter: String?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CreateOrderInteractor()
        let presenter = CreateOrderPresenter()
        let router = CreateOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        setUpView()
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel) {
        let date = viewModel.date
        self.dateFromPresenter = date
    }
    
    @objc func expirationDatePickerValueChanged() {
        let date = expirationDatePicker.date
        let request = CreateOrder.FormatExpirationDate.Request(date: date)
        interactor?.formatExpirationDate(request: request)
        
    }
    
}

// MARK: ViewConfiguration

extension CreateOrderViewController: ViewConfiguration {
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
        self.navigationItem.title = "Create Order"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.shippingMethodPicker.delegate = self
        self.shippingMethodPicker.dataSource = self
        self.tableView.register(CreateOrderTextFieldCell.self, forCellReuseIdentifier: CreateOrderTextFieldCell.identifier)
        self.tableView.register(CreateOrderSwitchCell.self, forCellReuseIdentifier: CreateOrderSwitchCell.identifier)
    }
    
    @objc func saveButton() {
        
    }
}

// MARK: UITableViewDataSource

extension CreateOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.interactor?.formSection.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.interactor?.formSection[section].fields.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.interactor?.formSection[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = self.interactor?.formSection[indexPath.section].fields[indexPath.row] else { return UITableViewCell() }
        switch cellType.type {
        case .textFieldSection:
            guard let cell: CreateOrderTextFieldCell = tableView.dequeueReusableCell(withIdentifier: CreateOrderTextFieldCell.identifier, for: indexPath) as? CreateOrderTextFieldCell else { return UITableViewCell()}
            cell.setupCell(titleLabel: cellType.text, keyboardType: cellType.keyboardType)
            cell.textField.delegate = self
            let tag = indexPath.section * 10 + indexPath.row
            cell.textField.tag = tag
            textFieldsTags.append(tag)
            return cell
        case .switchSection:
            guard let cell: CreateOrderSwitchCell = tableView.dequeueReusableCell(withIdentifier: CreateOrderSwitchCell.identifier, for: indexPath) as? CreateOrderSwitchCell else { return UITableViewCell() }
            cell.setupCell(titleLabel: cellType.text)
            return cell
        }
    }
}

// MARK: UITextFieldDelegate

extension CreateOrderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let currentIndex = textFieldsTags.firstIndex(of: textField.tag)
        if let nextField = self.view.viewWithTag(textFieldsTags[(currentIndex ?? 0) + 1]) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textField = self.view.viewWithTag(20) as? UITextField {
            textField.inputView = shippingMethodPicker
        }
        
        if let textField = self.view.viewWithTag(31) as? UITextField {
            textField.inputView = expirationDatePicker
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textField = self.view.viewWithTag(31) as? UITextField {
            textField.text = dateFromPresenter ?? ""
        }
    }
}
// MARK: UIPickerViewDelegate

extension CreateOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interactor?.shippingMethods.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interactor?.shippingMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let shippingMethodTAG = 20
        if let textField = self.view.viewWithTag(shippingMethodTAG) as? UITextField {
            textField.text = interactor?.shippingMethods[row]
        }
    }
    
}
