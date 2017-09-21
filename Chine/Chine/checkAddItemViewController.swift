//
//  checkAddItemViewController.swift
//  POS3
//
//  Created by King Cheung on 23/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit
class checkAddItemViewController:  UIViewController{
    var itemCategory: String = ""
    var itemEnglishName: String = ""
    var itemPrice: Float = 0
    var itemChineseName: String = ""
    var itemCode: String = ""
    
 
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var englishName: UILabel!
    @IBOutlet weak var chineseName: UILabel!
    @IBOutlet weak var price: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        category.text = itemCategory
        code.text = itemCode
        englishName.text = itemEnglishName
        chineseName.text = itemChineseName
        price.text = String(itemPrice)
        
    }
    @IBAction func confirmAddItem(_ sender: Any) {
        updateMenu(itemCode: itemCode, itemEnglishName: itemEnglishName, itemChineseName: itemChineseName, itemCategory: itemCategory, itemPrice: itemPrice)
//        dismiss(animated: false, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AddItemViewController{
                destination.justPreviouslyAdded = true
        }
    }
    
}
