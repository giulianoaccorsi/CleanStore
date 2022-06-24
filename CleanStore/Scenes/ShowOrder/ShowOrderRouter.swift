//
//  ShowOrderRouter.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 12/06/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

@objc protocol ShowOrderRoutingLogic {
}

class ShowOrderRouter: NSObject, ShowOrderRoutingLogic {
  weak var viewController: ShowOrderViewController?
  
}
