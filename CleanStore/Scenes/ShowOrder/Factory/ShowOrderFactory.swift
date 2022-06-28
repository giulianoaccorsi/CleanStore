//
//  ShowOrderFactory.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 27/06/22.
//

import Foundation

enum ShowOrderFactory {
    static func make(orderID: String) -> ShowOrderViewController {
        let viewController = ShowOrderViewController(orderID: orderID)
        let interactor = ShowOrderInteractor(id: orderID)
        let presenter = ShowOrderPresenter()
        let router = ShowOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController

        return viewController
    }
}
