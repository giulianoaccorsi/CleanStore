//
//  Order.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//

import Foundation

struct Order {
    
    var firstName: String
    var lastName: String
    var phone: String
    var email: String
    var total: NSDecimalNumber
    var shipmentAddress: Address
    var shipmentMethod: String
    var billingAddress: Address
    var paymentMethod: PaymentMethod
    var id: String
    var date: Date

}

struct Address {
    var street1: String
    var street2: String
    var city: String
    var state: String
    var zip: String
}

struct PaymentMethod {
    var creditCardNumber: String
    var expirationDate: String
    var cvv: String
}
