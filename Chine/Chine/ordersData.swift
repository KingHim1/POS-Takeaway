//
//  ordersData.swift
//  POS3
//
//  Created by King Cheung on 21/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit
import CoreData

class orderItem{
    @NSManaged var orderNumber: Int
    @NSManaged var orderItems:  [Int]
    @NSManaged var orderDateAndTime: Date
    @NSManaged var orderPrice : Float
    @NSManaged var orderCustName: String
    @NSManaged var orderPhoneNum: String
    @NSManaged var orderComment: [Int: String]
    @NSManaged var orderItemAddons: [Int: [Int]]
    @NSManaged var orderPickupTime: Int
    @NSManaged var orderAsCollection: Bool
    @NSManaged var orderItemQuantity: [Int]
}

class newOrder{
    static let sharedInstance = newOrder()
    private init(){}
    private var _orderNum: Int = 1
    private var _orderItems: [Int] = []
    private var _orderPrice: Float = 0.0
    private var _orderDateAndTime = Date.init(timeIntervalSinceNow: 0)
    private var _orderCustName: String = ""
    private var _orderPhoneNum: String = ""
    private var _orderComment: [Int: String] = [:]
    private var _orderAddons: [Int: [Int]] = [:]
    private var _orderItemAddons: [Int: [Int]] = [:]
    private var _orderPickupTime: Int = 0
    private var _orderAsCollection: Bool = true
    private var _orderItemQuantity: [Int] = []
    var orderItemsAndAddons: [Int] = []
    
    func setCollectionOrTakeAway(colOrTake: Bool){
        _orderAsCollection = colOrTake
    }
    func setPickupTime(time: Float){
        _orderPickupTime = Int(time)
    }
    
    func deleteItemFromOrder(itemNo: Int){
        let allAddons = getAllAddOnOptions()
        var listOfJustItems:[Int] = []
        for x in 0 ..< itemNo{
            if !allAddons.contains(orderItemsAndAddons[x]){
                listOfJustItems.append(orderItemsAndAddons[x])
            }
        }
        let itemNoWithoutAddons = listOfJustItems.count
        if let addons = orderAddons[itemNoWithoutAddons]{
            let numAddons = addons.count
            for _ in itemNo ..< itemNo + numAddons + 1 {
                orderItemsAndAddons.remove(at: itemNo)
            }
        }
        else{
            orderItemsAndAddons.remove(at:itemNo)
        }

        for x in itemNoWithoutAddons ..< orderItems.count - 1{
            _orderComment.updateValue(_orderComment[x+1]!, forKey: x)
            if orderAddons[x+1] != nil{
                orderAddons.updateValue(orderAddons[x+1]!, forKey: x)
            }
            else{
                orderAddons.removeValue(forKey: x)
            }
        }
        _orderComment.remove(at: _orderComment.index(forKey: orderItems.count-1)!)
        orderAddons.removeValue(forKey: orderItems.count - 1)
        _orderItemQuantity.remove(at: itemNoWithoutAddons)
        orderItems.remove(at: itemNoWithoutAddons)
        
    }

    
    var orderAddons: [Int: [Int]]{
        get{
            return _orderAddons
        }
        set{
            _orderAddons = newValue
            _orderItemAddons = newValue
            var price: Float = 0
            for items in newValue{
                for addons in items.value{
                    price += Float(getItemPrice(Int16(addons)))
                }
            }
            for items in 0..<_orderItems.count{
                price += Float(getItemQuantity(itemIndex: items))*Float(getItemPrice(Int16(_orderItems[items])))
            }
            _orderPrice = price
        }
    }
    func getPrice() -> Float{
        return _orderPrice
    }
    func getItPrice(itemNum: Int)->Float{
        let itemPrice = Float(getItemPrice(Int16(_orderItems[itemNum])))
        return itemPrice
    }
    func getItemInOrderPrice(itemNum: Int) -> Float{
        var itemPrice = Float(getItemPrice(Int16(_orderItems[itemNum])))
        if let addons = orderAddons[itemNum]{
            for addon in addons{
                itemPrice += Float(getItemPrice(Int16(addon)))
            }
        }
        return itemPrice
    }
    
    func addItemComment(itemNum: Int, comment: String){
        _orderComment[itemNum] = comment
    
    }
    
    func setOrderCustomerName(custName: String){
        _orderCustName = custName
    }
    func setOrderCustomerPhone(custPhone: String){
        _orderPhoneNum = custPhone
    }
    func getOrderComments() -> [Int: String]{
        return _orderComment
    }
    
    //figure out how date and time works
    var orderItems: [Int]{
        get{
            return self._orderItems
        }
        set{
            _orderItems = newValue
            var price: Float = 0
            for itemIndex in 0..<newValue.count{
                price += Float(getItemQuantity(itemIndex: itemIndex)) * Float(getItemPrice(Int16(newValue[itemIndex])))
            }
            for items in _orderAddons{
                for addons in items.value{
                    price += Float(getItemPrice(Int16(addons)))
                }
            }
            _orderPrice = price
        }
    }
    func getDate() -> Date{
        return _orderDateAndTime
    }
//    func getNumDiffItemsInNewOrder() -> Int{
//        return _orderItems.count
//    }
    func getNumItemsInNewOrder() -> Int{
        return _orderItems.count
    }
    
    func addItem(itemNum: Int){
        _orderItemQuantity.append(1)
        orderItems.append(itemNum)
        orderItemsAndAddons.append(itemNum)
        addItemComment(itemNum: orderItems.count - 1, comment: "")
    }
    func addAddonAtPosition(itemNum: Int, pos: Int){
        orderItemsAndAddons.insert(itemNum, at: pos)
    }
    func setItemQuantity(itemIndex: Int, quantity: Int){
        _orderItemQuantity[itemIndex] = quantity
        var price = Float(0.0)
        for itemIndex in 0..<_orderItems.count{
            price += Float(getItemQuantity(itemIndex: itemIndex)) * Float(getItemPrice(Int16(_orderItems[itemIndex])))
        }
        for items in _orderAddons{
            for addons in items.value{
                price += Float(getItemPrice(Int16(addons)))
            }
        }
        
        _orderPrice = price
        
        
    }
    func getItemQuantity(itemIndex: Int) -> Int{
        return _orderItemQuantity[itemIndex]
    }
    func checkout(){
        _orderNum = getAllOrderNumbers().count + 1
        _orderDateAndTime = Date.init(timeIntervalSinceNow: 0)
        //add to orders' database
        addOrderToDatabase(orderNum: _orderNum, orderItems: _orderItems, orderDateAndTime: _orderDateAndTime, orderPrice: _orderPrice, orderCustName: _orderCustName, orderPhoneNum: _orderPhoneNum, orderComment: _orderComment, orderItemAddons: _orderItemAddons, orderPickupTime: _orderPickupTime, orderAsCollection: _orderAsCollection, orderItemQuantity: _orderItemQuantity)
        orderItems = []
        _orderPrice = 0.0
        _orderCustName = ""
        _orderPhoneNum = ""
        _orderComment = [:]
        _orderAddons = [:]
        _orderItemAddons = [:]
        _orderAddons = [:]
        _orderPickupTime = 0
        _orderAsCollection = true
        _orderItemQuantity = []
        orderItemsAndAddons = []
    }
    func getItemNumbers()->[Int]{
        return _orderItems
    }
}

func getAllOrders () -> [(Int, [Int], Date, String, String, String, Int, Bool, [Int])]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
    var orders: Array<(Int, [Int], Date, String, String, String, Int, Bool, [Int])> = []
    do {
        //go get the results
        let array_orders = try getContext().fetch(fetchRequest)
        
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for order in array_orders as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
//            print("order: " + "\(String(describing: item.value(forKey: "itemEnglishName")!))")
            var thisOrder: (orderNum: Int, orderItems: [Int], orderDate: Date, orderPrice:  String, orderCustName: String, orderPhoneNum: String, orderPickupTime: Int, orderAsCollection: Bool, orderItemQuantity: [Int])
            thisOrder.orderNum = order.value(forKey: "orderNum")! as! Int
            thisOrder.orderItems = (order.value(forKey: "orderItems")! as! [Int])
            thisOrder.orderDate = order.value(forKey: "orderDateAndTime")! as! Date
            thisOrder.orderPrice = String(describing: order.value(forKey: "orderPrice")!)
            thisOrder.orderCustName = String(describing: order.value(forKey: "orderCustName")!)
            thisOrder.orderPhoneNum = String(describing: order.value(forKey: "orderPhoneNum")!)
            thisOrder.orderPickupTime = order.value(forKey: "orderPickupTime")! as! Int
            thisOrder.orderAsCollection = order.value(forKey: "orderAsCollection")! as! Bool
            thisOrder.orderItemQuantity = order.value(forKey: "orderItemQuantity")! as! [Int]
            orders.append(thisOrder)
        }
    } catch {
        print("Error with request: \(error)")
    }
    return orders
}

func addOrderToDatabase (orderNum: Int, orderItems: [Int], orderDateAndTime: Date, orderPrice: Float, orderCustName: String, orderPhoneNum: String, orderComment: [Int: String], orderItemAddons: [Int: [Int]], orderPickupTime: Int, orderAsCollection: Bool, orderItemQuantity: [Int]) {
    
    let context = getContext()
    
    
    let item = NSEntityDescription.insertNewObject(forEntityName: "Orders", into: context)
    
  
    
    item.setValue(orderNum, forKey: "orderNum")
    item.setValue(orderItems, forKey: "orderItems")
    item.setValue(orderDateAndTime, forKey: "orderDateAndTime")
    item.setValue(orderPrice, forKey: "orderPrice")
    item.setValue(orderCustName, forKey: "orderCustName")
    item.setValue(orderPhoneNum, forKey: "orderPhoneNum")
    item.setValue(orderComment, forKey: "orderComment")
    item.setValue(orderItemAddons, forKey: "orderItemAddons")
    item.setValue(orderPickupTime, forKey: "orderPickupTime")
    item.setValue(orderAsCollection, forKey: "orderAsCollection")
    item.setValue(orderItemQuantity, forKey: "orderItemQuantity")

    
    //save the context
    do {
        try context.save()
    
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    } catch {
        
    }
}

func getAllOrderDates () -> [String]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
    var items: Array<String> = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(String(describing: item.value(forKey: "orderDateAndTime")!))
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}
func getAllOrderPrices () -> [String]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
    var items: Array<String> = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(String(describing: item.value(forKey: "orderPrice")!))
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}
func getAllOrderNumbers () -> [Int]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
    var items: Array<Int> = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(item.value(forKey: "orderNum")! as! Int)
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}

func getAllAddOnOptions()->[Int]{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: Array<Int> = []
    do{
        let addon = "Addons"
        fetchRequest.predicate = NSPredicate(format: "itemCategory like '\(addon)'")
        let array_items = try getContext().fetch(fetchRequest)
        print("number of addons" + String(array_items.count))
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(item.value(forKey: "itemNum")! as! Int)
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}

func getOrderNumber(orderNum: Int) -> (Int, [Int], Date, Float, String, String, [Int: String], [Int: [Int]], Int, Bool, [Int]){
    let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
    var order: (orderNum: Int, orderItems:  [Int], orderDate: Date, orderPrice: Float, orderCustName: String, orderPhoneNum: String, orderComment: [Int: String], orderItemAddons: [Int: [Int]], orderPickupTime: Int, orderAsCollection: Bool, orderItemQuantity: [Int])
    order.orderNum = 0
    order.orderItems = []
    order.orderDate = Date.init(timeIntervalSinceNow: 0)
    order.orderPrice = 0.0
    order.orderCustName = ""
    order.orderPhoneNum = ""
    order.orderComment = [:]
    order.orderItemAddons = [:]
    order.orderPickupTime = 0
    order.orderAsCollection = true
    order.orderItemQuantity = []
    
    do {
        //go get the results
        fetchRequest.predicate = NSPredicate(format: "orderNum ==  '\(orderNum)'")
        let array_orders = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        //  var itemDetail: (itemNum: Int, itemCode: String, itemEnglishName: String, itemChineseName: String, itemPrice: Float, itemCategory: String)
        
        //You need to convert to NSManagedObject to use 'for' loops
        if array_orders.count == 1{
            for item in array_orders as [NSManagedObject] {
                
                
                order.orderNum = item.value(forKey: "orderNum")! as! Int
                order.orderItems = item.value(forKey: "orderItems")! as! [Int]
                order.orderDate = item.value(forKey: "orderDateAndTime")! as! Date
                order.orderPrice = item.value(forKey: "orderPrice")! as! Float
                order.orderCustName = item.value(forKey: "orderCustName")! as! String
                order.orderPhoneNum = item.value(forKey: "orderCustName")! as! String
                order.orderComment = item.value(forKey: "orderComment")! as! [Int: String]
                order.orderItemAddons = item.value(forKey: "orderItemAddons")! as! [Int: [Int]]
                order.orderPickupTime = item.value(forKey: "orderPickupTime")! as! Int
                order.orderAsCollection = item.value(forKey: "orderAsCollection")! as! Bool
                order.orderItemQuantity = item.value(forKey: "orderItemQuantity")! as! [Int]
                
            }
        }
        
        
    }
    catch{
        print("Error with request: \(error)")
    }
    return order
}

func cancelOrderOfNum(orderNum: Int){
    let fetchRequest: NSFetchRequest<Orders> = Orders.fetchRequest()
    let context = getContext()
    do{
        fetchRequest.predicate = NSPredicate(format: "orderNum == \(orderNum)")
        let array_items = try context.fetch(fetchRequest)
        if array_items.count == 1{
            for item in array_items as [NSManagedObject] {
                context.delete(item)
            }
        }
        let numOfOrders = getAllOrderNumbers().count + 2
        for x in orderNum + 1 ..< numOfOrders{
            fetchRequest.predicate = NSPredicate(format: "orderNum == \(x)")
            let array_items = try context.fetch(fetchRequest)
            if array_items.count == 1{
                for item in array_items as [NSManagedObject] {
                     item.setValue(x-1, forKey: "orderNum")
                }
            }
        }
        try context.save() }
    catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }

    
}



