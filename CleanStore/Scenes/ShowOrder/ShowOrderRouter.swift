//
//  ShowOrderRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol ShowOrderRouterProtocol {
    func routeToCreateOrder(order: Order)
}

class ShowOrderRouter: ShowOrderRouterProtocol {
    
    weak var viewController: ShowOrderViewController?
    
    func routeToCreateOrder(order: Order) {
        let viewController = CreateOrderViewController(orderToEdit: order)
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
