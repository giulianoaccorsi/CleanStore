//
//  OrdersWorker.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol OrdersStoreProtocol {
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void)
    func createOrder(orderToCreate: Order, completionHandler: @escaping (Order) -> Void)
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order) -> Void)
}

class OrdersWorker {
    var ordersStore: OrdersStoreProtocol
    init(ordersStore: OrdersStoreProtocol) {
        self.ordersStore = ordersStore
    }
    
    func fetchOrders(completionHandler: @escaping ([Order]) -> Void) {
        ordersStore.fetchOrders { (orders: () throws -> [Order]) -> Void in
            do {
                let orders = try orders()
                DispatchQueue.main.async {
                    completionHandler(orders)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    
    func fetchOrder(id: String, completionHandler: @escaping (Order?) -> Void) {
        ordersStore.fetchOrders { (orders: () throws -> [Order]) -> Void in
            do {
                let orders = try orders()
                DispatchQueue.main.async {
                    let order = orders.first { $0.id == id }
                    completionHandler(order)
                    
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func createOrder(orderToCreate: Order, completionHandler: @escaping (Order) -> Void){
        ordersStore.createOrder(orderToCreate: orderToCreate) { order in
            DispatchQueue.main.async {
                completionHandler(order)
            }
        }
    }
    
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order) -> Void) {
        ordersStore.updateOrder(orderToUpdate: orderToUpdate) { order in
            DispatchQueue.main.async {
                completionHandler(order)
            }
        }
    }
}
