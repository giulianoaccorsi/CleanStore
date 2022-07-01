//
//  ShowOrderInteractor.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ShowOrderInteractorProtocol {
    func getOrder(request: ShowOrder.GetOrder.Request)
    func editOrder(request: ShowOrder.EditOrder.Request)
}

protocol ShowOrderDataStore {
    var order: Order! {get set}
}

class ShowOrderInteractor: ShowOrderInteractorProtocol, ShowOrderDataStore {
    var order: Order!
    var presenter: ShowOrderPresenterProtocol?
    var worker = OrdersWorker(ordersStore: OrdersMemStore.shared)
    
    func getOrder(request: ShowOrder.GetOrder.Request) {
        worker.fetchOrder(id: order.id) { order in
            guard let orderFetched = order else {return}
            let response = ShowOrder.GetOrder.Response(order: orderFetched)
            self.presenter?.presentOrder(response: response)
        }
    }
    
    func editOrder(request: ShowOrder.EditOrder.Request) {
        worker.fetchOrder(id: order.id) { order in
            guard let orderFetched = order else {return}
            let response = ShowOrder.EditOrder.Response(order: orderFetched)
            self.presenter?.presentOrderToEdit(response: response)
            
        }
    }
}
