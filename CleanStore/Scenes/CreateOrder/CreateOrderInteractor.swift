//
//  CreateOrderInteractor.swift
//  CleanStore
//
//  Created by Giuliano Accorsi on 31/05/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.


import UIKit

protocol CreateOrderBusinessLogic {
    func formatExpirationDate(request: CreateOrder.FormatExpirationDate.Request)
    func fillTableView(request: CreateOrder.TableView.Request)
    func fillPickerView(request: CreateOrder.PickerView.Request)
    
}

class CreateOrderInteractor: CreateOrderBusinessLogic {
  
    var presenter: CreateOrderPresentationLogic?
    
    var worker: CreateOrderWorker?
    
    var shippingMethods = [
          ShipmentMethod(speed: .Standard).toString(),
          ShipmentMethod(speed: .OneDay).toString(),
          ShipmentMethod(speed: .TwoDay).toString()
    ]
    
    var formSection: [FormSection] = [FormSection(name: "Customer Contact Info", fields: [
        FormSection.Field(text: "First Name", keyboardType: .normal, type: .textFieldSection),
        FormSection.Field(text: "Last Name", keyboardType: .normal, type: .textFieldSection),
        FormSection.Field(text: "Phone", keyboardType: .numberPad, type: .textFieldSection),
        FormSection.Field(text: "Email", keyboardType: .email, type: .textFieldSection),
        FormSection.Field(text: "Total", keyboardType: .decimalPad, type: .textFieldSection)]),
                                   FormSection(name: "Shipment Address", fields: [
                                    FormSection.Field(text: "Street 1", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "Street 2", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "City", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "State", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "ZIP", keyboardType: .numberPad, type: .textFieldSection)]),
                                   FormSection(name: "Shipment Method", fields: [
                                    FormSection.Field(text: "Shipping Speed", keyboardType: .normal, type: .textFieldSection)]),
                                   FormSection(name: "Payment Information", fields: [
                                    FormSection.Field(text: "Credit Card Number", keyboardType: .numberPad, type: .textFieldSection),
                                    FormSection.Field(text: "Expiration Date", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "CVV", keyboardType: .numberPad, type: .textFieldSection)]),
                                   FormSection(name: "Billing Address", fields: [
                                    FormSection.Field(text: "Same as shipping address", keyboardType: .normal, type: .switchSection),
                                    FormSection.Field(text: "Street 1", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "Street 2", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "City", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "State", keyboardType: .normal, type: .textFieldSection),
                                    FormSection.Field(text: "ZIP", keyboardType: .numberPad, type: .textFieldSection)])]
    
    func fillTableView(request: CreateOrder.TableView.Request) {
        let response = CreateOrder.TableView.Response(formSection: formSection)
        presenter?.presentTableView(response: response)
        
    }
    
    
    func formatExpirationDate(request: CreateOrder.FormatExpirationDate.Request) {
        let response = CreateOrder.FormatExpirationDate.Response(date: request.date)
        presenter?.presentExpirationDate(response: response)
    }
    
    func fillPickerView(request: CreateOrder.PickerView.Request) {
        let response = CreateOrder.PickerView.Response(shippingMethods: shippingMethods)
        presenter?.presentPickerView(reponse: response)
    }
}
