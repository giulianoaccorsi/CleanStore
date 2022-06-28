//
//  ListOrdersModels.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

enum ListOrders {
    // MARK: Use cases
    enum FetchOrders {
        struct Request {}
        
        struct Response {
            let orders: [Order]
        }
        struct ViewModel {
            struct DisplayedOrder {
                let id: String
                let date: String
                let email: String
                let name: String
                let total: String
            }
            let displayOrders: [DisplayedOrder]
        }
    }
    
    enum SelectedOrder {
        struct Request {
            let index: Int
        }
        
        struct Response {
            let orderID: String
        }
        
        struct ViewModel{
            let orderID: String
        }
    }
    
    enum AddOrder {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel{
        }
    }
}
