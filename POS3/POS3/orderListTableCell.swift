//
//  orderListTableCell.swift
//  POS3
//
//  Created by King Cheung on 19/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class OrderListTableCell: UITableViewCell{

    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    
    @IBOutlet weak var orderCustomerName: UILabel!

    @IBOutlet weak var orderCustomerPhone: UILabel!
}
