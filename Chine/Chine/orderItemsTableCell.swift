//
//  orderItemsTableCell.swift
//  POS3
//
//  Created by King Cheung on 22/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//


import UIKit

class OrderItemsTableCell: UITableViewCell{
    var itemNum: Int = 0
    
    @IBOutlet weak var itemsPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemsQuantity: UILabel!
}
