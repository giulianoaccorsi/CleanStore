//
//  CreateOrderRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

@objc protocol CreateOrderRouterProtocol {
    func routeToListOrdersViewController()
    func routeToShowOrderViewController()
    
}

class CreateOrderRouter: CreateOrderRouterProtocol {
    weak var viewController: CreateOrderViewController?
    
    func routeToListOrdersViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func routeToShowOrderViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
