//
//  TableViewController.swift
//  POS3
//
//  Created by King Cheung on 19/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class OrderListTableViewController: UITableViewController{
    
    @IBOutlet weak var total: UILabel!
    func setTotalPriceLabel(){
        let allPrices = getAllOrderPrices()
        var totalM: Float = 0
        for price in allPrices{
            totalM += Float(price)!
        }
        total.text = "£"+String(totalM)
    }
    
    override func viewDidLoad() {
        let allPrices = getAllOrderPrices()
        var totalM: Float = 0
        for price in allPrices{
            totalM += Float(price)!
        }
        total.text = "£"+String(totalM)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (getAllOrders().count) // change this to number of items in the menu
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OrderListTableCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as! OrderListTableCell
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let row = getAllOrders().count - indexPath.row - 1
        let allOrders: [(Int, [Int], Date, String, String, String, Int, Bool, [Int])]  = getAllOrders()
        
        cell.orderNumber!.text = ("\(allOrders[row].0)")
        let price =  (allOrders[row].3)
        cell.orderPrice!.text! = ("£") + price
        
        
        cell.orderDate!.text! = formatter.string(from: allOrders[row].2) 
        let name = (allOrders[row].4)
        cell.orderCustomerName!.text! = name
        
        let phone = (allOrders[row].5)
        cell.orderCustomerPhone!.text! = phone
        
        
        cell.restorationIdentifier = ("\(getAllOrderNumbers()[row])")
                return cell
        
    }
    @IBOutlet var orderItems: UITableView!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let buttonSender = sender as? OrderListTableCell{
            if let destination = segue.destination as? OrderTableViewController{
                destination.orderNum = Int(buttonSender.restorationIdentifier!)!
            }
        }
    }
    
}
