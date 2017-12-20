//
//  AddOnViewController.swift
//  POS3
//
//  Created by King Cheung on 25/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class AddOnViewController: UIViewController{
   
    var previousController: OrderItemsTableViewController? = nil
    var itemNum: Int = 0
    var itemNameString: String = ""
    
    
    @IBAction func removeItem(_ sender: Any) {
        newOrder.sharedInstance.deleteItemFromOrder(itemNo: itemNum)
        previousController?.reloadTable()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBOutlet weak var itemName: UILabel!
    var listOfSelectedAddonNumbers: [Int] = []
    var listOfSelectedComments: [String] = []
    var genComment: String = ""
    
    
    let listOfAllAddOns: [Int] = getAllAddOnOptions()
    
    @IBOutlet weak var addOnStack: UIStackView!
    
    override func viewDidLoad() {
        self.view.sizeToFit()
        let allAddons = getAllAddOnOptions()
        var listOfJustItems:[Int] = []
        for x in 0 ..< itemNum{
            if !allAddons.contains(newOrder.sharedInstance.orderItemsAndAddons[x]){
                listOfJustItems.append(newOrder.sharedInstance.orderItemsAndAddons[x])
            }
        }
        let itemNoWithoutAddons = listOfJustItems.count
//        var order = newOrder.sharedInstance.orderItems
        itemName.text = itemNameString
        if let addons = newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]{
            listOfSelectedAddonNumbers = addons
        }
        for addon in listOfSelectedAddonNumbers{
            listOfSelectedComments.append(getItemName(Int16(addon)))
        }
        for count in 0..<listOfAllAddOns.count/3 + 1{
            let stack = makeVertButtonStack()
            stack.restorationIdentifier = String(count)
            for addOnNum in 0..<listOfAllAddOns.count{
                let x = Int(addOnNum/3)
                if x == count{
                    stack.addArrangedSubview(makeButtonWithText(text: getItemName(Int16(listOfAllAddOns[addOnNum])), addOnID: listOfAllAddOns[addOnNum]))
                }
            }
            addOnStack.addArrangedSubview(stack)
        }
    }


    func makeButtonWithText(text:String, addOnID: Int) -> UIButton {
        let allAddons = getAllAddOnOptions()
        var listOfJustItems:[Int] = []
        for x in 0 ..< itemNum{
            if !allAddons.contains(newOrder.sharedInstance.orderItemsAndAddons[x]){
                listOfJustItems.append(newOrder.sharedInstance.orderItemsAndAddons[x])
            }
        }
        let itemNoWithoutAddons = listOfJustItems.count
        let myButton = UIButton(type: UIButtonType.system)
        //Set a frame for the button. Ignored in AutoLayout/ Stack Views
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.setTitle(text, for: .normal)
        if let addons = newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]{
            myButton.backgroundColor = UIColor.lightGray
            if addons.contains(addOnID){
                myButton.isSelected = true
                myButton.backgroundColor = UIColor(red: 0.698, green: 0.133, blue: 0.133, alpha: 1.0)
            }
        }
        else{
            myButton.isSelected = false
            myButton.backgroundColor = (UIColor.lightGray)
        }
        
        myButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 12)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.addTarget(self, action: #selector(toggleAddOn), for: .touchUpInside)
        myButton.tag = addOnID
        
        
        return myButton
    }
    
    @objc func toggleAddOn(sender: UIButton){
        let allAddons = getAllAddOnOptions()
        var listOfJustItems:[Int] = []
        for x in 0 ..< itemNum{
            if !allAddons.contains(newOrder.sharedInstance.orderItemsAndAddons[x]){
                listOfJustItems.append(newOrder.sharedInstance.orderItemsAndAddons[x])
            }
        }
        let itemNoWithoutAddons = listOfJustItems.count
        if !sender.isSelected{
            sender.isSelected = true
            sender.backgroundColor = UIColor(red: 0.698, green: 0.133, blue: 0.133, alpha: 1.0)
            print((sender.title(for: .normal))!)
            listOfSelectedComments.append((sender.title(for: .normal))!)
            resetComment(addOnItemNum: itemNoWithoutAddons)
            newOrder.sharedInstance.addAddonAtPosition(itemNum: sender.tag, pos: itemNum+1)
            if newOrder.sharedInstance.orderAddons[itemNoWithoutAddons] != nil{
                newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]!.append(sender.tag)
                print(newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]!)
            }
            else{
                newOrder.sharedInstance.orderAddons[itemNoWithoutAddons] = [sender.tag]
            }
        }
        else{
            sender.backgroundColor = UIColor.lightGray
            sender.isSelected = false
            print((sender.title(for: .normal))!)
            listOfSelectedComments.remove(at: listOfSelectedComments.index(of: (sender.title(for: .normal))!)!)
            resetComment(addOnItemNum: itemNoWithoutAddons)
           
            if let addon = newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]{
                newOrder.sharedInstance.orderItemsAndAddons.remove(at: itemNum + (addon.count - addon.index(of: sender.tag)!)
                )
                newOrder.sharedInstance.orderAddons[itemNoWithoutAddons]!.remove(at: addon.index(of: sender.tag)!)
            }
        }
        previousController?.reloadTable()
        if let parent = previousController?.parent as? ViewController{
            parent._price = newOrder.sharedInstance.getPrice()
        }
    }
    
    func makeVertButtonStack() -> UIStackView{
        let myStack = UIStackView()
        myStack.axis = .horizontal
        myStack.distribution = .fillEqually
        myStack.spacing = 10
        myStack.alignment = .fill
        return myStack
    }
    func resetComment(addOnItemNum: Int){
        var comment: String = ""
        for addon in listOfSelectedComments{
            comment.append(addon)
            comment.append("|")
        }
        comment.append(genComment)
        newOrder.sharedInstance.addItemComment(itemNum: addOnItemNum, comment: comment)
    
    }
    
}

    
