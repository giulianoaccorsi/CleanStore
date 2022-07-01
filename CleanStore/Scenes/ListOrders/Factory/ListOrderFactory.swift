//
//  ListOrderFactory.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 27/06/22.
//

import Foundation

enum ListOrderFactory {
    static func make() -> ListOrdersViewController {
        let viewController = ListOrdersViewController()
        let interactor = ListOrdersInteractor()
        let presenter = ListOrdersPresenter()
        let router = ListOrdersRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        return viewController
    }
}
