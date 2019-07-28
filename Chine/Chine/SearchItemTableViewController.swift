//
//  EditItemTableViewController.swift
//  POS3
//
//  Created by King Cheung on 23/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class SearchItemTableViewController: UITableViewController{
    
    @IBOutlet var searchTable: UITableView!
    //    var editThisItem: (itemNum: Int, itemCategory: String, itemCode: String, itemEnglishName: String, itemChineseName: String, itemPrice: Float) = (0, "", "", "", "", 0)
    var filter = ""
    var listOfFilteredItemNum: [Int] = []
    
    @IBOutlet weak var searchBar: UITextField!
    @IBAction func searchChanged(_ sender: Any) {
        if let _filter = searchBar.text{
            print(_filter)
        }
        else{
            _filter = ""
        }
    }
    
    
    var _filter: String{
        get{
            return filter
        }
        set{
            filter = newValue
            listOfFilteredItemNum = filterAllItems(filtrate: filter)
            listOfFilteredItemNum = listOfFilteredItemNum.sorted()
            print(listOfFilteredItemNum)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFilteredItemNum.count // change this to number of items in the menu
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SearchItemTableViewCell {
        print("setting up table")
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "filteredCell",
            for: indexPath) as! SearchItemTableViewCell
        let row = indexPath.row
        let order = getItemOfNum(itemNum: listOfFilteredItemNum[row])
        cell.itemCategory.text = order.itemCategory
//        cell.itemCode.text = order.itemCode
        cell.itemName.text = order.itemEngName
//        cell.itemChinName.text = order.itemChinName
        cell.tag = Int(order.itemNum)
        cell.itemPrice.text = String(order.itemPrice)
        cell.restorationIdentifier = String(listOfFilteredItemNum[row])
        //        editThisItem = (order.itemNum, order.itemCategory, order.itemCode, order.itemEngName, order.itemChinName, order.itemPrice)
        
        return cell
        
    }
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell = tableView.cellForRow(at: indexPath)
        print(cell!.tag)
        if let parent = self.parent as? ViewController{
            parent.addItemToOrderFromSearch(tag: cell!.tag)
        }
        print(type(of: self.parent))
    }
    
    
    @IBOutlet var orderItems: UITableView!
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let buttonSender = sender as? SearchItemTableViewCell{
////            if let destination = segue.destination as? EditOrDeleteItemViewController{
////                let order = getItemOfNum(itemNum: Int(buttonSender.restorationIdentifier!)!)
////                destination.category = order.itemCategory
////                destination.code = order.itemCode
////                destination.englishName = order.itemEngName
////                destination.chineseName = order.itemChinName
////                destination.price = order.itemPrice
////                destination.itemNum = Int(buttonSender.restorationIdentifier!)!
////                destination.previousViewController = self
////            }
//        }
//    }
    func resetTable(){
        listOfFilteredItemNum = filterAllItems(filtrate: filter)
        listOfFilteredItemNum = listOfFilteredItemNum.sorted()
        searchTable.reloadData()
    }
}
