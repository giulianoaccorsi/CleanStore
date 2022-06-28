//
//  CreateOrderFactory.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 27/06/22.
//

import Foundation

enum CreateOrderFactory {
    static func make() -> CreateOrderViewController {
        let viewController = CreateOrderViewController()
        let interactor = CreateOrderInteractor()
        let presenter = CreateOrderPresenter()
        let router = CreateOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
