//
//  ShowOrderPresenter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol ShowOrderPresentationLogic {
  func presentOrder(response: ShowOrder.GetOrder.Response)
}

class ShowOrderPresenter: ShowOrderPresentationLogic {
  weak var viewController: ShowOrderDisplayLogic?
  
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
  
  // MARK: - Get order
  
  func presentOrder(response: ShowOrder.GetOrder.Response) {
    let order = response.order
    
    let date = dateFormatter.string(from: order.date)
    let total = currencyFormatter.string(from: order.total)!
    let displayedOrder = ShowOrder.GetOrder.ViewModel.DisplayedOrder(id: order.id!, date: date, email: order.email, name: "\(order.firstName) \(order.lastName)", total: total)
    
    let viewModel = ShowOrder.GetOrder.ViewModel(displayedOrder: displayedOrder)
    viewController?.displayOrder(viewModel: viewModel)
  }
}
