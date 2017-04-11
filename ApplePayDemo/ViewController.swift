//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by Charles on 11/04/17.
//  Copyright © 2017 Charles. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController {

    var paymentRequest: PKPaymentRequest!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func payAction(_ sender: UIButton) {
        let paymentNetworks = [PKPaymentNetwork.amex,.carteBancaire, .chinaUnionPay, .discover, .interac, .JCB, .masterCard]
        
        if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentNetworks) {
            paymentRequest = PKPaymentRequest()
            paymentRequest.countryCode = "NZ"
            paymentRequest.currencyCode = "NZD"
            paymentRequest.merchantIdentifier = "com.Levi's.Co"
            paymentRequest.supportedNetworks = paymentNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.requiredShippingAddressFields = [.all]
            paymentRequest.paymentSummaryItems = createPaymentSummaryItem(shipping: 9.99)
            
            let oneDayMethod = PKShippingMethod(label: "One day shipping", amount: 14.99)
            oneDayMethod.detail = "Delivery is guaranteed within one day"
            oneDayMethod.identifier = "oneDayDelivery"
            
            let twoDayMethod = PKShippingMethod(label: "One daynshipping", amount: 6.99)
            twoDayMethod.detail = "Delivery is guaranteed within two days"
            twoDayMethod.identifier = "twoDayDelivery"

            let threeDayMethod = PKShippingMethod(label: "One daynshipping", amount: 1.99)
            threeDayMethod.detail = "Delivery is guaranteed within three days"
            threeDayMethod.identifier = "twoDayDelivery"
            
            paymentRequest.shippingMethods = [oneDayMethod, twoDayMethod, threeDayMethod]
            
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            self.present(applePayVC, animated: true, completion: nil)
            applePayVC.delegate = self

        } else {
            print("please set up Apple Pay")
        }
    }
    
    func createPaymentSummaryItem(shipping: Double) -> [PKPaymentSummaryItem] {
        let productItem = PKPaymentSummaryItem(label: "Levi's Jeans", amount: 99.99)
        let discountItem = PKPaymentSummaryItem(label: "Discount", amount: -49.99)
        let shippingItem = PKPaymentSummaryItem(label: "Shipping", amount: NSDecimalNumber(value: shipping))
        
        let totalAmount = productItem.amount.adding(discountItem.amount).adding(shippingItem.amount)
        let priceItem = PKPaymentSummaryItem(label: "Levi's Co.", amount: totalAmount)
        
        return [productItem, discountItem, shippingItem, priceItem]
    }
    
}

extension ViewController:PKPaymentAuthorizationViewControllerDelegate {
   
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
         completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(PKPaymentAuthorizationStatus.success, createPaymentSummaryItem(shipping: Double(shippingMethod.amount)))
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

