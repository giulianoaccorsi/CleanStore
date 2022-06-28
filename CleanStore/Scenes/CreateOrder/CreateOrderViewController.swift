//
//  CreateOrderViewController.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol CreateOrderViewControllerProtocol: AnyObject {
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    func displayTableView(viewModel: CreateOrder.TableView.ViewModel)
    func displayPickerView(viewModel: CreateOrder.PickerView.ViewModel)
    func displayCreatedOrder(viewModel: CreateOrder.SaveOrder.ViewModel)
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    func displayUpdateOrder(viewModel: CreateOrder.EditOrder.ViewModel)
}

class CreateOrderViewController: UIViewController, CreateOrderViewControllerProtocol {
    
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
    
    
    var interactor: CreateOrderInteractorProtocol?
    var router: CreateOrderRouterProtocol?
    var textFieldsTags: [Int] = []
    var myTexts = [Int: String]()
    var dateFromPresenter: String?
    var formSection: [FormSection] = []
    var shippingMethods: [String] = []
    var orderToEdit: Order?
    
    // MARK: Object lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(orderToEdit: Order) {
        self.orderToEdit = orderToEdit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        //TODO: Adicionar no interactor
        if let orderToEdit = orderToEdit {
            let request = CreateOrder.EditOrder.Request(order: orderToEdit)
            interactor?.loadOrderToEdit(request: request)
        }
        interactor?.loadTableView(request: CreateOrder.TableView.Request())
        interactor?.loadPickerView(request: CreateOrder.PickerView.Request())
    }
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel) {
        let date = viewModel.date
        self.dateFromPresenter = date
    }
    
    func displayTableView(viewModel: CreateOrder.TableView.ViewModel) {
        self.formSection = viewModel.formSection
        tableView.reloadData()
    }
    
    func displayPickerView(viewModel: CreateOrder.PickerView.ViewModel) {
        self.shippingMethods = viewModel.shippingMethods
        self.shippingMethodPicker.reloadAllComponents()
    }
    
    func displayCreatedOrder(viewModel: CreateOrder.SaveOrder.ViewModel) {
        router?.routeToListOrdersViewController()
    }
    
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel) {
        let order = viewModel.order
        myTexts[0] = order.firstName
        myTexts[1] = order.lastName
        myTexts[2] = order.phone
        myTexts[3] = order.email
        myTexts[4] = "\(order.total)"
        myTexts[10] = order.shipmentAddress.street1
        myTexts[11] = order.shipmentAddress.street2
        myTexts[12] = order.shipmentAddress.city
        myTexts[13] = order.shipmentAddress.state
        myTexts[14] = order.shipmentAddress.zip
        myTexts[20] = order.shipmentMethod
        myTexts[30] = order.paymentMethod.creditCardNumber
        myTexts[31] = order.paymentMethod.expirationDate
        myTexts[32] = order.paymentMethod.cvv
        myTexts[41] = order.billingAddress.street1
        myTexts[42] = order.billingAddress.street2
        myTexts[43] = order.billingAddress.city
        myTexts[44] = order.billingAddress.state
        myTexts[45] = order.billingAddress.zip
    }
    
    func displayUpdateOrder(viewModel: CreateOrder.EditOrder.ViewModel) {
        router?.routeToShowOrderViewController()
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
        self.view.endEditing(true)
        
        let firstName = myTexts[0] ?? ""
        let lastName = myTexts[1] ?? ""
        let phone = myTexts[2] ?? ""
        let email = myTexts[3] ?? ""
        let total = myTexts[4] ?? ""
        let shippingStreet1 = myTexts[10] ?? ""
        let shippingStreet2 = myTexts[11] ?? ""
        let shippingCity = myTexts[12] ?? ""
        let shippingState = myTexts[13] ?? ""
        let shippingZIP = myTexts[14] ?? ""
        let shippingMethod = myTexts[20] ?? ""
        let creditCardNumber = myTexts[30] ?? ""
        let expirationDate = myTexts[31] ?? ""
        let cvv = myTexts[32] ?? ""
        let billingStreet1 = myTexts[41] ?? ""
        let billingStreet2 = myTexts[42] ?? ""
        let billingCity = myTexts[43] ?? ""
        let billingState = myTexts[44] ?? ""
        let billingZIP = myTexts[45] ?? ""
        
        if let orderUpdate = orderToEdit {
            let request = CreateOrder.UpdateOrder.Request(order: OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, billingAddressStreet1: billingStreet1, billingAddressStreet2: billingStreet2, billingAddressCity: billingCity, billingAddressState: billingState, billingAddressZIP: billingZIP, paymentMethodCreditCardNumber: creditCardNumber, paymentMethodCVV: cvv, paymentMethodExpiration: expirationDate, shipmentAddressStreet1: shippingStreet1, shipmentAddressStreet2: shippingStreet2, shipmentAddressCity: shippingCity, shipmentAddressState: shippingState, shipmentAddressZIP: shippingZIP, shipmentMethodSpeed: shippingMethod, total: total), id: orderUpdate.id, date: orderUpdate.date)
            interactor?.updateOrder(request: request)
            return
        }
        let request = CreateOrder.SaveOrder.Request(order: OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, billingAddressStreet1: billingStreet1, billingAddressStreet2: billingStreet2, billingAddressCity: billingCity, billingAddressState: billingState, billingAddressZIP: billingZIP, paymentMethodCreditCardNumber: creditCardNumber, paymentMethodCVV: cvv, paymentMethodExpiration: expirationDate, shipmentAddressStreet1: shippingStreet1, shipmentAddressStreet2: shippingStreet2, shipmentAddressCity: shippingCity, shipmentAddressState: shippingState, shipmentAddressZIP: shippingZIP, shipmentMethodSpeed: shippingMethod, total: total))
        interactor?.saveOrder(request: request)
    }
}

// MARK: UITableViewDataSource

extension CreateOrderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return formSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formSection[section].fields.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return formSection[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = formSection[indexPath.section].fields[indexPath.row]
        switch cellType.type {
        case .textFieldSection:
            guard let cell: CreateOrderTextFieldCell = tableView.dequeueReusableCell(withIdentifier: CreateOrderTextFieldCell.identifier, for: indexPath) as? CreateOrderTextFieldCell else { return UITableViewCell()}
            cell.setupCell(titleLabel: cellType.text, keyboardType: cellType.keyboardType)
            cell.textField.delegate = self
            let tag = indexPath.section * 10 + indexPath.row
            cell.textField.tag = tag
            textFieldsTags.append(tag)
            let dictTest = myTexts[tag]
            cell.textField.text = dictTest
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let totalTAG = 4
        if textField.tag == totalTAG {
            if string == "," {
                textField.text = textField.text ?? "" + "."
                return false
            }
        }
        return true
    }
    
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
        let tagPicker = 20
        let tagDatePicker = 31
        
        
        if let textField = self.view.viewWithTag(tagPicker) as? UITextField {
            textField.inputView = shippingMethodPicker
        }
        if let textField = self.view.viewWithTag(tagDatePicker) as? UITextField {
            textField.inputView = expirationDatePicker
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tagDatePicker = 31
        
        if let textField = self.view.viewWithTag(tagDatePicker) as? UITextField {
            textField.text = dateFromPresenter ?? ""
        }
        myTexts.updateValue(textField.text ?? "", forKey: textField.tag)
    }
}

// MARK: UIPickerViewDelegate

extension CreateOrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return shippingMethods.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return shippingMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let shippingMethodTAG = 20
        if let textField = self.view.viewWithTag(shippingMethodTAG) as? UITextField {
            textField.text = shippingMethods[row]
        }
    }
    
}
