//
//  Data.swift
//  POS3
//
//  Created by King Cheung on 18/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//
import UIKit
import CoreData

class MenuItem: NSManagedObject{
    @NSManaged var itemCode: String?
    @NSManaged var itemEnglishName: String?
    @NSManaged var itemChineseName: String?
    @NSManaged var itemPrice: NSNumber?
    @NSManaged var itemCategory: String?
    
    
}
/* ---------------- parsing data from csv files -------------- */
func readDataFromCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return nil
    }
    do {
        var contents = try String(contentsOfFile: filepath, encoding: .utf8)
        contents = cleanRows(file: contents)
        return contents
    } catch {
        print("File Read Error for file \(filepath)")
        return nil
    }
}

func cleanRows(file:String)->String{
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: ",", with: ";")
    //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
    return cleanFile
}

func csv(data: String) -> [[String]] {
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    for row in rows {
        let columns = row.components(separatedBy: ";")
        result.append(columns)
    }
    return result
}



func getContext () -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

/* ---------------------------------------------------------------------*/

func updateMenu (itemCode: String, itemEnglishName:String, itemChineseName:String, itemCategory: String, itemPrice: Float) {
    
    let context = getContext()
    
    
    let item = NSEntityDescription.insertNewObject(forEntityName: "Menu", into: context)
        
    item.setValue(itemEnglishName, forKey: "itemEnglishName")
    item.setValue(itemChineseName, forKey: "itemChineseName")
    item.setValue(itemCode, forKey: "itemCode")
    item.setValue(itemCategory, forKey: "itemCategory")
    item.setValue(itemPrice, forKey: "itemPrice")
    let itemNumber = getAllItemNums().max()! + 1
    print(itemNumber)
    item.setValue(itemNumber, forKey: "itemNum")
    print("\(String(describing: item.value(forKey: "itemEnglishName")))")
    print("UPDATE MENU")
        //save the context
    do {
        try context.save()
    } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    } catch {
            
    }
        
    
}
func numItems() -> Int {
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()

    let numOfItems: Int = 0
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        print("this is the number of items in database")
        print(array_items.count)
        
        //I like to check the size of the returned results!
        return array_items.count
        
        //You need to convert to NSManagedObject to use 'for' loops
        
    } catch {
        print("Error with request: \(error)")
    }
    
    return numOfItems
}


func getAllItemCodes () -> [String]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: Array<String> = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(String(describing: item.value(forKey: "itemCode")!))
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}
func getAllItemNums () -> [Int]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: Array<Int> = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(item.value(forKey: "itemNum")! as! Int)
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}
func filterAllItems(filtrate: String) -> [Int]{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: Array<Int> = []
    do {
        //go get the results
         fetchRequest.predicate = NSPredicate(format: "itemEnglishName CONTAINS[c]  %@", filtrate)
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(item.value(forKey: "itemNum")! as! Int)
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}
func getAllItemPrices () -> [String]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: Array<String> = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(String(describing: item.value(forKey: "itemPrice")!))
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}
func getAllItemNames () -> [String]{
    //create a fetch request, telling it about the entity
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: Array<String> = []
    print("getALLITEMNAMES")
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            items.append(String(describing: item.value(forKey: "itemEnglishName")!))
        }
    } catch {
        print("Error with request: \(error)")
    }
    return items
}

func getItemPrice (_ itemNum: Int16) -> Float{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var price: Float = 0
    do {
        //go get the results
        fetchRequest.predicate = NSPredicate(format: "itemNum == \(itemNum)")
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        if array_items.count == 1{
            for item in array_items as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                price = item.value(forKey: "itemPrice") as! Float
                }
        }
    }
    catch{
        print("Error with request: \(error)")
    }
    return price
}

func getItemName(_ itemNum: Int16) -> String{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var name: String = ""
    do {
        //go get the results
        fetchRequest.predicate = NSPredicate(format: "itemNum == \(itemNum)")
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        if array_items.count == 1{
            for item in array_items as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                name = item.value(forKey: "itemEnglishName") as! String
            }
        }
    }
    catch{
        print("Error with request: \(error)")
    }
    return name
}
func getItemChinName(_ itemNum: Int16) -> String{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var name: String = ""
    do {
        //go get the results
        fetchRequest.predicate = NSPredicate(format: "itemNum == \(itemNum)")
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        if array_items.count == 1{
            for item in array_items as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                name = item.value(forKey: "itemChineseName") as! String
            }
        }
    }
    catch{
        print("Error with request: \(error)")
    }
    return name
}
func getCategories () -> [String]{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var categories: [String] = []
    var cat: [String] = []
    do {
        //go get the results
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        print ("num of item = \(array_items.count)")
        
        //You need to convert to NSManagedObject to use 'for' loops
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            categories.append(String(describing: item.value(forKey: "itemCategory")!))
        }
        // -------------    removes repeats of categories ----------------- //
        var revCat: [String] = []
        for i in categories{
            if !revCat.contains(i){
                revCat.append(i)
            }
        }
        for i in revCat{
            cat.append(i)
        }
        // ------------------------------------------------------------------//
    }
            catch{
        print("Error with request: \(error)")
    }
    return cat
}

func clearMenuData(database: String){
    // Initialize Fetch Request
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: database)
    
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try getContext().execute(batchDeleteRequest)
        
    } catch {
        print("Error with request: \(error)")
    }
}

func getItemOfCategory(category: String) -> [(Int, String, String, String, Float, String)]{
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var items: [(Int, String, String, String, Float, String)] = []
    do {
        //go get the results
        print("this is the category: " + category)
        fetchRequest.predicate = NSPredicate(format: "itemCategory like  '\(category)'")
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        var itemDetail: (itemNum: Int, itemCode: String, itemEnglishName: String, itemChineseName: String, itemPrice: Float, itemCategory: String)
        //You need to convert to NSManagedObject to use 'for' loops
        for item in array_items as [NSManagedObject] {
            //get the Key Value pairs (although there may be a better way to do that...
            itemDetail.itemNum = item.value(forKey: "itemNum")! as! Int
            itemDetail.itemCode = (String(describing: item.value(forKey: "itemCode")!))
            itemDetail.itemEnglishName = (String(describing: item.value(forKey: "itemEnglishName")!))
            itemDetail.itemChineseName = (String(describing: item.value(forKey: "itemChineseName")!))
            itemDetail.itemPrice = item.value(forKey: "itemPrice") as! Float
            itemDetail.itemCategory = (String(describing: item.value(forKey: "itemCategory")!))
            items.append(itemDetail)
        }
        
        
        
    }
    catch{
        print("Error with request: \(error)")
    }
    return items
}
func getItemOfNum(itemNum: Int)-> (itemNum: Int, itemCategory: String, itemCode: String, itemEngName: String, itemChinName: String, itemPrice: Float){
    
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    var menuItem: (itemNum: Int, itemCategory: String, itemCode: String, itemEngName: String, itemChinName: String, itemPrice: Float)
    menuItem.itemNum = 0
    menuItem.itemCategory = "Other"
    menuItem.itemCode = ""
    menuItem.itemEngName = "database messed up"
    menuItem.itemChinName = "database messed up"
    menuItem.itemPrice = 0
    print("FETCHING ITEM OF ITEM NUM:")
    print(itemNum)
        
    do {
        //go get the results
        fetchRequest.predicate = NSPredicate(format: "itemNum == \(itemNum)")
        let array_items = try getContext().fetch(fetchRequest)
        
        //I like to check the size of the returned results!
        
        //You need to convert to NSManagedObject to use 'for' loops
        if array_items.count == 1{
            for item in array_items as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                menuItem.itemNum = item.value(forKey: "itemNum") as! Int
                menuItem.itemCategory = item.value(forKey: "itemCategory") as! String
                menuItem.itemCode = item.value(forKey: "itemCode") as! String
                menuItem.itemEngName = item.value(forKey: "itemEnglishName") as! String
                menuItem.itemChinName = item.value(forKey: "itemChineseName") as! String
                menuItem.itemPrice = item.value(forKey: "itemPrice") as! Float
                
                
            }
        }
        else
        {
            print("multiple items with same item num")
        }
    }
    catch{
        print("Error with request: \(error)")
    }
    return menuItem

}

func editItemFromDatabase(itemNum: Int, itemCategory: String, itemCode: String, itemEngName: String, itemChinName: String, itemPrice: Float){
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    let context = getContext()
    do{
        fetchRequest.predicate = NSPredicate(format: "itemNum == \(itemNum)")
        let array_items = try context.fetch(fetchRequest)
        if array_items.count == 1{
            for item in array_items as [NSManagedObject] {
                item.setValue(itemCategory, forKey: "itemCategory")
                item.setValue(itemCode, forKey: "itemCode")
                item.setValue(itemEngName, forKey: "itemEnglishName")
                item.setValue(itemChinName, forKey: "itemChineseName")
                item.setValue(itemPrice, forKey: "itemPrice")
            
            }
        }
        try context.save() }
    catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }

}
func deleteItemFromDatabase(itemNum: Int){
    let fetchRequest: NSFetchRequest<Menu> = Menu.fetchRequest()
    let context = getContext()
    do{
        fetchRequest.predicate = NSPredicate(format: "itemNum == \(itemNum)")
        let array_items = try context.fetch(fetchRequest)
        for item in array_items as [NSManagedObject] {
            context.delete(item)
        }
        
        try context.save() }
    catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
    }
}




