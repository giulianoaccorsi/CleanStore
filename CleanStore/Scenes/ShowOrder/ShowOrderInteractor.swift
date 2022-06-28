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

class ShowOrderInteractor: ShowOrderInteractorProtocol {
    
    var presenter: ShowOrderPresenterProtocol?
    var worker = OrdersWorker(ordersStore: OrdersMemStore.shared)
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func getOrder(request: ShowOrder.GetOrder.Request) {
        worker.fetchOrder(id: id) { order in
            guard let orderFetched = order else {return}
            let response = ShowOrder.GetOrder.Response(order: orderFetched)
            self.presenter?.presentOrder(response: response)
        }
    }
    
    func editOrder(request: ShowOrder.EditOrder.Request) {
        worker.fetchOrder(id: id) { order in
            guard let orderFetched = order else {return}
            let response = ShowOrder.EditOrder.Response(order: orderFetched)
            self.presenter?.presentOrderToEdit(response: response)
            
        }
    }
}
