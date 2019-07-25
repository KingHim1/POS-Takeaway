//
//  ViewController.swift
//  POS3
//
//  Created by King Cheung on 17/08/2017.
//  Copyright © 2017 King Cheung. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var SearchButton: UIButton!

    @IBOutlet weak var collectionSegControl: UISegmentedControl!
    @IBAction func setAsCollection(_ sender: Any) {
        if collectionSegControl.selectedSegmentIndex == 0{
         // set as collection
            newOrder.sharedInstance.setCollectionOrTakeAway(colOrTake: true)
        }
        else{
        // set as walkin
            newOrder.sharedInstance.setCollectionOrTakeAway(colOrTake: false)
            print("working")
        }
    }
    var timeTC = "Time til Collection: "
    @IBOutlet weak var timeTilCollect: UILabel!
    
    @IBOutlet weak var stepperUI: UIStepper!
    
    @IBAction func stepper(_ sender: Any) {
        newOrder.sharedInstance.setPickupTime(time: Float(stepperUI.value))
        timeTilCollect.text = timeTC + String(Int(stepperUI.value)) + (" mins")
    }
    var price: Float = 0
    var _price: Float{
        get{
            return price
        }
        set{
            price = newValue
            priceLabel.text = "£" + String((newValue * 100).rounded()/100)
            checkOutButtonCheck()
        }
    }

    @IBAction func checkoutAction(_ sender: Any) {
        if newOrder.sharedInstance.orderItems.count > 0 {
            if let name = customerName.text{
                newOrder.sharedInstance.setOrderCustomerName(custName: name)
            }
            if let phone = customerPhone.text{
                newOrder.sharedInstance.setOrderCustomerPhone(custPhone: phone)
            }
        }
    }
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var orderStack: UIStackView!
    @IBOutlet weak var newOrderTable: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    
    func makeButtonWithText(text:String) -> UIButton {
        let myButton = UIButton(type: UIButtonType.system)
        //Set a frame for the button. Ignored in AutoLayout/ Stack Views
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.setTitle(text, for: .normal)
        myButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 35)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor = UIColor(red:0.87, green:0.14, blue:0.14, alpha:1.0)
        myButton.addTarget(self, action: #selector(enterCategory), for: .touchUpInside
        )
        return myButton
    }
    
    
    func makeBackButton() -> UIButton {
        let myButton = UIButton(type: UIButtonType.system)
        //Set a frame for the button. Ignored in AutoLayout/ Stack Views
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.setTitle("Back", for: .normal)
        myButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 48)
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor = UIColor(red:0.87, green:0.14, blue:0.14, alpha:1.0)
        myButton.addTarget(self, action: #selector(goBackToCategories), for: .touchUpInside
        )
        return myButton
    }
    
    func makeItemButton(item: (itemNum: Int, itemCode: String, itemEnglishName: String, itemChineseName: String, itemPrice: Float, itemCategory: String)) -> UIButton {
        let myButton = UIButton(type: UIButtonType.system)
        //Set a frame for the button. Ignored in AutoLayout/ Stack Views
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.setTitle(item.itemCode + ": " + item.itemEnglishName + "  :  £" + String(item.itemPrice), for: .normal)
        myButton.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 20)
        myButton.setTitleColor(UIColor.black, for: .normal)
        myButton.contentHorizontalAlignment =  .left
        myButton.backgroundColor = (UIColor.white)
        myButton.addTarget(self, action: #selector(addItemToOrder), for: .touchUpInside)
        myButton.tag = item.itemNum
        
        return myButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        removeCategories()
        resetCategories()
        checkoutButton.isUserInteractionEnabled = false
        stepperUI.stepValue = 10
        stepperUI.value = 0
        stepperUI.minimumValue = 0
    }
    private func setupView() {
        setupSegmentedControl()
    }
    
    
    private func setupSegmentedControl() {
        // Configure Segmented Control
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "New Order", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Today's Orders", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Configurations", at: 2, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private lazy var configController: ConfigurationViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "testTable") as! ConfigurationViewController  
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    
    private lazy var viewController: ViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "newOrder") as! ViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    
    private lazy var orderListTableViewController: OrderListTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "orderTable") as! OrderListTableViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()

    
//    private lazy var orderItemsTableViewController: OrderItemsTableViewController = {
//        // Load Storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        
//        // Instantiate View Controller
//        var viewController = storyboard.instantiateViewController(withIdentifier: "orderItems") as! OrderItemsTableViewController
//        
//        // Add View Controller as Child View Controller
//         self.add(asChildViewController: viewController)
//        
//        
//        return viewController
//    }()

    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    func updateView() {
        if segmentedControl.selectedSegmentIndex == 0 {
            if self.presentingViewController == orderListTableViewController{
                remove(asChildViewController: orderListTableViewController)
            }
            else{
                remove(asChildViewController: configController)
            }
            viewController._price = newOrder.sharedInstance.getPrice()
            add(asChildViewController: viewController)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if self.presentingViewController == viewController {
                remove(asChildViewController: viewController)
            }
            else{
                remove(asChildViewController: configController)
            }
            for subview in self.view.subviews{
                if let aview = subview as? UITableView{
                    aview.reloadData()
                }
            }
//            orderListTableViewController.setTotalPriceLabel()
            add(asChildViewController: orderListTableViewController)
            
            }
        else{
            if self.presentingViewController == viewController{
                remove(asChildViewController: viewController)

            }
            else {
                remove(asChildViewController: orderListTableViewController)
            }
            add(asChildViewController: configController)
        }
    }
    
    private func removeCategories(){
        categoryStack.subviews.forEach({
            if let button = $0 as? UIButton{
                if button.currentTitle != "Search"{
                    $0.removeFromSuperview()
                }
            }
            
        })
    }
    private func resetCategories(){
        for categories in getCategories(){
            categoryStack.addArrangedSubview(makeButtonWithText(text: categories))
        }
    
    }
    @IBAction func enterCategory(sender: UIButton){
        removeCategories()
        categoryStack.addArrangedSubview(makeBackButton())
        for items in getItemOfCategory(category: (sender.titleLabel?.text)!){
            categoryStack.addArrangedSubview(makeItemButton(item: items))
        }
    }
    @IBAction func goBackToCategories(sender: UIButton){
        removeCategories()
        resetCategories()
    }
    @IBAction func addItemToOrder(sender: UIButton){
        newOrder.sharedInstance.addItem(itemNum: sender.tag)
        print("items in new order= \(newOrder.sharedInstance.getNumItemsInNewOrder())")
        self.view.setNeedsDisplay()
    

        for subview in newOrderTable.subviews{
            if let aview = subview as? UITableView{
                aview.reloadData()
                let numberOfRows = aview.numberOfRows(inSection: 0)
                let indexPath = IndexPath(row: numberOfRows-1, section: 0)
                aview.scrollToRow(at: indexPath, at: .bottom, animated: true)
                aview.indexPath
            }
        }
        
        
        _price = newOrder.sharedInstance.getPrice()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CheckPrintViewController{
            destination.previousView = newOrderTable
            destination.previousController = self
        }
    }
    func checkOutButtonCheck(){
        if newOrder.sharedInstance.orderItems.count > 0 {
            checkoutButton.isUserInteractionEnabled = true
        }
        else{
            checkoutButton.isUserInteractionEnabled = false
        }
    }

    @IBOutlet weak var SearchContainerStack: UIStackView!
    
    @IBAction func SearchBackButtonPress(_ sender: Any) {
        categoryStack.isHidden = false
        SearchContainerStack.isHidden = true
    }
    @IBAction func SearchButtonPress(_ sender: Any) {
        categoryStack.isHidden = true
        SearchContainerStack.isHidden = false
    }
    
    var filter = ""
    var listOfFilteredItemNum: [Int] = []
    
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBAction func searchChanged(_ sender: Any) {
        if let _filter = searchBar.text{
            print("happy")
            print(_filter)
            filter = searchBar.text!
            listOfFilteredItemNum = filterAllItems(filtrate: filter)
            listOfFilteredItemNum = listOfFilteredItemNum.sorted()
            print(listOfFilteredItemNum)
            for viewControllers in self.childViewControllers{
                if let tableVC = viewControllers as? EditItemTableViewController{
                    tableVC.listOfFilteredItemNum = listOfFilteredItemNum
                    if let view = tableVC.view as? UITableView{
                        view.reloadData()
                    }
                }
            }
        }
        else{
            _filter = ""
        }
    }

    
    
    var _filter: String{
        get{
            return filter
        }
        set{
            filter = newValue
            listOfFilteredItemNum = filterAllItems(filtrate: filter)
            listOfFilteredItemNum = listOfFilteredItemNum.sorted()
            print(listOfFilteredItemNum)
            for viewControllers in self.childViewControllers{
                if let tableVC = viewControllers as? EditItemTableViewController{
                    tableVC.listOfFilteredItemNum = listOfFilteredItemNum
                    if let view = tableVC.view as? UITableView{
                        view.reloadData()
                    }
                }
            }
        }
    }

}



