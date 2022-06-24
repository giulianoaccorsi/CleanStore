//
//  ShowOrderInteractor.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ShowOrderBusinessLogic {
    func getOrder(request: ShowOrder.GetOrder.Request)
}

class ShowOrderInteractor: ShowOrderBusinessLogic {
    var presenter: ShowOrderPresentationLogic?
    var worker = OrdersWorker(ordersStore: OrdersMemStore())
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
}
