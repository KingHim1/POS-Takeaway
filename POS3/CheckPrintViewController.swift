//
//  CheckPrintViewController.swift
//  POS3
//
//  Created by King Cheung on 26/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class CheckPrintViewController: UIViewController{
    
    var previousView: UIView? = nil
    var _price: Float = 0
    var previousController: ViewController? = nil
    
    func cancelButt(){
        previousController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func print(_ sender: Any) {
        if newOrder.sharedInstance.orderItems.count > 0 {
            previousController?.customerName.text = ""
            previousController?.customerPhone.text = ""
//            previousController?.timeTilCollect.text = "Time til Collection: 0 mins" 
            previousController?._price = 0
            previousController?.collectionSegControl.selectedSegmentIndex = 0
//            previousController?.stepperUI.value = 0
            
            let commands: Data
            newOrder.sharedInstance.setPickupTime(time: Float(previousController!.stepperUI.value))
            newOrder.sharedInstance.checkout()  
            
            let emulation: StarIoExtEmulation = AppDelegate.getEmulation()
            
            let _: Int = AppDelegate.getSelectedPaperSize().rawValue
            
            let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(AppDelegate.getSelectedLanguage(), paperSizeIndex: AppDelegate.getSelectedPaperSize(), orderNum: getAllOrders().count)
            
            commands = PrinterFunctions.createTextReceiptData(emulation, localizeReceipts: localizeReceipts, utf8: true)
            let portName:     String = AppDelegate.getPortName()
            let portSettings: String = AppDelegate.getPortSettings()
            
            _ = Communication.sendCommands(commands, portName: portName, portSettings: portSettings, timeout: 10000, completionHandler: { (result: Bool, title: String, message: String) in     // 10000mS!!!
                
                let alertView: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
                alertView.popoverPresentationController?.sourceView = self.view
                let cancelButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in self.cancelButt()})
                alertView.addAction(cancelButton)
                
                self.present(alertView, animated: true, completion: nil)
                
            })

            for subview in (previousView?.subviews)!{
                if let aview = subview as? UITableView{
                    aview.reloadData()
                }
                
            }
//            self.dismiss(animated: false, completion: nil)
        }
    }


}
