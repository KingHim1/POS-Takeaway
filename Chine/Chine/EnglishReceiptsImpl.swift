//
//  EnglishReceiptsImpl.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class EnglishReceiptsImpl: ILocalizeReceipts {
    var orderNum: Int = 0
    
    override init() {
        super.init()
        
        languageCode = "En"
        
        characterCode = StarIoExtCharacterCode.standard
    }
    init(orderNum: Int){
        super.init()
        self.orderNum = orderNum
        languageCode = "En"
        characterCode = StarIoExtCharacterCode.standard
    }
    override func append2inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        let order = getOrderNumber(orderNum: orderNum)
        let itemNumbers = order.1
        let itemComments = order.6
//        let itemAddonNumbers = order.7
        
        
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append((
            "Fortune Corner\n" +

            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "Date:MM/DD/YYYY    Time:HH:MM PM\n" +
            "--------------------------------\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withEmphasis: "SALE\n".data(using: encoding))
        var x: Int = 0
        for item in itemNumbers{
            
            builder.append(("\(getItemName(Int16(item)))          \(getItemPrice(Int16(item))) \n").data(using:encoding))
            builder.append(("\(String(describing: itemComments[x]))))           \n").data(using:encoding))
            x = x + 1
        
        }
        
        
        builder.appendData(withMultiple: "Description Total\n".data(using: encoding), width: 2, height :2)
        builder.append((
            "SKU         Description    Total\n" +
                "300678566   PLAIN T-SHIRT  10.99\n" +
                "300692003   BLACK DENIM    29.99\n" +
                "300651148   BLUE DENIM     29.99\n" +
                "300642980   STRIPED DRESS  49.99\n" +
                "300638471   BLACK BOOTS    35.99\n" +
                "\n" +
                "Subtotal                  156.95\n" +
                "Tax                         0.00\n" +
            "--------------------------------\n").data(using: encoding))
        
        builder.append("Total     ".data(using: encoding))
        
        builder.appendData(withMultiple: "   $156.95\n".data(using: encoding), width: 2, height: 2)
        
        builder.append((
            "--------------------------------\n" +
            "\n" +
            "Charge\n" +
            "159.95\n" +
            "Visa XXXX-XXXX-XXXX-0123\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withInvert: "Refunds and Exchanges\n".data(using: encoding))
        
        builder.append("Within ".data(using: encoding))
        
        builder.appendData(withUnderLine: "30 days".data(using: encoding))
        
        builder.append(" with receipt\n".data(using: encoding))
        
        builder.append((
            "And tags attached\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
//      builder.appendBarcodeData("{BStar.".data(using: encoding),              symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".data(using: String.Encoding.ascii), symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode2, height: 40, hri: true)
    }
    
    override func append3inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        let order = getOrderNumber(orderNum: orderNum)
        let date = order.2
        let timeTilCol = order.8
        print(order.2)
        let dateFormatterDay = DateFormatter()
        let dateFormatterTime = DateFormatter()
        dateFormatterDay.dateFormat = "dd-MM-yyyy"
//        dateFormatterDay.timeZone = TimeZone(secondsFromGMT: 3600)
        dateFormatterTime.dateFormat = "hh:mma"
//        dateFormatterTime.timeZone = TimeZone(secondsFromGMT: 3600)
        let dateFormatterCollect = DateFormatter()
        dateFormatterCollect.timeZone = TimeZone(secondsFromGMT: 0 + timeTilCol * 60)
        dateFormatterCollect.dateFormat = "hh:mma"
        let itemNumbers = order.1
        let itemQuantity = order.10
        let itemComments = order.6
        let itemAddonNumbers = order.7
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.appendData(withMultiple:(
            "Fortune Corner\n" +
            "\n").data(using: encoding), width: 2, height: 2)
        if order.9{
            builder.appendData(withMultiple:(("Collection\n").data(using: encoding)), width: 2, height: 2)
        }
        else{
            builder.appendData(withMultiple:(("Walk-In\n").data(using: encoding)), width: 2, height: 2)
        }
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "Date:\(dateFormatterDay.string(from: date))                    Time:\(dateFormatterTime.string(from: date))\n" +
            "------------------------------------------------\n" +
            "\n").data(using: encoding))
        
       
        
        var x: Int = 0
        
        for item in 0..<itemNumbers.count{
            let itemArr = getItemOfNum(itemNum: itemNumbers[item])
            var itemChinName = itemArr.itemChinName
            var price = itemArr.itemPrice * Float(itemQuantity[item])
            if itemAddonNumbers[x] != nil{
                itemChinName.append(" (")
                for addon in itemAddonNumbers[x]!{
                    price += getItemPrice(Int16(addon))
                    itemChinName.append(getItemChinName(Int16(addon))+"|")
                }
                 itemChinName.append(")")
            }
           
            
            let priceStr = String(price)
            let priceLength = priceStr.characters.count
//            let engName = String(getItemName(Int16(item)))
//            let engNameLength = engName?.characters.count
//            let itemComm = String(describing: itemComments[x]!)
//            let itemCommLength = itemComm.characters.count
            var pricePadding = "--------------------"
            if priceLength == 3 {
                pricePadding = "---------------------"
            }
            if itemQuantity[item] > 1{
                builder.appendData(withMultiple: ("\(itemQuantity[item])" + "x ").data(using:encoding), width: 3, height: 3)
            }
            
            
            builder.appendData(withMultiple: ("\(itemArr.itemEngName) \n").data(using:encoding), width: 2, height: 2)
            if itemComments[x]!.characters.count > 1{
                builder.appendData(withMultiple: ("\(String(describing: itemComments[x]!))\n").data(using:encoding), width: 2, height: 2)
            }
            if itemArr.itemChinName != "N/A"{
                builder.appendData(withMultiple: ("\(itemChinName)\n").data(using:encoding), width: 2, height: 2)

            }
            builder.appendData(withMultiple: (pricePadding + "\(priceStr)\n\n").data(using:encoding), width: 2, height: 2)
            x = x + 1
            
        }
        let pricePadding = "------------------------"
        if order.3 >= 25{
            builder.appendData(withMultiple: (("Prawn Crackers\n").data(using: encoding)), width: 2, height: 2)
            builder.appendData(withMultiple: (pricePadding.data(using: encoding)), width: 2, height: 2)
        }
        
        builder.appendData(withMultiple: "Total ".data(using: encoding), width: 2, height: 2)
        let orderTotalLength = String(order.3).characters.count
        var totalPadding = ""
        for _ in 0..<(17-orderTotalLength){
            totalPadding += " "
        }
        builder.appendData(withMultiple: "\(totalPadding)£\(order.3)\n\n".data(using: encoding), width: 2, height: 2)
        
        builder.appendData(withMultiple: ("Collection Time: \(dateFormatterCollect.string(from: date))\n").data(using: encoding), width: 2, height: 2)
        builder.appendData(withMultiple: ("Cust. Name: \(order.4)").data(using: encoding), width: 2, height: 2)
        
        

    }
    
    override func append4inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append((
            "Star Clothing Boutique\n" +
            "123 Star Road\n" +
            "City, State 12345\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "Date:MM/DD/YYYY                                         Time:HH:MM PM\n" +
            "---------------------------------------------------------------------\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withEmphasis: "SALE \n".data(using: encoding))
        
        builder.append((
            "SKU                        Description                          Total\n" +
            "300678566                  PLAIN T-SHIRT                        10.99\n" +
            "300692003                  BLACK DENIM                          29.99\n" +
            "300651148                  BLUE DENIM                           29.99\n" +
            "300642980                  STRIPED DRESS                        49.99\n" +
            "300638471                  BLACK BOOTS                          35.99\n" +
            "\n" +
            "Subtotal                                                       156.95\n" +
            "Tax                                                              0.00\n" +
            "---------------------------------------------------------------------\n").data(using: encoding))
        
        builder.append("Total                                            ".data(using: encoding))
        
        builder.appendData(withMultiple: "   $156.95\n".data(using: encoding), width: 2, height: 2)
        
        builder.append((
            "---------------------------------------------------------------------\n" +
            "\n" +
            "Charge\n" +
            "159.95\n" +
            "Visa XXXX-XXXX-XXXX-0123\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withInvert: "Refunds and Exchanges\n".data(using: encoding))
        
        builder.append("Within ".data(using: encoding))
        
        builder.appendData(withUnderLine: "30 days".data(using: encoding))
        
        builder.append(" with receipt\n".data(using: encoding))
        
        builder.append((
            "And tags attached\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
//      builder.appendBarcodeData("{BStar.".data(using: encoding),              symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".data(using: String.Encoding.ascii), symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode2, height: 40, hri: true)
    }
    
    override func create2inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "   Star Clothing Boutique\n" +
        "        123 Star Road\n" +
        "      City, State 12345\n" +
        "\n" +
        "Date:MM/DD/YYYY Time:HH:MM PM\n" +
        "-----------------------------\n" +
        "SALE\n" +
        "SKU       Description   Total\n" +
        "300678566 PLAIN T-SHIRT 10.99\n" +
        "300692003 BLACK DENIM   29.99\n" +
        "300651148 BLUE DENIM    29.99\n" +
        "300642980 STRIPED DRESS 49.99\n" +
        "30063847  BLACK BOOTS   35.99\n" +
        "\n" +
        "Subtotal               156.95\n" +
        "Tax                      0.00\n" +
        "-----------------------------\n" +
        "Total                 $156.95\n" +
        "-----------------------------\n" +
        "\n" +
        "Charge\n" +
        "159.95\n" +
        "Visa XXXX-XXXX-XXXX-0123\n" +
        "Refunds and Exchanges\n" +
        "Within 30 days with receipt\n" +
        "And tags attached\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 10 * 2)!
//      let font: UIFont = UIFont(name: "Menlo", size: 11 * 2)!
//      let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 384)     // 2inch(384dots)
    }
    
    override func create3inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "        Star Clothing Boutique\n" +
        "             123 Star Road\n" +
        "           City, State 12345\n" +
        "\n" +
        "Date:MM/DD/YYYY          Time:HH:MM PM\n" +
        "--------------------------------------\n" +
        "SALE\n" +
        "SKU            Description       Total\n" +
        "300678566      PLAIN T-SHIRT     10.99\n" +
        "300692003      BLACK DENIM       29.99\n" +
        "300651148      BLUE DENIM        29.99\n" +
        "300642980      STRIPED DRESS     49.99\n" +
        "30063847       BLACK BOOTS       35.99\n" +
        "\n" +
        "Subtotal                        156.95\n" +
        "Tax                               0.00\n" +
        "--------------------------------------\n" +
        "Total                          $156.95\n" +
        "--------------------------------------\n" +
        "\n" +
        "Charge\n" +
        "159.95\n" +
        "Visa XXXX-XXXX-XXXX-0123\n" +
        "Refunds and Exchanges\n" +
        "Within 30 days with receipt\n" +
        "And tags attached\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 576)     // 3inch(576dots)
    }
    
    override func create4inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "                   Star Clothing Boutique\n" +
        "                        123 Star Road\n" +
        "                      City, State 12345\n" +
        "\n" +
        "Date:MM/DD/YYYY                             Time:HH:MM PM\n" +
        "---------------------------------------------------------\n" +
        "SALE\n" +
        "SKU                     Description                 Total\n" +
        "300678566               PLAIN T-SHIRT               10.99\n" +
        "300692003               BLACK DENIM                 29.99\n" +
        "300651148               BLUE DENIM                  29.99\n" +
        "300642980               STRIPED DRESS               49.99\n" +
        "300638471               BLACK BOOTS                 35.99\n" +
        "\n" +
        "Subtotal                                           156.95\n" +
        "Tax                                                  0.00\n" +
        "---------------------------------------------------------\n" +
        "Total                                             $156.95\n" +
        "---------------------------------------------------------\n" +
        "\n" +
        "Charge\n" +
        "159.95\n" +
        "Visa XXXX-XXXX-XXXX-0123\n" +
        "Refunds and Exchanges\n" +
        "Within 30 days with receipt\n" +
        "And tags attached\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 832)     // 4inch(832dots)
    }
    
    override func createCouponImage() -> UIImage {
        return UIImage(named: "EnglishCouponImage.png")!
    }
    
    override func createEscPos3inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "      Star Clothing Boutique\n" +
        "           123 Star Road\n" +
        "         City, State 12345\n" +
        "\n" +
        "Date:MM/DD/YYYY       Time:HH:MM PM\n" +
        "-----------------------------------\n" +
        "SALE\n" +
        "SKU          Description      Total\n" +
        "300678566    PLAIN T-SHIRT    10.99\n" +
        "300692003    BLACK DENIM      29.99\n" +
        "300651148    BLUE DENIM       29.99\n" +
        "300642980    STRIPED DRESS    49.99\n" +
        "30063847     BLACK BOOTS      35.99\n" +
        "\n" +
        "Subtotal                     156.95\n" +
        "Tax                            0.00\n" +
        "-----------------------------------\n" +
        "Total                       $156.95\n" +
        "-----------------------------------\n" +
        "\n" +
        "Charge\n" +
        "159.95\n" +
        "Visa XXXX-XXXX-XXXX-0123\n" +
        "Refunds and Exchanges\n" +
        "Within 30 days with receipt\n" +
        "And tags attached\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 512)     // EscPos3inch(512dots)
    }
    
    override func appendEscPos3inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append((
            "Star Clothing Boutique\n" +
            "123 Star Road\n" +
            "City, State 12345\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "Date:MM/DD/YYYY              Time:HH:MM PM\n" +
            "------------------------------------------\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withEmphasis: "SALE \n".data(using: encoding))
        
        builder.append((
            "SKU            Description           Total\n" +
            "300678566      PLAIN T-SHIRT         10.99\n" +
            "300692003      BLACK DENIM           29.99\n" +
            "300651148      BLUE DENIM            29.99\n" +
            "300642980      STRIPED DRESS         49.99\n" +
            "300638471      BLACK BOOTS           35.99\n" +
            "\n" +
            "Subtotal                            156.95\n" +
            "Tax                                   0.00\n" +
            "------------------------------------------\n").data(using: encoding))
        
        builder.append("Total                 ".data(using: encoding))
        
        builder.appendData(withMultiple: "   $156.95\n".data(using: encoding), width: 2, height: 2)
        
        builder.append((
            "------------------------------------------\n" +
            "\n" +
            "Charge\n" +
            "159.95\n" +
            "Visa XXXX-XXXX-XXXX-0123\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withInvert: "Refunds and Exchanges\n".data(using: encoding))
        
        builder.append("Within ".data(using: encoding))
        
        builder.appendData(withUnderLine: "30 days".data(using: encoding))
        
        builder.append(" with receipt\n".data(using: encoding))
        
        builder.append((
            "And tags attached\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
//      builder.appendBarcodeData("{BStar.".data(using: encoding),              symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height:,40, hri: true)
        builder.appendBarcodeData("{BStar.".data(using: String.Encoding.ascii), symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode2, height: 40, hri: true)
    }
    
    override func appendDotImpact3inchTextReceiptData(_ builder: ISCBBuilder, utf8: Bool) {
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append((
            "Star Clothing Boutique\n" +
            "123 Star Road\n" +
            "City, State 12345\n" +
            "\n").data(using: encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        
        builder.append((
            "Date:MM/DD/YYYY              Time:HH:MM PM\n" +
            "------------------------------------------\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withEmphasis: "SALE \n".data(using: encoding))
        
        builder.append((
            "SKU             Description          Total\n" +
            "300678566       PLAIN T-SHIRT        10.99\n" +
            "300692003       BLACK DENIM          29.99\n" +
            "300651148       BLUE DENIM           29.99\n" +
            "300642980       STRIPED DRESS        49.99\n" +
            "300638471       BLACK BOOTS          35.99\n" +
            "\n" +
            "Subtotal                            156.95\n" +
            "Tax                                   0.00\n" +
            "------------------------------------------\n" +
            "Total                              $156.95\n" +
            "------------------------------------------\n" +
            "\n" +
            "Charge\n" +
            "159.95\n" +
            "Visa XXXX-XXXX-XXXX-0123\n" +
            "\n").data(using: encoding))
        
        builder.appendData(withInvert: "Refunds and Exchanges\n".data(using: encoding))
        
        builder.append("Within".data(using: encoding))
        
        builder.appendData(withUnderLine: " 30 days".data(using: encoding))
        
        builder.append(" with receipt\n".data(using: encoding))
    }
    
    override func appendTextLabelData(_ builder: ISCBBuilder, utf8: Bool) {
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendUnitFeed(20 * 2)
        
        builder.appendMultipleHeight(2)
        
        builder.append("Star Micronics America, Inc.".data(using: encoding))
        
        builder.appendUnitFeed(64)
        
        builder.append("65 Clyde Road Suite G".data(using: encoding))
        
        builder.appendUnitFeed(64)
        
        builder.append("Somerset, NJ 08873-9997 U.S.A".data(using: encoding))
        
        builder.appendUnitFeed(64)
        
        builder.appendMultipleHeight(1)
    }
    
    override func createPasteTextLabelString() -> String {
        return "Star Micronics America, Inc.\n" +
               "65 Clyde Road Suite G\n" +
               "Somerset, NJ 08873-9997 U.S.A"
    }
    
    override func appendPasteTextLabelData(_ builder: ISCBBuilder, pasteText: String, utf8: Bool) {
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.append(pasteText.data(using: encoding))
    }
}
