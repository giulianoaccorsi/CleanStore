//
//  ShowOrderModels.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum ShowOrder {
    // MARK: Use cases
    
    enum GetOrder {
        struct Request {}
        
        struct Response {
            var order: Order
        }
        struct ViewModel {
            struct DisplayedOrder {
                var id: String
                var date: String
                var email: String
                var name: String
                var total: String
            }
            var displayedOrder: DisplayedOrder
        }
    }
    
    enum EditOrder {
        struct Request {}
        
        struct Response {
            var order: Order
        }
        struct ViewModel {
            var order: Order
        }
    }
}
