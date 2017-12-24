//
//  CheckCancelOrderViewController.swift
//  POS3
//
//  Created by King Cheung on 24/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class CheckCancelOrderViewController: UIViewController{
    
    var orderNumber: Int = 0
    
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var orderPrice: UILabel!

 
    override func viewDidLoad() {
        let order: (Int, [Int], Date, Float, String, String, [Int: String], [Int: [Int]], Int, Bool, [Int]) = getOrderNumber(orderNum: orderNumber)
            orderNum.text = String(order.0)
            customerName.text = order.4
            phoneNum.text = order.5
            orderPrice.text = String(order.3)
        
    }
    
    @IBOutlet weak var cancelOrder: UIButton!
    @IBAction func cancel(_ sender: Any) {
        cancelOrderOfNum(orderNum: Int(orderNum.text!)!)
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UINavigationController{
            for vc in destination.viewControllers{
                if let root = vc as? ViewController{
                    root.segmentedControl.selectedSegmentIndex = 0
                    
                    root.updateView()
                }
            }
        }
    }
}
