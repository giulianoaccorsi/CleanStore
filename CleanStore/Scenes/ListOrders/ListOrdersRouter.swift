//
//  ListOrdersRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol ListOrdersRoutingLogic {
    func routeToCreateOrder()
    func routeToShowOrder(orderID: String)
}

class ListOrdersRouter: ListOrdersRoutingLogic {
    
    weak var viewController: ListOrdersViewController?
    
    func routeToCreateOrder() {
        let viewController = CreateOrderViewController()
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func routeToShowOrder(orderID: String) {
        let viewController = ShowOrderViewController(orderID: orderID)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
