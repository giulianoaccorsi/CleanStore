//
//  OrdersMemStore.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//

import Foundation
class OrdersMemStore: OrdersStoreProtocol {
    
    private init(){}
    
    static let shared = OrdersMemStore()

    static var billingAddress = Address(street1: "1 Infinite Loop", street2: "", city: "Cupertino", state: "CA", zip: "95014")
    static var shipmentAddress = Address(street1: "One Microsoft Way", street2: "", city: "Redmond", state: "WA", zip: "98052-7329")
    static var paymentMethod = PaymentMethod(creditCardNumber: "1234-123456-1234", expirationDate: "25/06/30", cvv: "999")
    static var shipmentMethod = "Two-Day Shipping"
    
    static var orders = [
        Order(firstName: "Amy", lastName: "Apple", phone: "111-111-1111", email: "amy.apple@clean-swift.com", total: NSDecimalNumber(string: "4.56"), shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, billingAddress: billingAddress, paymentMethod: paymentMethod, id: "abc123", date: Date()),
        Order(firstName: "Bob", lastName: "Marley", phone: "222-222-2222", email: "bob.marley@clean-swift.com", total: NSDecimalNumber(string: "9.56"), shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, billingAddress: billingAddress, paymentMethod: paymentMethod, id: "dce222", date: Date()),
        Order(firstName: "Giuliano", lastName: "Costa", phone: "333-333-3333", email: "giuliano.costa@clean-swift.com", total: NSDecimalNumber(string: "94.56"), shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, billingAddress: billingAddress, paymentMethod: paymentMethod, id: "cd3ee", date: Date())
    ]
    
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void) {
        completionHandler { return type(of: self).orders }
    }
    
    func createOrder(orderToCreate: Order, completionHandler: @escaping (Order) -> Void) {
        type(of: self).orders.append(orderToCreate)
        completionHandler(orderToCreate)
    }
    
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order) -> Void) {
      if let index = indexOfOrderWithID(id: orderToUpdate.id) {
        type(of: self).orders[index] = orderToUpdate
        let order = type(of: self).orders[index]
        completionHandler(order)
      }
    }
    
    private func indexOfOrderWithID(id: String?) -> Int?{
      return type(of: self).orders.firstIndex { return $0.id == id }
    }
}
