//
//  PaymentData.swift
//  MercadoPagoSDK
//
//  Created by Maria cristina rodriguez on 2/1/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

public class PaymentData: NSObject {

    public var paymentMethod : PaymentMethod!
    public var issuer : Issuer?
    public var payerCost : PayerCost?
    public var token : Token?
    public var payer = Payer()
    public var transactionDetails : TransactionDetails?
    
    func clearCollectedData() {
        self.paymentMethod = nil
        self.issuer = nil
        self.payerCost = nil
        self.token = nil
        self.payer.clearCollectedData()
        self.transactionDetails = nil
    }
    
    
    func isComplete() -> Bool {
        
        
        if paymentMethod == nil {
            return false
        }
        
        if paymentMethod.isEntityTypeRequired() && payer.entityType == nil {
            return false
        }
        
        if !Array.isNullOrEmpty(paymentMethod.financialInstitutions) && transactionDetails?.financialInstitution == nil{
            return false
        }
        
        if paymentMethod._id == PaymentTypeId.ACCOUNT_MONEY.rawValue || !paymentMethod.isOnlinePaymentMethod() {
            return true
        }
        
        if paymentMethod!.isCard() && (token == nil || payerCost == nil) {
            
            if paymentMethod.paymentTypeId == "debit_card" && token != nil{
                return true
            }
            return false
        }

        return true
    }
    
    func hasCustomerPaymentOption() -> Bool {
        return self.paymentMethod != nil && (self.paymentMethod.isAccountMoney() || (self.token != nil && !String.isNullOrEmpty(self.token!.cardId)))
    }
    
    func toJSONString() -> String {
        return JSONHandler.jsonCoding(toJSON())
    }
    
    func toJSON() -> [String:Any] {
       var obj:[String:Any] = [
            "payment_method_id" : String(describing: self.paymentMethod._id)
       ]
       
        obj["installments"] = (self.payerCost != nil ) ? self.payerCost!.installments : ""
        obj["card_token_id"] = (self.token != nil ) ? self.token!._id : ""
        obj["issuer_id"] = (self.issuer != nil ) ? self.issuer!._id : ""
        obj["payer"] = (self.payer != nil) ? self.payer.toJSON() : ""
        obj["transaction_details"] = (self.transactionDetails != nil) ? self.transactionDetails?.toJSON() : ""
        
        return obj
    }

}

