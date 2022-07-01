//
//  CreateOrderRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol CreateOrderRouterProtocol {
    func routeToListOrdersViewController()
    func routeToShowOrderViewController()
    
}

protocol CreateOrderDataPassing {
    var dataStore: CreateOrderDataStore? { get }
}

class CreateOrderRouter: CreateOrderRouterProtocol, CreateOrderDataPassing {
    var dataStore: CreateOrderDataStore?
    
    weak var viewController: CreateOrderViewController?
    
    func routeToListOrdersViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func routeToShowOrderViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
