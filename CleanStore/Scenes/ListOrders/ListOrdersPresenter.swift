//
//  ListOrdersPresenter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ListOrdersPresentationLogic {
    func presentFetchedOrders(response: ListOrders.FetchOrders.Response)
    func presentGetOrder(response: ListOrders.GetOrder.Response)
    func presentAddOrder(response: ListOrders.AddOrder.Response)
}

class ListOrdersPresenter: ListOrdersPresentationLogic {
    weak var viewController: ListOrdersDisplayLogic?
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    let currencyFormatter: NumberFormatter = {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        return currencyFormatter
    }()
    
    func presentFetchedOrders(response: ListOrders.FetchOrders.Response) {
        var displayedOrders: [ListOrders.FetchOrders.ViewModel.DisplayedOrder] = []
        for order in response.orders {
            let date = dateFormatter.string(from: order.date)
            let total = currencyFormatter.string(from: order.total)
            let displayedOrder = ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: order.id ?? "", date: date, email: order.email, name: "\(order.firstName) \(order.lastName)", total: total ?? "")
            displayedOrders.append(displayedOrder)
        }
        let viewModel = ListOrders.FetchOrders.ViewModel(displayOrders: displayedOrders)
        viewController?.displayFetchedOrders(viewModel: viewModel)
    }
    
    func presentGetOrder(response: ListOrders.GetOrder.Response) {
        let viewModel = ListOrders.GetOrder.ViewModel(orderID: response.orderID)
        viewController?.displayGetOrder(viewModel: viewModel)
        
    }
    
    func presentAddOrder(response: ListOrders.AddOrder.Response) {
        let viewModel = ListOrders.AddOrder.ViewModel()
        viewController?.displayAddOrder(viewModel: viewModel)
    }
}
