//
//  CreateOrderModels.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//


import UIKit

enum CreateOrder {
    
    enum UpdateOrder {
        struct Request {
            var order: OrderFormFields
            var id: String
            var date: Date
        }
        struct Response {
            var order: Order
        }
        
        struct ViewModel {
            var order: Order
        }
    }
    
    enum EditOrder {
        struct Request {}
        struct Response {
            var order: Order
        }
        
        struct ViewModel {
            var order: Order
        }
    }
    
    enum SaveOrder {
        struct Request {
            var order: OrderFormFields
        }
        struct Response {
            var order: Order?
        }
        
        struct ViewModel {
            var order: Order?
        }
    }
    
    enum FormatExpirationDate {
        struct Request {
            var date: Date
        }
        struct Response {
            var date: Date
        }
        
        struct ViewModel {
            var date: String
        }
    }
    
    enum TableView {
        struct Request {}
        struct Response {
            var formSection: [FormSection]
        }
        struct ViewModel {
            var formSection: [FormSection]
        }
    }
    
    enum PickerView {
        struct Request {}
        struct Response {
            var shippingMethods: [String]
        }
        struct ViewModel {
            var shippingMethods: [String]
        }
    }
}

struct FormSection {
    struct Field {
        enum FieldType {
            case textFieldSection
            case switchSection
        }
        
        enum TextFieldKeyboardType {
            case email
            case numberPad
            case normal
            case decimalPad
        }
        let text: String
        let keyboardType: TextFieldKeyboardType
        let type: FieldType
    }
    let name: String
    let fields: [Field]
    
}

struct OrderFormFields {
    // MARK: Contact info
    var firstName: String
    var lastName: String
    var phone: String
    var email: String
    
    // MARK: Payment info
    var billingAddressStreet1: String
    var billingAddressStreet2: String
    var billingAddressCity: String
    var billingAddressState: String
    var billingAddressZIP: String
    
    var paymentMethodCreditCardNumber: String
    var paymentMethodCVV: String
    var paymentMethodExpiration: String
    
    // MARK: Shipping info
    var shipmentAddressStreet1: String
    var shipmentAddressStreet2: String
    var shipmentAddressCity: String
    var shipmentAddressState: String
    var shipmentAddressZIP: String
    var shipmentMethodSpeed: String
    
    // MARK: Misc
    var total: String
}
