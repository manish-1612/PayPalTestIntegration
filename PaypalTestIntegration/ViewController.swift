//
//  ViewController.swift
//  PaypalTestIntegration
//
//  Created by Manish Kumar on 13/10/16.
//  Copyright © 2016 Innofied Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var payPalConfig : PayPalConfiguration!
    

    // MARK :- Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ----------------------------------------------------------------
        //   Paypal payment configuration
        // ----------------------------------------------------------------

        payPalConfig = PayPalConfiguration()
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "manish.12.16.90-facilitator@gmail.com"

        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = NSURL(string : "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0]
        payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOption.PayPal
    }
    
    override func viewWillAppear(animated: Bool) {
        //do as per your desire
        
        PayPalMobile.preconnectWithEnvironment(PayPalEnvironmentSandbox)

    }
    
    override func viewWillDisappear(animated: Bool) {
        //do as per your desire
    }
    
    override func viewDidAppear(animated: Bool) {
        //do as per your desire
    }
    
    override func viewDidDisappear(animated: Bool) {
        //do as per your desire
    }
    
    // MARK :- Memory warning handling
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Paypal payment process commencing function
    @IBAction func makePaymentProcess(sender: UIButton) {
        
        let item1 = PayPalItem(name: "iPhone5S", withQuantity: 3, withPrice: NSDecimalNumber(double : 755.00), withCurrency:"USD", withSku: "SKU-iPhone5S")
        let item2 = PayPalItem(name: "MacbookAir", withQuantity: 2, withPrice: NSDecimalNumber(double : 1669.00), withCurrency:"USD", withSku: "SKU-MacBookAir")
        
        
        let items = [item1, item2]
        
        let subTotal = PayPalItem.totalPriceForItems(items)
        let shippingAddress = NSDecimalNumber(string: "5.66")
        let tax = NSDecimalNumber(string: "1.25")
        
        let paymentDetails = PayPalPaymentDetails(subtotal: subTotal, withShipping: shippingAddress, withTax: tax)
        let total  = (subTotal.decimalNumberByAdding(shippingAddress)).decimalNumberByAdding(tax)
        
        
        let payment = PayPalPayment(amount: total, currencyCode:"USD" , shortDescription: "My payment 2", intent: PayPalPaymentIntent.Sale)
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        
        if payment.processable{
            let paymentVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            self.presentViewController(paymentVC!, animated: true, completion: nil)
        }else{
            print("Payment not processable: \(payment)")
        }
    }
    
    
    //MARK:- Stripe payment process commencing function
    @IBAction func makePaymentThroughStripe(sender: AnyObject) {
        
        
    }
    
    

}

//MARK:- Paypal Delegates
extension ViewController : PayPalPaymentDelegate{
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController) {
        //do something
        print("failure payment cancelled")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, didCompletePayment completedPayment: PayPalPayment) {
        //do something
        print("success in did complete")
        print("PAYEMENT : \(completedPayment)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController, willCompletePayment
        completedPayment: PayPalPayment, completionBlock: PayPalPaymentDelegateCompletionBlock) {
        
        
      //print("confirmation : \(completedPayment.confirmation)")
        
       completionBlock()
    
    }
}