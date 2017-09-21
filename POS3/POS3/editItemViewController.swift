//
//  editItemViewController.swift
//  POS3
//
//  Created by King Cheung on 23/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class EditItemViewController: UIViewController{

    @IBOutlet weak var searchBar: UITextField!

    @IBOutlet weak var editItemTitle: UILabel!
    
    @IBOutlet weak var editIemsTable: UIView!
    
    var filter = ""
    var listOfFilteredItemNum: [Int] = []
    
    
    
    @IBAction func searchChanged(_ sender: Any) {
        if let _filter = searchBar.text{
            print("happy")
            print(_filter)
            filter = searchBar.text!
            listOfFilteredItemNum = filterAllItems(filtrate: filter)
            listOfFilteredItemNum = listOfFilteredItemNum.sorted()
            print(listOfFilteredItemNum)
            for viewControllers in self.childViewControllers{
                if let tableVC = viewControllers as? EditItemTableViewController{
                    tableVC.listOfFilteredItemNum = listOfFilteredItemNum
                    if let view = tableVC.view as? UITableView{
                        view.reloadData()
                    }
                }
            }
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
            for viewControllers in self.childViewControllers{
                if let tableVC = viewControllers as? EditItemTableViewController{
                    tableVC.listOfFilteredItemNum = listOfFilteredItemNum
                    if let view = tableVC.view as? UITableView{
                        view.reloadData()
                    }
                }
            }
        }
    }

}
