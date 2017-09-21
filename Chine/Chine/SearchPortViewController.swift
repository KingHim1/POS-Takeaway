//
//  SearchPortViewController.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import UIKit

class SearchPortViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    
    enum AlertViewIndex: Int {
        case refreshPort = 0
        case portName
        case portSettings
        case modelConfirm
        case modelSelect0
        case modelSelect1
        case cashDrawerOpenActive
    }
    
    @IBOutlet weak var tableView: UITableView!
   
    var cellArray: NSMutableArray!
    
    var selectedIndexPath: IndexPath!
    
    var didAppear: Bool!
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    
    var emulation: StarIoExtEmulation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.appendRefreshButton(#selector(SearchPortViewController.refreshPortInfo))
        
        self.cellArray = NSMutableArray()
        
        self.selectedIndexPath = nil
        
        self.didAppear = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if didAppear == false {
            self.refreshPortInfo()
            
            self.didAppear = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "UITableViewCellStyleSubtitle"
        
        var cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if cell != nil {
            let cellParam: [String] = self.cellArray[indexPath.row] as! [String]
            
//          cell      .textLabel!.text = cellParam[CellParamIndex.portName.rawValue]
            cell      .textLabel!.text = cellParam[CellParamIndex.modelName.rawValue]
//          cell.detailTextLabel!.text = cellParam[CellParamIndex.modelName.rawValue]
            
            if cellParam[CellParamIndex.macAddress.rawValue] == "" {
                cell.detailTextLabel!.text = cellParam[CellParamIndex.portName.rawValue]
            }
            else {
                cell.detailTextLabel!.text = "\(cellParam[CellParamIndex.portName.rawValue]) (\(cellParam[CellParamIndex.macAddress.rawValue]))"
            }
            
            cell      .textLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            cell.detailTextLabel!.textColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
            
            cell.accessoryType = UITableViewCellAccessoryType.none
            
            if self.selectedIndexPath != nil {
                if (indexPath as NSIndexPath).compare(self.selectedIndexPath) == ComparisonResult.orderedSame {
                    cell.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      self.tableView.deselectRow(at: indexPath, animated: true)
        
        var cell: UITableViewCell!
        
        if self.selectedIndexPath != nil {
            cell = tableView.cellForRow(at: self.selectedIndexPath)
            
            if cell != nil {
                cell.accessoryType = UITableViewCellAccessoryType.none
            }
        }
        
        cell = tableView.cellForRow(at: indexPath)!
        
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        
        self.selectedIndexPath = indexPath
        
        let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
        
//      let portName:   String = cellParam[CellParamIndex.portName  .rawValue]
        let modelName:  String = cellParam[CellParamIndex.modelName .rawValue]
//      let macAddress: String = cellParam[CellParamIndex.macAddress.rawValue]
        
        if false {     // Ex1. Direct Setting.
//          let portSettings: String = ""
//          let portSettings: String = "mini"
//          let portSettings: String = "escpos"
//          let portSettings: String = "Portable"
//
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.starPRNT
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.starLine
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.starGraphic
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.escPos
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.escPosMobile
//          let emulation: StarIoExtEmulation = StarIoExtEmulation.starDotImpact
//
//          AppDelegate.setPortName    (portName)
//          AppDelegate.setModelName   (modelName)
//          AppDelegate.setMacAddress  (macAddress)
//          AppDelegate.setPortSettings(portSettings)
//          AppDelegate.setEmulation   (emulation)
//
//          self.navigationController!.popViewController(animated: true)
        }
        else if false {     // Ex2. Direct Setting.
//          let modelIndex: ModelIndex = ModelIndex.mpop
//          let modelIndex: ModelIndex = ModelIndex.fvp10
//          let modelIndex: ModelIndex = ModelIndex.tsp100
//          let modelIndex: ModelIndex = ModelIndex.tsp650II
//          let modelIndex: ModelIndex = ModelIndex.tsp700II
//          let modelIndex: ModelIndex = ModelIndex.tsp800II
//          let modelIndex: ModelIndex = ModelIndex.sm_S210I
//          let modelIndex: ModelIndex = ModelIndex.sm_S220I
//          let modelIndex: ModelIndex = ModelIndex.sm_S230I
//          let modelIndex: ModelIndex = ModelIndex.sm_T300I
//          let modelIndex: ModelIndex = ModelIndex.sm_T400I
//          let modelIndex: ModelIndex = ModelIndex.bsc10
//          let modelIndex: ModelIndex = ModelIndex.sm_S210I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.sm_S220I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.sm_S230I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.sm_T300I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.sm_T400I_StarPRNT
//          let modelIndex: ModelIndex = ModelIndex.sm_L200
//          let modelIndex: ModelIndex = ModelIndex.sp700
//          let modelIndex: ModelIndex = ModelIndex.sm_L300
//
//          let portSettings: String             = ModelCapability.portSettingsAtModelIndex(modelIndex)
//          let emulation:    StarIoExtEmulation = ModelCapability.emulationAtModelIndex   (modelIndex)
//
//          AppDelegate.setPortName    (portName)
//          AppDelegate.setModelName   (modelName)
//          AppDelegate.setMacAddress  (macAddress)
//          AppDelegate.setPortSettings(portSettings)
//          AppDelegate.setEmulation   (emulation)
//
//          self.navigationController!.popViewController(animated: true)
        }
        else if false {     // Ex3. Indirect Setting.
//          let modelIndex: ModelIndex = ModelCapability.modelIndexAtModelName(modelName)
//
//          let portSettings: String             = ModelCapability.portSettingsAtModelIndex(modelIndex)
//          let emulation:    StarIoExtEmulation = ModelCapability.emulationAtModelIndex   (modelIndex)
//
//          AppDelegate.setPortName    (portName)
//          AppDelegate.setModelName   (modelName)
//          AppDelegate.setMacAddress  (macAddress)
//          AppDelegate.setPortSettings(portSettings)
//          AppDelegate.setEmulation   (emulation)
//
//          self.navigationController!.popViewController(animated: true)
        }
        else {     // Ex4. Indirect Setting.
            let modelIndex: ModelIndex = ModelCapability.modelIndexAtModelName(modelName)
            
            if modelIndex != ModelIndex.none {
                let message: String = String(format: "Is your printer %@?", ModelCapability.titleAtModelIndex(modelIndex))
                
                let alertView: UIAlertController = UIAlertController.init(title: "Confirm", message: message, preferredStyle: .alert)
                alertView.popoverPresentationController?.sourceView = self.view
                alertView.view.tag = AlertViewIndex.modelConfirm.rawValue
                
                
                self.present(alertView, animated: true, completion: nil)
            }
            else {
                let alertView: UIAlertController = UIAlertController.init(title: "Confirm", message: "What is your printer?", preferredStyle: .actionSheet)
                for i: Int in 0 ..< ModelCapability.modelIndexCount() {
                    let action = UIAlertAction(title: ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)), style: UIAlertActionStyle.default, handler: {action in self.modelSelect0(buttonIndex: i)})
//                    alertView.addButton(withTitle: ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)))
//                    alertView.view.addSubview(button)
                    alertView.addAction(action)
                }
                alertView.popoverPresentationController?.sourceView = self.view

                alertView.view.tag = AlertViewIndex.modelSelect0.rawValue
            
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func refreshPortInfo() {
        
        let alertView: UIAlertController = UIAlertController.init(title: "Select Interface", message: "", preferredStyle: .alert)
        let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let lanButton: UIAlertAction = UIAlertAction(title: "LAN", style: .default, handler: nil)
        let blueButton: UIAlertAction = UIAlertAction(title: "Bluetooth", style: .default, handler: {action in self.netType( alertView, didDismissWithButtonIndex: 2)})
        let blueLowButton: UIAlertAction = UIAlertAction(title: "Bluetooth Low Energy", style: .default, handler: nil)
        let USBButton: UIAlertAction = UIAlertAction(title: "USB", style: .default, handler: nil)
        let AllButton: UIAlertAction = UIAlertAction(title: "All", style: .default, handler: nil)
        let ManButton: UIAlertAction = UIAlertAction(title: "Manual", style: .default, handler: nil)
        alertView.addAction(cancelButton)
        alertView.addAction(lanButton)
        alertView.addAction(blueButton)
        alertView.addAction(blueLowButton)
        alertView.addAction(USBButton)
        alertView.addAction(AllButton)
        alertView.addAction(ManButton)
        alertView.view.tag = AlertViewIndex.refreshPort.rawValue
        
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    func cancelAlert(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func getPortName(_ alertView: UIAlertController, action: UIAlertAction){
//        alertView.addTextField(configurationHandler: (textField: UITextField!), textField.text = AppDelegate.getPortName())
        let avTextFields = alertView.textFields!
        self.portName = avTextFields.first!.text!
        if self.portName == "" {
            let nestAlertView: UIAlertController = UIAlertController.init(title: "Please enter the port name.", message: "Fill in the port name.", preferredStyle: .actionSheet)
            
            nestAlertView.view.tag            = AlertViewIndex.portName.rawValue
            
//            let textField = UITextField.init()
//            textField.text = AppDelegate.getPortName()
            nestAlertView.addTextField(configurationHandler: {(textField: UITextField!) in textField.text = AppDelegate.getPortName()})
            
            self.present(nestAlertView, animated: true, completion: nil)
        }
        else {
            let nestAlertView: UIAlertController = UIAlertController(title: "Plase enter the port settings.", message: "", preferredStyle: .alert)
            
            nestAlertView.view.tag            = AlertViewIndex.portSettings.rawValue
            nestAlertView.addTextField(configurationHandler: {(textField: UITextField!) in textField.text = AppDelegate.getPortSettings()})
            
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func getPortSettings(_ alertView: UIAlertController){
        let avTextFields = alertView.textFields!
        self.portSettings = avTextFields.first!.text!

        let nestAlertView: UIAlertController = UIAlertController.init(title: "Confirm", message: "What is your printer?", preferredStyle: .actionSheet)
        
        for i: Int in 0 ..< ModelCapability.modelIndexCount() {
            let action: UIAlertAction = UIAlertAction(title: ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)), style: .default, handler: nil)
            nestAlertView.addAction(action)
        }
        
        nestAlertView.view.tag = AlertViewIndex.modelSelect1.rawValue
        
        self.present(alertView, animated: true, completion: nil)
}
    func confirmModelYes(_ alertView: UIAlertController){
        let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
        
        self.portName   = cellParam[CellParamIndex.portName  .rawValue]
        self.modelName  = cellParam[CellParamIndex.modelName .rawValue]
        self.macAddress = cellParam[CellParamIndex.macAddress.rawValue]
        
        let modelIndex: ModelIndex = ModelCapability.modelIndexAtModelName(self.modelName)
        
        self.portSettings = ModelCapability.portSettingsAtModelIndex(modelIndex)
        self.emulation    = ModelCapability.emulationAtModelIndex   (modelIndex)
        
        if ModelCapability.cashDrawerOpenActiveAtModelIndex(modelIndex) == true {
            let nestAlertView: UIAlertController = UIAlertController.init(title: "Select CashDrawer Open Status", message: "", preferredStyle: .actionSheet)
            
            nestAlertView.view.tag = AlertViewIndex.cashDrawerOpenActive.rawValue
            
             self.present(alertView, animated: true, completion: nil)
        }
        else {
            AppDelegate.setPortName                (self.portName)
            AppDelegate.setPortSettings            (self.portSettings)
            AppDelegate.setModelName               (self.modelName)
            AppDelegate.setMacAddress              (self.macAddress)
            AppDelegate.setEmulation               (self.emulation)
            AppDelegate.setCashDrawerOpenActiveHigh(true)
            
            
            self.navigationController!.popViewController(animated: true)
        }

    }
    
    func confirmModelNo(){
        let nestAlertView: UIAlertController = UIAlertController.init(title: "Confirm", message: "What is your printer?", preferredStyle: .actionSheet)
        
        for i: Int in 0 ..< ModelCapability.modelIndexCount() {
            let action = UIAlertAction(title: ModelCapability.titleAtModelIndex(ModelCapability.modelIndexAtIndex(i)), style: .default , handler: nil)
            nestAlertView.addAction(action)
        }
        
        nestAlertView.view.tag = AlertViewIndex.modelSelect0.rawValue
        
        self.navigationController!.popViewController(animated: true)
    }
    
    func modelSelect0(buttonIndex: Int){
        let cellParam: [String] = self.cellArray[self.selectedIndexPath.row] as! [String]
        
        self.portName   = cellParam[CellParamIndex.portName  .rawValue]
        self.modelName  = cellParam[CellParamIndex.modelName .rawValue]
        self.macAddress = cellParam[CellParamIndex.macAddress.rawValue]
        
        let modelIndex: ModelIndex = ModelCapability.modelIndexAtIndex(buttonIndex)
        
        self.portSettings = ModelCapability.portSettingsAtModelIndex(modelIndex)
        self.emulation    = ModelCapability.emulationAtModelIndex   (modelIndex)
        
        if ModelCapability.cashDrawerOpenActiveAtModelIndex(modelIndex) == true {
            let nestAlertView: UIAlertController = UIAlertController.init(title: "Select CashDrawer Open Status.", message: "", preferredStyle: .actionSheet)
            let actionCashAHT = UIAlertAction(title: "High When Open", style: .default, handler: {action in self.cashDrawOpen(buttonIndex: 1)})
            let actionCashAHF = UIAlertAction(title: "Low When Open", style: .default, handler: {action in self.cashDrawOpen(buttonIndex: 2)})
            nestAlertView.addAction(actionCashAHT)
            nestAlertView.addAction(actionCashAHF)
            
            nestAlertView.popoverPresentationController?.sourceView = self.view
            nestAlertView.view.tag = AlertViewIndex.cashDrawerOpenActive.rawValue
            
            self.present(nestAlertView, animated: true, completion: nil)
        }
        else {
            AppDelegate.setPortName                (self.portName)
            AppDelegate.setPortSettings            (self.portSettings)
            AppDelegate.setModelName               (self.modelName)
            AppDelegate.setMacAddress              (self.macAddress)
            AppDelegate.setEmulation               (self.emulation)
            AppDelegate.setCashDrawerOpenActiveHigh(true)
            
            
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    func modelSelect1(buttonIndex: Int){
        
            let modelIndex: ModelIndex = ModelCapability.modelIndexAtIndex(buttonIndex - 1)
            
            self.modelName    = ModelCapability.titleAtModelIndex       (modelIndex)
            self.macAddress   = self.portSettings                                        // for display.
            //              self.portSettings = ModelCapability.portSettingsAtModelIndex(modelIndex)
            self.emulation    = ModelCapability.emulationAtModelIndex   (modelIndex)
            
            if ModelCapability.cashDrawerOpenActiveAtModelIndex(modelIndex) == true {
                let nestAlertView: UIAlertController = UIAlertController.init(title: "Select CashDrawer Open Status.", message: "", preferredStyle: .actionSheet)
                let actionCashAHT = UIAlertAction(title: "High When Open", style: .default, handler: {action in self.cashDrawOpen(buttonIndex: 1)})
                let actionCashAHF = UIAlertAction(title: "Low When Open", style: .default, handler: {action in self.cashDrawOpen(buttonIndex: 2)})
                nestAlertView.addAction(actionCashAHT)
                nestAlertView.addAction(actionCashAHF)
                
                nestAlertView.view.tag = AlertViewIndex.cashDrawerOpenActive.rawValue
                
                self.navigationController!.popViewController(animated: true)
            }
            else {
                AppDelegate.setPortName                (self.portName)
                AppDelegate.setPortSettings            (self.portSettings)
                AppDelegate.setModelName               (self.modelName)
                AppDelegate.setMacAddress              (self.macAddress)
                AppDelegate.setEmulation               (self.emulation)
                AppDelegate.setCashDrawerOpenActiveHigh(true)
                
                
                self.navigationController!.popViewController(animated: true)
            }
        
    }
    
    func cashDrawOpen(buttonIndex: Int){
            AppDelegate.setPortName    (self.portName)
            AppDelegate.setPortSettings(self.portSettings)
            AppDelegate.setModelName   (self.modelName)
            AppDelegate.setMacAddress  (self.macAddress)
            AppDelegate.setEmulation   (self.emulation)
            
            if buttonIndex == 1 {     // High when Open
                AppDelegate.setCashDrawerOpenActiveHigh(true)
            }
            else if buttonIndex == 2 {     // Low when Open
                AppDelegate.setCashDrawerOpenActiveHigh(false)
            }
            
        
            self.navigationController!.popViewController(animated: true)
        }
    // ----------------------------------------------------- bottom is not my stuff
    
    
    private func netType(_ alertView: UIAlertController, didDismissWithButtonIndex buttonIndex: Int) {
        if alertView.view.tag == AlertViewIndex.refreshPort.rawValue {
         
            if buttonIndex == 6 {     // Manual
                let nestAlertView: UIAlertController = UIAlertController.init(title: "Please enter the port name.", message: "", preferredStyle: .alert)
                
                
                nestAlertView.view.tag            = AlertViewIndex.portName.rawValue
//                nestAlertView.alertViewStyle = UIAlertViewStyle.plainTextInput
                nestAlertView.addTextField(configurationHandler: {(textField: UITextField!) in textField.text = AppDelegate.getPortSettings()})
                
                self.present(nestAlertView, animated: true, completion: nil)

            }
            else {
                self.blind = true
                
                defer {
                    self.blind = false
                }
                
                self.cellArray.removeAllObjects()
                
                self.selectedIndexPath = nil
                
                let searchPrinterResult: [PortInfo]?
                
                switch buttonIndex {
                case 1  :     // LAN
                    searchPrinterResult = SMPort.searchPrinter("TCP:") as? [PortInfo]
                case 2  :     // Bluetooth
                    searchPrinterResult = SMPort.searchPrinter("BT:")  as? [PortInfo]
                case 3  :     // Bluetooth Low Energy
                    searchPrinterResult = SMPort.searchPrinter("BLE:") as? [PortInfo]
                case 4  :     // USB
                    searchPrinterResult = SMPort.searchPrinter("USB:") as? [PortInfo]
//              case 5  :     // All
                default :
                    searchPrinterResult = SMPort.searchPrinter()       as? [PortInfo]
                }
                
                guard let portInfoArray: [PortInfo] = searchPrinterResult else {
                    self.tableView.reloadData()
                    return
                }
                
                let portName:   String = AppDelegate.getPortName()
                let modelName:  String = AppDelegate.getModelName()
                let macAddress: String = AppDelegate.getMacAddress()
                
                var row: Int = 0
                
                for portInfo: PortInfo in portInfoArray {
                    self.cellArray.add([portInfo.portName, portInfo.modelName, portInfo.macAddress])
                    
                    if portInfo.portName   == portName  &&
                       portInfo.modelName  == modelName &&
                       portInfo.macAddress == macAddress {
                        self.selectedIndexPath = IndexPath(row: row, section: 0)
                    }
                    
                    row += 1
                }
                
                self.tableView.reloadData()
            }
        }
        
        return
    }
}
