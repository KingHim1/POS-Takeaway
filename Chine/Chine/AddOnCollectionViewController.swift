//
//  AddOnCollectionViewController.swift
//  POS3
//
//  Created by King Cheung on 24/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit

class AddOnCllectionViewController: UICollectionViewController{
    
    @IBOutlet var addonCollectionView: UICollectionView!
    
    @IBOutlet weak var addonItem: UICollectionViewCell!
   
    @IBOutlet weak var collectionFlow: UICollectionViewFlowLayout!
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return getAllAddOnOptions().count
    }
    
    //2
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        print(newOrder.sharedInstance.getOrderComments().count)
        return 3
        
    }
    
    //3
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addOnCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
}
