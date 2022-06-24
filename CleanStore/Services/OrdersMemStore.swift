//
//  OrdersMemStore.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//

import Foundation
class OrdersMemStore: OrdersStoreProtocol {
    // MARK: - Data
    
    static var billingAddress = Address(street1: "1 Infinite Loop", street2: "", city: "Cupertino", state: "CA", zip: "95014")
    static var shipmentAddress = Address(street1: "One Microsoft Way", street2: "", city: "Redmond", state: "WA", zip: "98052-7329")
    static var paymentMethod = PaymentMethod(creditCardNumber: "1234-123456-1234", expirationDate: Date(), cvv: "999")
    static var shipmentMethod = ShipmentMethod(speed: .OneDay)
    
    static var orders = [
        Order(firstName: "Amy", lastName: "Apple", phone: "111-111-1111", email: "amy.apple@clean-swift.com", billingAddress: billingAddress, paymentMethod: paymentMethod, shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, id: "abc123", date: Date(), total: NSDecimalNumber(string: "1.23")),
        Order(firstName: "Bob", lastName: "Battery", phone: "222-222-2222", email: "bob.battery@clean-swift.com", billingAddress: billingAddress, paymentMethod: paymentMethod, shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, id: "def456", date: Date(), total: NSDecimalNumber(string: "4.56"))
    ]
    
    
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void) {
      completionHandler { return type(of: self).orders }
    }
}
