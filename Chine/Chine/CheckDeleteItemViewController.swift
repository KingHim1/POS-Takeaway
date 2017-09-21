//
//  CheckDeleteItemViewController.swift
//  POS3
//
//  Created by King Cheung on 24/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class CheckDeleteItemViewContoller: UIViewController{
    var category: String = ""
    var code: String = ""
    var englishName: String = ""
    var chineseName: String = ""
    var price: Float = 0
    var itemNum: Int = 0
    var previousViewController: EditOrDeleteItemViewController? = nil
    
    override func viewDidLoad() {
        itemCategory.text = category
        itemCode.text = code
        itemEnglishName.text = englishName
        itemChineseName.text = chineseName
        itemPrice.text = String(price)
    }
    
    @IBOutlet weak var itemCategory: UILabel!
    @IBOutlet weak var itemCode: UILabel!
    @IBOutlet weak var itemEnglishName: UILabel!
    @IBOutlet weak var itemChineseName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    
    
    @IBAction func confirmDelete(_ sender: Any) {
        deleteItemFromDatabase(itemNum: itemNum)
        previousViewController?.previousViewController?.resetTable()
    }
}
