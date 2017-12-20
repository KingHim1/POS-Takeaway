////
////  ScaleCommunication.swift
////  Swift SDK
////
////  Created by Yuji on 2016/**/**.
////  Copyright © 2016年 Star Micronics. All rights reserved.
////
//
//import Foundation
//
//class ScaleCommunication: Communication {
//    override class func parseDoNotCheckCondition(_ parser: ISCPParser, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
//        var result: Bool = false
//        
//        var title:   String = ""
//        var message: String = ""
//        
//        var error: NSError?
//        
//        let sendCommands:    Data = parser.createSendCommands()!    as Data
//        let receiveCommands: Data = parser.createReceiveCommands()! as Data
//        
//        var sendCommandsArray:    [UInt8] = [UInt8](repeating: 0, count: sendCommands   .count)
//        var receiveCommandsArray: [UInt8] = [UInt8](repeating: 0, count: receiveCommands.count)
//        
//        sendCommands   .copyBytes(to: &sendCommandsArray,    count: sendCommands.count)
//        receiveCommands.copyBytes(to: &receiveCommandsArray, count: receiveCommands.count)
//        
//        while true {
//            if port == nil {
//                title   = "Fail to Open Port"
//                message = ""
//                break
//            }
//            
//            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
//            
//            port.getParsedStatus(&printerStatus, 2, &error)
//            
//            if error != nil {
//                break
//            }
//            
////          if printerStatus.offline == sm_true {     // Do not check condition.
////              title   = "Printer Error"
////              message = "Printer is offline (GetParsedStatus)"
////              break
////          }
//            
//            let startDate: Date = Date()
//            
//            while result == false {
//                if Date().timeIntervalSince(startDate) >= 1.0 {     // 1000ms!!
//                    title   = "Printer Error"
//                    message = "Write port timed out"
//                    break
//                }
//                
//                var total: UInt32 = 0
//                
//                while total < UInt32(sendCommands.count) {
//                    let written: UInt32 = port.write(sendCommandsArray, total, UInt32(sendCommands.count) - total, &error)
//                    
//                    if error != nil {
//                        break
//                    }
//                    
//                    total += written
//                    
//                    if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
//                        title   = "Printer Error"
//                        message = "Write port timed out"
//                        break
//                    }
//                }
//                
//                if total < UInt32(sendCommands.count) {
//                    break
//                }
//                
//                let innerStartDate: Date = Date()
//                
//                while result == false {
////                  if Date().timeIntervalSince(innerStartDate) >= 1.0  {     // 1000mS!!!
//                    if Date().timeIntervalSince(innerStartDate) >= 0.25 {     //  250mS!!!
////                      title   = "Printer Error"
////                      message = "Read port timed out"
//                        break
//                    }
//                    
//                    total = 0
//                    
//                    while total < UInt32(receiveCommands.count) {
//                        let written: UInt32 = port.write(receiveCommandsArray, total, UInt32(receiveCommands.count) - total, &error)
//                        
//                        if error != nil {
//                            break
//                        }
//                        
//                        total += written
//                        
//                        if Date().timeIntervalSince(innerStartDate) >= 30.0 {     // 30000mS!!!
//                            title   = "Printer Error"
//                            message = "Write port timed out"
//                            break
//                        }
//                    }
//                    
//                    if total < UInt32(receiveCommands.count) {
//                        break
//                    }
//                    
//                    var buffer: [UInt8] = [UInt8](repeating: 0, count: 1024 + 8)
//                    
//                    var amount: Int32 = 0
//                    
//                    var completionResult: StarIoExtParserCompletionResult = StarIoExtParserCompletionResult.invalid
//                    
//                    while completionResult == StarIoExtParserCompletionResult.invalid {
////                      if Date().timeIntervalSince(innerStartDate) >= 1.0  {     // 1000mS!!!
//                        if Date().timeIntervalSince(innerStartDate) >= 0.25 {     //  250mS!!!
////                          title   = "Printer Error"
////                          message = "Read port timed out"
//                            break
//                        }
//                        
//                        Thread.sleep(forTimeInterval: 0.01)     // Break time.
//                        
//                        let readLength: UInt32 = port.read(&buffer, UInt32(amount), 1024 - UInt32(amount), &error)
//                        
////                      NSLog("readPort:%d", readLength)
////
////                      for i: UInt32 in 0 ..< readLength {
////                          NSLog("%02x", buffer[Int(amount + i)])
////                      }
//                        
//                        amount += Int32(readLength)
//        
//                        completionResult = parser.completionHandler!(&buffer, &amount)
//        
//                        if completionResult == StarIoExtParserCompletionResult.success {
//                            title   = "Send Commands"
//                            message = "Success"
//                            
//                            result = true
//                        }
//                    }
//                }
//            }
//
//            break
//        }
//        
//        if error != nil {
//            title   = "Printer Error"
//            message = error!.description
//        }
//        
//        if completionHandler != nil {
//            completionHandler!(result, title, message)
//        }
//        
//        return result
//    }
//}

