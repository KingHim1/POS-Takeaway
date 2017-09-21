//
//  clearDatabase.swift
//  POS3
//
//  Created by King Cheung on 26/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class clearDatabase: UIViewController{

    @IBOutlet weak var clearDataButton: UIButton!
    @IBAction func clearData(_ sender: Any) {
        clearMenuData(database: "Orders")
            self.dismiss(animated: false, completion: nil)
    }
    
}
