//
//  ListOrdersRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol ListOrdersRouterProtocol {
    func routeToCreateOrder()
    func routeToShowOrder()
}

protocol ListOrderDataPassing {
    var dataStore: ListOrdersDataStore? {get}
}

class ListOrdersRouter: ListOrdersRouterProtocol, ListOrderDataPassing{
    var dataStore: ListOrdersDataStore?
    
    weak var viewController: ListOrdersViewController?
    
    func routeToCreateOrder() {
        let viewControllerDestination = CreateOrderFactory.make()
        var dataStoreDestination = viewControllerDestination.router?.dataStore
        passDataToCreateOrder(source: dataStore, destination: &dataStoreDestination)
        navigateToCreateOrder(source: viewController!, destination: viewControllerDestination)
    }
    
    func routeToShowOrder() {
        let viewControllerDestination = ShowOrderFactory.make()
        var dataStoreDestination = viewControllerDestination.router?.dataStore
        passDataToShowOrder(source: dataStore, destination: &dataStoreDestination)
        navigateToShowOrder(source: viewController, destination: viewControllerDestination)
    }
    
    // MARK: Navigation
    
    func navigateToCreateOrder(source: ListOrdersViewController?, destination: CreateOrderViewController?) {
        guard let destination = destination else {return}
        source?.show(destination, sender: nil)
    }
    
    func navigateToShowOrder(source: ListOrdersViewController?, destination: ShowOrderViewController?) {
        guard let destination = destination else {return}
        source?.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToCreateOrder(source: ListOrdersDataStore?, destination: inout CreateOrderDataStore?) {
    }
    
    func passDataToShowOrder(source: ListOrdersDataStore?, destination: inout ShowOrderDataStore?) {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination?.order = source?.orders?[selectedRow!]
    }
    
}
