//
//  ListOrdersInteractor.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ListOrdersBusinessLogic {
    func fetchOrders(request: ListOrders.FetchOrders.Request)
    func selectedOrder(request: ListOrders.GetOrder.Request)
    func addNewOrder(request: ListOrders.AddOrder.Request)
}

class ListOrdersInteractor: ListOrdersBusinessLogic {
    var presenter: ListOrdersPresentationLogic?
    var worker = OrdersWorker(ordersStore: OrdersMemStore.shared)
    var orders: [Order] = []
    
    func fetchOrders(request: ListOrders.FetchOrders.Request) {
        worker.fetchOrders { orders in
            self.orders = orders
            let response = ListOrders.FetchOrders.Response(orders: orders)
            self.presenter?.presentFetchedOrders(response: response)
        }
    }
    
    func selectedOrder(request: ListOrders.GetOrder.Request) {
        let ordem = orders[request.index]
        let response = ListOrders.GetOrder.Response(orderID: ordem.id)
        self.presenter?.presentGetOrder(response: response)
    }
    
    func addNewOrder(request: ListOrders.AddOrder.Request) {
        let response = ListOrders.AddOrder.Response()
        self.presenter?.presentAddOrder(response: response)
    }
}
