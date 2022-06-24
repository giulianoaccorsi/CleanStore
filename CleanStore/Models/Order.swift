//
//  Order.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//

import Foundation

struct Order {
  // MARK: Contact info
  var firstName: String
  var lastName: String
  var phone: String
  var email: String
  
  // MARK: Payment info
  var billingAddress: Address
  var paymentMethod: PaymentMethod
  
  // MARK: Shipping info
  var shipmentAddress: Address
  var shipmentMethod: ShipmentMethod
  
  // MARK: Misc
  var id: String?
  var date: Date
  var total: NSDecimalNumber
}

// MARK: - Supporting models

struct Address {
  var street1: String
  var street2: String?
  var city: String
  var state: String
  var zip: String
}

struct ShipmentMethod {
  enum ShippingSpeed: Int {
    case Standard = 0 // "Standard Shipping"
    case OneDay = 1 // "One-Day Shipping"
    case TwoDay = 2 // "Two-Day Shipping"
  }
  var speed: ShippingSpeed
  
  func toString() -> String {
    switch speed {
    case .Standard:
      return "Standard Shipping"
    case .OneDay:
      return "One-Day Shipping"
    case .TwoDay:
      return "Two-Day Shipping"
    }
  }
}

struct PaymentMethod {
  var creditCardNumber: String
  var expirationDate: Date
  var cvv: String
}
