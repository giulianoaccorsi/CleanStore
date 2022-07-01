//
//  ShowOrderFactory.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 27/06/22.
//

import Foundation

enum ShowOrderFactory {
    static func make() -> ShowOrderViewController {
        let viewController = ShowOrderViewController()
        let interactor = ShowOrderInteractor()
        let presenter = ShowOrderPresenter()
        let router = ShowOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}
