//
//  EditOrDeleteItemViewController.swift
//  POS3
//
//  Created by King Cheung on 24/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class EditOrDeleteItemViewController: UIViewController{
    var category: String = ""
    var code: String = ""
    var englishName: String = ""
    var chineseName: String = ""
    var price: Float = 0
    var previousViewController: EditItemTableViewController? = nil
    
    var itemEngNameIsString: Bool = true
    var itemCatIsString: Bool = true
    var itemPriceIsFloat: Bool = true
    
    override func viewDidLoad() {
        itemCategory.text = category
        itemCode.text = code
        itemEnglishName.text = englishName
        itemChineseName.text = chineseName
        itemPrice.text = String(price)
    }
    
    var itemNum: Int = 0
    @IBOutlet weak var itemCategory: UITextField!
    @IBOutlet weak var itemCode: UITextField!
    @IBOutlet weak var itemEnglishName: UITextField!
    @IBOutlet weak var itemChineseName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!

    @IBOutlet weak var deleteButton: UIButton!

    @IBOutlet weak var editButton: UIButton!
    
    
    @IBAction func ItemCatEdited(_ sender: Any) {
        if let text = itemCategory.text{
            if text.characters.count > 1 {
                itemCatIsString = true
                testAndEnableButton()
            }
            else {
                itemCatIsString = false
                testAndEnableButton()
            }
        }
        else{
            itemCatIsString = false
            testAndEnableButton()
        }
    }
    @IBAction func ItemEngNameEdited(_ sender: Any) {
        if let text = itemEnglishName.text{
            if text.characters.count > 1{
                itemEngNameIsString = true
                testAndEnableButton()
            }
            else {
                itemEngNameIsString = false
                testAndEnableButton()
            }
        }
        else{
            itemEngNameIsString = false
            testAndEnableButton()
        }
    }
    @IBAction func ItemPriceEdited(_ sender: Any) {
        if let text = itemPrice.text{
            if Float(text) != nil{
                itemPriceIsFloat = true
                testAndEnableButton()
            }
            else {
                itemPriceIsFloat = false
                testAndEnableButton()
            }
        }
        else{
            itemPriceIsFloat = false
            testAndEnableButton()
        }
    }
    func testAndEnableButton(){
        if !itemEngNameIsString || !itemCatIsString || !itemPriceIsFloat {
            editButton.isEnabled = false
        }
        else{
            editButton.isEnabled = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckEditItemViewController{
            destination.category = itemCategory.text!
            destination.price = Float(itemPrice.text!)!
            destination.code = itemCode.text!
            destination.chineseName = itemChineseName.text!
            destination.englishName = itemEnglishName.text!
            destination.itemNum = itemNum
            destination.previousViewController = self
        }
        else if let destination = segue.destination as? CheckDeleteItemViewContoller{
            destination.category = itemCategory.text!
            destination.price = Float(itemPrice.text!)!
            destination.code = itemCode.text!
            destination.chineseName = itemChineseName.text!
            destination.englishName = itemEnglishName.text!
            destination.itemNum = itemNum
            destination.previousViewController = self
        }

    }
    
}
