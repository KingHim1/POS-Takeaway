//
//  OrderItemsTableViewController.swift
//  POS3
//
//  Created by King Cheung on 22/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class OrderItemsTableViewController: UITableViewController{
    
    
    @IBOutlet var orderData: UITableView!
        override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newOrder.sharedInstance.orderItemsAndAddons.count // change this to number of items in the order - also needs to be a class method
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> OrderItemsTableCell {
        
        let allAddons = getAllAddOnOptions()
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as! OrderItemsTableCell
        let row = indexPath.row
        var listOfJustItems:[Int] = []
        for x in 0 ..< row{
            if !allAddons.contains(newOrder.sharedInstance.orderItemsAndAddons[x]){
                listOfJustItems.append(newOrder.sharedInstance.orderItemsAndAddons[x])
            }
        }
        let itemNoWithoutAddons = listOfJustItems.count
        let itemNumbersInOrder = newOrder.sharedInstance.orderItemsAndAddons
        print(itemNumbersInOrder)
        var price: Float = Float(getItemPrice(Int16(itemNumbersInOrder[row])))
        if let addons = newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]{
            for addon in addons{
                price += getItemPrice(Int16(addon))
            }
        }
        
        
        cell.itemNum = row
        if allAddons.contains(itemNumbersInOrder[row]){
            cell.itemName?.text! = ("\(String(describing: getItemName(Int16(itemNumbersInOrder[row]))))")
            cell.itemName?.font = UIFont(name: "Helvetica", size: 12)
            cell.itemsQuantity?.text! = ""
            cell.itemsPrice?.text! = ""
            cell.isUserInteractionEnabled = false
        }
        else{
            price = newOrder.sharedInstance.getItPrice(itemNum: itemNoWithoutAddons ) * Float(newOrder.sharedInstance.getItemQuantity(itemIndex: itemNoWithoutAddons))
            if let addons = newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]{
                for addon in addons{
                    price += getItemPrice(Int16(addon))
                }
            }
            print(price)
            cell.itemName?.text! = ("\(String(describing: getItemName(Int16(itemNumbersInOrder[row]))))")
            cell.itemsPrice?.text! = ("£") +  ("\(price)")
            cell.itemName?.font = UIFont(name: "Helvetica", size: 19)
            let quantity: Int = Int(newOrder.sharedInstance.getItemQuantity(itemIndex: itemNoWithoutAddons))
            cell.itemsQuantity?.text! = String(quantity) + "x "
            cell.isUserInteractionEnabled = true
        }
        return cell
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddOnViewController{
            if let button = sender as? OrderItemsTableCell{
                destination.itemNameString = button.itemName.text!
                destination.itemNum = button.itemNum
                destination.previousController = self
            }
        }
    }
    func reloadTable(){
        tableView.reloadData()
        if let parent = self.parent as? ViewController{
            parent._price = newOrder.sharedInstance.getPrice()
        }
    }
}
