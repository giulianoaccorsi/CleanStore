//
//  CreateOrderViewController.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol CreateOrderDisplayLogic: AnyObject {
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    func displayTableView(viewModel: CreateOrder.TableView.ViewModel)
    func displayPickerView(viewModel: CreateOrder.PickerView.ViewModel)
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
    var router: CreateOrderRoutingLogic?
    var textFieldsTags: [Int] = []
    var myTexts = [Int: String]()
    var dateFromPresenter: String?
    var formSection: [FormSection] = []
    var shippingMethods: [String] = []
    
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
        setUpView()
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fillTableView(request: CreateOrder.TableView.Request())
        interactor?.fillPickerView(request: CreateOrder.PickerView.Request())
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
