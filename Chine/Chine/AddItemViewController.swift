//
//  AddItemViewController.swift
//  POS3
//
//  Created by King Cheung on 23/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController{
    
    var itemEngNameIsString: Bool = false
    var itemCatIsString: Bool = false
    var itemPriceIsFloat: Bool = false
    var justPreviouslyAdded: Bool = false
    
    var category: String = ""
    var code: String = ""
    var engName: String = ""
    var chinName: String = ""
    var price: Float = 0
    
    @IBOutlet weak var itemCat: UITextField!
    @IBOutlet weak var itemCode: UITextField!
    @IBOutlet weak var itemEngName: UITextField!
    @IBOutlet weak var itemChinName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var addButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        testAndEnableButton()
        if justPreviouslyAdded{
            itemCat.text = ""
            itemCode.text = ""
            itemEngName.text = ""
            itemChinName.text = ""
            itemPrice.text = ""
        }
    }
    
    
    @IBAction func ItemCatEdited(_ sender: Any) {
        if let text = itemCat.text{
            if text.count > 1 {
                itemCatIsString = true
                category = text
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
    @IBAction func ItemCodeEdited(_ sender: Any) {
        if let text = itemCode.text{
            code = text
        }
        else{}
    }
    @IBAction func ItemEngNameEdited(_ sender: Any) {
        if let text = itemEngName.text{
            if text.count > 1{
                itemEngNameIsString = true
                engName = text
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

    @IBAction func itemChinNameEdited(_ sender: Any) {
        if let text = itemChinName.text{
            chinName = text
        }
        else{}
    }
    
    
    @IBAction func ItemPriceEdited(_ sender: Any) {
        if let text = itemPrice.text{
            if let value = Float(text){
                itemPriceIsFloat = true
                price = value
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
    
    
    @IBAction func addItemAction(_ sender: Any) {
        
        itemCat.endEditing(true)
        itemPrice.endEditing(true)
        itemEngName.endEditing(true)
        testAndEnableButton()
    }
    
    
    func testAndEnableButton(){
        if !itemEngNameIsString || !itemCatIsString || !itemPriceIsFloat {
        addButton.isEnabled = false
        }
        else{
        addButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? checkAddItemViewController{
            destination.itemCategory = category
            destination.itemPrice = price
            destination.itemCode = code
            destination.itemChineseName = chinName
            destination.itemEnglishName = engName
            destination.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        }
    }
}
