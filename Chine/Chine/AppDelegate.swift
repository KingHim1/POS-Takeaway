//
//  AppDelegate.swift
//  POS5
//
//  Created by King Cheung on 18/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit
import CoreData

enum LanguageIndex: Int {
    case english = 0
    case japanese
    case french
    case portuguese
    case spanish
    case german
    case russian
    case simplifiedChinese
    case traditionalChinese
}

enum PaperSizeIndex: Int {
    case twoInch = 384
    case threeInch = 576
    case fourInch = 832
    case escPosThreeInch = 512
    case dotImpactThreeInch = 210
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static func isSystemVersionEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedSame
    }
    
    static func isSystemVersionGreaterThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
    static func isSystemVersionGreaterThanOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) != ComparisonResult.orderedAscending
    }
    
    static func isSystemVersionLessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    static func isSystemVersionLessThanOrEqualTo(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: NSString.CompareOptions.numeric) != ComparisonResult.orderedDescending
    }
    
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    
    var emulation:                StarIoExtEmulation!
    var cashDrawerOpenActiveHigh: Bool!
    var allReceiptsSettings:      Int!
    var selectedIndex:            Int!
    var selectedLanguage:         LanguageIndex!
    var selectedPaperSize:        PaperSizeIndex!
    
    
   
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let defaults = UserDefaults.standard
        let defaultValue = ["isMenuUploaded" : false]
        defaults.register(defaults: defaultValue)
        
        Thread.sleep(forTimeInterval: 1.0)     // 1000mS!!!
        
        self.loadParam()
        
        self.selectedIndex     = 0
        self.selectedLanguage  = LanguageIndex.english
        self.selectedPaperSize = PaperSizeIndex.threeInch
        
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let defaults = UserDefaults.standard
        let token = defaults.value(forKey: "isMenuUploaded")
//        clearMenuData(database: "Orders")
        if !(token! as! Bool) {
            var data = readDataFromCSV(fileName: "menu", fileType: "csv")
            data = cleanRows(file: data!)
            let csvRows = csv(data: data!)
            print(csvRows[0][0]) // UXM n. 166/167
            
            
            for rows in csvRows{
                if rows.count > 2{
                    updateMenu(itemCode: rows[1], itemEnglishName: rows[2], itemChineseName: "N/A", itemCategory: rows[4] ,itemPrice: Float(rows[3])!)
                }
            }
           
            
            defaults.set(true, forKey: "isMenuUploaded")
            defaults.synchronize()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Chine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    fileprivate func loadParam() {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        userDefaults.register(defaults: ["portName"                 : ""])
        userDefaults.register(defaults: ["portSettings"             : ""])
        userDefaults.register(defaults: ["modelName"                : ""])
        userDefaults.register(defaults: ["macAddress"               : ""])
        userDefaults.register(defaults: ["emulation"                : StarIoExtEmulation.starPRNT.rawValue])
        userDefaults.register(defaults: ["cashDrawerOpenActiveHigh" : true])
        userDefaults.register(defaults: ["allReceiptsSettings"      : 0x00000007])
        
        self.portName                 =                              userDefaults.string (forKey: "portName")
        self.portSettings             =                              userDefaults.string (forKey: "portSettings")
        self.modelName                =                              userDefaults.string (forKey: "modelName")
        self.macAddress               =                              userDefaults.string (forKey: "macAddress")
        self.emulation                = StarIoExtEmulation(rawValue: userDefaults.integer(forKey: "emulation"))
        self.cashDrawerOpenActiveHigh =                              userDefaults.bool   (forKey: "cashDrawerOpenActiveHigh")
        self.allReceiptsSettings      =                              userDefaults.integer(forKey: "allReceiptsSettings")
    }
    
    
    static func getPortName() -> String {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.portName!
    }
    
    static func setPortName(_ portName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.portName = portName
        
        userDefaults.set(delegate.portName, forKey: "portName")
        
        userDefaults.synchronize()
    }
    
    static func getPortSettings() -> String {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.portSettings!
    }
    
    static func setPortSettings(_ portSettings: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.portSettings = portSettings
        
        userDefaults.set(delegate.portSettings, forKey: "portSettings")
        
        userDefaults.synchronize()
    }
    
    static func getModelName() -> String {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.modelName!
    }
    
    static func setModelName(_ modelName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.modelName = modelName
        
        userDefaults.set(delegate.modelName, forKey:"modelName")
        
        userDefaults.synchronize()
    }
    
    static func getMacAddress() -> String {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.macAddress!
    }
    
    static func setMacAddress(_ macAddress: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.macAddress = macAddress
        
        userDefaults.set(delegate.macAddress, forKey:"macAddress")
        
        userDefaults.synchronize()
    }
    
    static func getEmulation() -> StarIoExtEmulation {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.emulation!
    }
    
    static func setEmulation(_ emulation: StarIoExtEmulation) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.emulation = emulation
        
        userDefaults.set(delegate.emulation.rawValue, forKey:"emulation")
        
        userDefaults.synchronize()
    }
    
    static func getCashDrawerOpenActiveHigh() -> Bool {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.cashDrawerOpenActiveHigh!
    }
    
    static func setCashDrawerOpenActiveHigh(_ activeHigh: Bool) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.cashDrawerOpenActiveHigh = activeHigh
        
        userDefaults.set(delegate.cashDrawerOpenActiveHigh, forKey:"cashDrawerOpenActiveHigh")
        
        userDefaults.synchronize()
    }
    
    static func getAllReceiptsSettings() -> Int {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.allReceiptsSettings!
    }
    
    static func setAllReceiptsSettings(_ allReceiptsSettings: Int) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.allReceiptsSettings = allReceiptsSettings
        
        userDefaults.set(delegate.allReceiptsSettings, forKey:"allReceiptsSettings")
        
        userDefaults.synchronize()
    }
    
    static func getSelectedIndex() -> Int {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.selectedIndex!
    }
    
    static func setSelectedIndex(_ index: Int) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.selectedIndex = index
    }
    
    static func getSelectedLanguage() -> LanguageIndex {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.selectedLanguage!
    }
    
    static func setSelectedLanguage(_ index: LanguageIndex) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.selectedLanguage = index
    }
    
    static func getSelectedPaperSize() -> PaperSizeIndex {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return delegate.selectedPaperSize!
    }
    
    static func setSelectedPaperSize(_ index: PaperSizeIndex) {
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        delegate.selectedPaperSize = index
    }
    
}

