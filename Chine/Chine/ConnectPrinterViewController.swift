//
//  ConnectPrinterViewController.swift
//  Chine
//
//  Created by King Cheung on 20/12/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

//To connect printer: need port, macaddress and modelName
import UIKit
class ConnectPrinterViewController: UIViewController{
    //When view loads: need to find printers able to connect
    override func viewDidLoad()  {
        //find printers
        //add to table and highlight if printer is already connected to
        var foundPrinters = SMPort.searchPrinter("BT:") as? [PortInfo]
    }

    
}

