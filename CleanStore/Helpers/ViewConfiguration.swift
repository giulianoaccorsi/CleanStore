//
//  ViewConfiguration.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 08/06/22.
//

import Foundation

protocol ViewConfiguration {
    func buildViewHierarchy()
    func setUpConstraints()
    func setUpAdditionalConfiguration()
    func setUpView()
}

extension ViewConfiguration {
    func setUpView() {
        buildViewHierarchy()
        setUpConstraints()
        setUpAdditionalConfiguration()
    }
}
