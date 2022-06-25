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
    func saveOrderForm(request: CreateOrder.SaveOrder.Request)
    func fillEditOrder(request: CreateOrder.EditOrder.Request)
    
    
}

class CreateOrderInteractor: CreateOrderBusinessLogic {

    var presenter: CreateOrderPresentationLogic?
    var orderToEdit: Order?
    var ordersWorker = OrdersWorker(ordersStore: OrdersMemStore())
    
    var shippingMethods = ["Standard Shipping", "One-Day Shipping", "Two-Day Shipping"]
    
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
    
    func saveOrderForm(request: CreateOrder.SaveOrder.Request) {
        let orderToCreate = buildOrderFromOrderFormFields(request.order)
        ordersWorker.createOrder(orderToCreate: orderToCreate) { order in
            self.orderToEdit = order
            let response = CreateOrder.SaveOrder.Response(order: order)
            self.presenter?.presentCreatedOrder(response: response)
        }
    }
    
    
    func formatExpirationDate(request: CreateOrder.FormatExpirationDate.Request) {
        let response = CreateOrder.FormatExpirationDate.Response(date: request.date)
        presenter?.presentExpirationDate(response: response)
    }
    
    func fillPickerView(request: CreateOrder.PickerView.Request) {
        let response = CreateOrder.PickerView.Response(shippingMethods: shippingMethods)
        presenter?.presentPickerView(reponse: response)
    }
    
    func fillEditOrder(request: CreateOrder.EditOrder.Request) {
        let response = CreateOrder.EditOrder.Response(order: request.order)
        presenter?.presentEditedOrder(reponse: response)
    }
    
    private func buildOrderFromOrderFormFields(_ orderFormFields: OrderFormFields) -> Order {
        let billingAddress = Address(street1: orderFormFields.billingAddressStreet1, street2: orderFormFields.billingAddressStreet2, city: orderFormFields.billingAddressCity, state: orderFormFields.billingAddressState, zip: orderFormFields.billingAddressZIP)
        
        let paymentMethod = PaymentMethod(creditCardNumber: orderFormFields.paymentMethodCreditCardNumber, expirationDate: orderFormFields.paymentMethodExpiration, cvv: orderFormFields.paymentMethodCVV)
        
        let shipmentAddress = Address(street1: orderFormFields.shipmentAddressStreet1, street2: orderFormFields.shipmentAddressStreet2, city: orderFormFields.shipmentAddressCity, state: orderFormFields.shipmentAddressState, zip: orderFormFields.shipmentAddressZIP)
        
        return Order(firstName: orderFormFields.firstName, lastName: orderFormFields.lastName, phone: orderFormFields.phone, email: orderFormFields.email, total: NSDecimalNumber(string: orderFormFields.total), shipmentAddress: shipmentAddress, shipmentMethod: orderFormFields.shipmentMethodSpeed, billingAddress: billingAddress, paymentMethod: paymentMethod, id: "\(arc4random())", date: Date())
    }
}
