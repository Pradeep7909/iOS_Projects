//
//  File.swift
//  Arfof Demo
//
//  Created by Qualwebs on 29/01/24.
//

import Foundation
import UIKit

class ATMViewController: UIViewController{
    
    private var balance : Double = 1000
    private var currentSegment = 0
    
    //MARK: IBOutlets
    @IBOutlet weak var balanceLabel : UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var submitButtonLabel: UILabel!
    @IBOutlet weak var transactionDetailLabel: UILabel!
    @IBOutlet weak var amontTextField: UITextField!
    
    override func viewDidLoad() {
        balanceLabel.text = "\(balance)"
        segmentControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
    }
    
    //MARK: IBAction
    @IBAction func submitButtonAction(_ sender: Any) {
        guard let amount =  amontTextField.text else{ return }
        currentSegment == 0 ? withdraw(value: Double(amount) ?? 0) : depositeMoney(value: Double(amount) ?? 0 )
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            submitButtonLabel.text = "Withdraw"
            transactionDetailLabel.text = "Do you want to Withdraw money ?"
            currentSegment = 0
            amontTextField.text = ""
        case 1:
            submitButtonLabel.text = "Deposite"
            transactionDetailLabel.text = "Do you want to Deposite money ?"
            currentSegment = 1
            amontTextField.text = ""
        default:
            break
        }
    }
    
    
    //1. concurrent queue allow withdraw even when balance is less.
    //    func withdraw(value : Double){
    //        DispatchQueue.global().async {
    //            print("Checking Balance")
    //            DispatchQueue.main.async{ self.transactionDetailLabel.text = "Checking Balance" }
    //
    //            if self.balance >= value{
    //                print("Balance is sufficient wait while processing the withdrawal")
    //                DispatchQueue.main.async {self.transactionDetailLabel.text = "Balance is sufficient wait while processing the withdrawal"}
    //                sleep(5)
    //                DispatchQueue.main.async {
    //                    self.balance -= value
    //                    print("\(value) has been withdrawn, current Balance is \(self.balance)")
    //                    self.transactionDetailLabel.text = "\(value) has been withdrawn, current Balance is \(self.balance)"
    //                    self.balanceLabel.text = "\(self.balance)"
    //                }
    //
    //            }else{
    //                print("Insufficient Balance")
    //                DispatchQueue.main.async { self.transactionDetailLabel.text = "Insufficient Balance : \(self.balance)" }
    //            }
    //        }
    //    }
    
    //    // 2. NSLOCK: it lock that peice of code next withdraw execute after these execute complete
    //    let lock = NSLock()
    //    func withdraw(value : Double){
    //        //lock these code
    //        DispatchQueue.global().async {
    //            self.lock.lock()
    //            print("Checking Balance")
    //            DispatchQueue.main.async{ self.transactionDetailLabel.text = "Checking Balance" }
    //
    //            if self.balance >= value{
    //                print("Balance is sufficient wait while processing the withdrawal")
    //                DispatchQueue.main.async {self.transactionDetailLabel.text = "Balance is sufficient wait while processing the withdrawal"}
    //                sleep(5)
    //                DispatchQueue.main.async {
    //                    self.balance -= value
    //                    print("\(value) has been withdrawn, current Balance is \(self.balance)")
    //                    self.transactionDetailLabel.text = "\(value) has been withdrawn, current Balance is \(self.balance)"
    //                    self.balanceLabel.text = "\(self.balance)"
    //                    self.lock.unlock()
    //                }
    //
    //            }else{
    //                print("Insufficient Balance")
    //                DispatchQueue.main.async { self.transactionDetailLabel.text = "Insufficient Balance : \(self.balance)" }
    //                self.lock.unlock()
    //            }
    //        }
    //    }
    
    // 3.serialQueue
    //    let serialQueue = DispatchQueue(label: "Serial Queue")
    //
    //    func withdraw(value : Double){
    //        serialQueue.async {
    //            print("Checking Balance")
    //            DispatchQueue.main.async{ self.transactionDetailLabel.text = "Checking Balance" }
    //
    //            if self.balance >= value{
    //                print("Balance is sufficient wait while processing the withdrawal")
    //                DispatchQueue.main.async {self.transactionDetailLabel.text = "Balance is sufficient wait while processing the withdrawal"}
    //                sleep(5)
    //                self.balance -= value
    //                DispatchQueue.main.async {
    //                    print("\(value) has been withdrawn, current Balance is \(self.balance)")
    //                    self.transactionDetailLabel.text = "\(value) has been withdrawn, current Balance is \(self.balance)"
    //                    self.balanceLabel.text = "\(self.balance)"
    //                }
    //
    //            }else{
    //                print("Insufficient Balance")
    //               DispatchQueue.main.async { self.transactionDetailLabel.text = "Insufficient Balance : \(self.balance) , you attempt to withdraw \(value)" }
    //            }
    //        }
    //    }
    
    //4. concurrent queue with flag as .barrier
//    let concurrentQueue = DispatchQueue(label: "Serial Queue", attributes: .concurrent)
//    
//    func withdraw(value : Double){
//        concurrentQueue.async(flags: .barrier) {
//            print("Checking Balance")
//            DispatchQueue.main.async{ self.transactionDetailLabel.text = "Checking Balance" }
//            
//            if self.balance >= value{
//                print("Balance is sufficient wait while processing the withdrawal")
//                DispatchQueue.main.async {self.transactionDetailLabel.text = "Balance is sufficient wait while processing the withdrawal"}
//                sleep(5)
//                self.balance -= value
//                DispatchQueue.main.async {
//                    print("\(value) has been withdrawn, current Balance is \(self.balance)")
//                    self.transactionDetailLabel.text = "\(value) has been withdrawn, current Balance is \(self.balance)"
//                    self.balanceLabel.text = "\(self.balance)"
//                }
//                
//            }else{
//                print("Insufficient Balance")
//                DispatchQueue.main.async { self.transactionDetailLabel.text = "Insufficient Balance : \(self.balance) , you attempt to withdraw \(value)" }
//            }
//        }
//    }
    
    //5. Operation Queue (if waitUnitFinished is false next withdraw will start even when first is in progress..)
    let operationQueue = OperationQueue()
    func withdraw(value : Double){
        let operation = BlockOperation{
            print("Checking Balance")
            DispatchQueue.main.async{ self.transactionDetailLabel.text = "Checking Balance" }
            
            if self.balance >= value{
                print("Balance is sufficient wait while processing the withdrawal")
                DispatchQueue.main.async {self.transactionDetailLabel.text = "Balance is sufficient wait while processing the withdrawal"}
                sleep(5)
                self.balance -= value
                DispatchQueue.main.async {
                    print("\(value) has been withdrawn, current Balance is \(self.balance)")
                    self.transactionDetailLabel.text = "\(value) has been withdrawn, current Balance is \(self.balance)"
                    self.balanceLabel.text = "\(self.balance)"
                }
                
            }else{
                print("Insufficient Balance")
                DispatchQueue.main.async { self.transactionDetailLabel.text = "Insufficient Balance : \(self.balance) , you attempt to withdraw \(value)" }
            }
        }
        operationQueue.addOperations([operation], waitUntilFinished: true)
    }
    
    
    func depositeMoney(value: Double){
        balance += value
        print("balance \(value) ")
        transactionDetailLabel.text = "\(value) has been deposited in account , current balance is : \(balance)"
        balanceLabel.text = "\(balance)"
    }
    
    
}
