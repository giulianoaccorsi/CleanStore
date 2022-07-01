//
//  ShowOrderRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol ShowOrderRouterProtocol {
    func routeToCreateOrder()
}

protocol ShowOrderDataPassing {
    var dataStore: ShowOrderDataStore? {get}
}

class ShowOrderRouter: ShowOrderRouterProtocol, ShowOrderDataPassing {
    
    var dataStore: ShowOrderDataStore?
    weak var viewController: ShowOrderViewController?
    
    func routeToCreateOrder() {
        let viewControllerDestination = CreateOrderFactory.make()
        var dataStoreDestination = viewControllerDestination.router?.dataStore
        passDataToCreateOrder(source: dataStore, destination: &dataStoreDestination)
        navigateToCreateOrder(source: viewController, destination: viewControllerDestination)
    }
    
    func navigateToCreateOrder(source: ShowOrderViewController?, destination: CreateOrderViewController?) {
        guard let destination = destination else {return}
        source?.show(destination, sender: nil)
    }
    
    func passDataToCreateOrder(source: ShowOrderDataStore?, destination: inout CreateOrderDataStore?) {
        guard var destination = destination else {return}
        destination.orderToEdit = source?.order
    }
    
}

