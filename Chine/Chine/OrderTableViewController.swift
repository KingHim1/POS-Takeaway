//
//  OrderTableViewController.swift
//  POS3
//
//  Created by King Cheung on 23/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController{
    
    var orderNum: Int = 0
    
    @IBAction func reprintOrder(_ sender: Any) {
        let commands: Data
        let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
        
        let _: Int = AppDelegate.getSelectedPaperSize().rawValue
        
        let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(AppDelegate.getSelectedLanguage(), paperSizeIndex: AppDelegate.getSelectedPaperSize(), orderNum: orderNum)
        
        commands = PrinterFunctions.createTextReceiptData(emulation, localizeReceipts: localizeReceipts, utf8: true)
        let portName:     String = AppDelegate.getPortName()
        let portSettings: String = AppDelegate.getPortSettings()
        
        _ = Communication.sendCommands(commands, portName: portName, portSettings: portSettings, timeout: 10000, completionHandler: { (result: Bool, title: String, message: String) in     // 10000mS!!!
            
            let alertView: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            alertView.popoverPresentationController?.sourceView = self.view
            
            
            self.present(alertView, animated: true, completion: nil)
        })
    }
    @IBOutlet weak var reprintOrder: UIButton!
    @IBAction func getOrderForTable(sender: UIStoryboardSegue){
        if sender.source is OrderListTableViewController{
            orderNum = Int(self.restorationIdentifier!)!
            print("test")
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let order: (Int, [Int], Date, Float, String, String, [Int: String], [Int: [Int]], Int,Bool) = getOrderNumber(orderNum: orderNum)
        return order.1.count // change this to number of items in the menu
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OrderTableCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as! OrderTableCell
        let row = indexPath.row
        let order: (Int, [Int], Date, Float, String, String, [Int: String], [Int: [Int]], Int, Bool) = getOrderNumber(orderNum: orderNum)
        let listOfItems = order.1
        var price: Float = getItemPrice(Int16(order.1[row]))
        if let arr = order.7[row]{
            for items in arr{
                price += Float(getItemPrice(Int16(items)))
            }
        }
        cell.itemComment?.text! = order.6[row]!
        cell.itemsPrice?.text! = String(price)
        cell.itemName?.text! =  ("") + getItemName(Int16(listOfItems[row]))
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckCancelOrderViewController   {
            destination.orderNumber = orderNum
            
        }
    }
}
