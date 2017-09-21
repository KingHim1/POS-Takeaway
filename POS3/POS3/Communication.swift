//
//  Communication.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import Foundation

typealias SendCompletionHandler = (_ result: Bool, _ title: String, _ message: String) -> Void

typealias SendCompletionHandlerWithNullableString = (_ result: Bool, _ title: String?, _ message: String?) -> Void

typealias RequestStatusCompletionHandler = (_ result: Bool, _ title: String, _ message: String, _ connect: Bool) -> Void

class Communication {
    static func sendCommands(_ commands: Data!, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &commandsArray, count: commands.count)
        
        while true {
            if port == nil {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.beginCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (BeginCheckedBlock)"
                break
            }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < UInt32(commands.count) {
                let written: UInt32 = port.write(commandsArray, total, UInt32(commands.count) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(commands.count) {
                break
            }
            
            port.endCheckedBlockTimeoutMillis = 30000     // 30000mS!!!
            
            port.endCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (EndCheckedBlock)"
                break
            }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendCommandsDoNotCheckCondition(_ commands: Data!, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &commandsArray, count: commands.count)
        
        while true {
            if port == nil {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < UInt32(commands.count) {
                let written: UInt32 = port.write(commandsArray, total, UInt32(commands.count) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(commands.count) {
                break
            }
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
//  static func parseDoNotCheckCondition(_ parser: ISCPParser, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
    class  func parseDoNotCheckCondition(_ parser: ISCPParser, port: SMPort!, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        let commands: Data = parser.createSendCommands()! as Data
        
        var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &commandsArray, count: commands.count)
        
        while true {
            if port == nil {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            var startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < UInt32(commands.count) {
                let written: UInt32 = port.write(commandsArray, total, UInt32(commands.count) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(commands.count) {
                break
            }
            
            startDate = Date()
            
            var buffer: [UInt8] = [UInt8](repeating: 0, count: 1024 + 8)
            
            var amount: Int32 = 0
            
            while true {
                if Date().timeIntervalSince(startDate) >= 1.0 {     // 1000mS!!!
                    title   = "Printer Error"
                    message = "Read port timed out"
                    break
                }
                
                Thread.sleep(forTimeInterval: 0.01)     // Break time.
                
                let readLength: UInt32 = port.read(&buffer, UInt32(amount), 1024 - UInt32(amount), &error)
                
//              NSLog("readPort:%d", readLength)
//
//              for i: UInt32 in 0 ..< readLength {
//                  NSLog("%02x", buffer[Int(amount + i)])
//              }
                
                amount += Int32(readLength)
                
                if parser.completionHandler!(&buffer, &amount) == StarIoExtParserCompletionResult.success {
                    title   = "Send Commands"
                    message = "Success"
                    
                    result = true
                    break
                }
            }
            
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendCommands(_ commands: Data!, portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &commandsArray, count: commands.count)
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.beginCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (BeginCheckedBlock)"
                break
            }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < UInt32(commands.count) {
                let written: UInt32 = port.write(commandsArray, total, UInt32(commands.count) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(commands.count) {
                break
            }
            
            port.endCheckedBlockTimeoutMillis = 30000     // 30000mS!!!
            
            port.endCheckedBlock(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
            if printerStatus.offline == sm_true {
                title   = "Printer Error"
                message = "Printer is offline (EndCheckedBlock)"
                break
            }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func sendCommandsDoNotCheckCondition(_ commands: Data!, portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        var commandsArray: [UInt8] = [UInt8](repeating: 0, count: commands.count)
        
        commands.copyBytes(to: &commandsArray, count: commands.count)
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            while total < UInt32(commands.count) {
                let written: UInt32 = port.write(commandsArray, total, UInt32(commands.count) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
                if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(commands.count) {
                break
            }
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {     // Do not check condition.
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            title   = "Send Commands"
            message = "Success"
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func connectBluetooth(_ completionHandler: SendCompletionHandlerWithNullableString?) {
        EAAccessoryManager.shared().showBluetoothAccessoryPicker(withNameFilter: nil) { (error) -> Void in
            var result: Bool = false
            
            var title:   String? = ""
            var message: String? = ""
            
            if let error = error as NSError? {
                NSLog("Error:%@", error.description)
                
                switch error.code {
                case EABluetoothAccessoryPickerError.alreadyConnected.rawValue :
                    title   = "Success"
                    message = ""
                    
                    result = true
                case EABluetoothAccessoryPickerError.resultCancelled.rawValue,
                     EABluetoothAccessoryPickerError.resultFailed.rawValue :
                    title   = nil
                    message = nil
                    
                    result = false
//              case EABluetoothAccessoryPickerErrorCode.ResultNotFound :
                default                                                 :
                    title   = "Fail to Connect"
                    message = ""
                    
                    result = false
                }
            }
            else {
                title = "Success"
                message = ""
                
                result = true
            }
            
            if completionHandler != nil {
                completionHandler!(result, title, message)
            }
        }
    }
    
    static func disconnectBluetooth(_ modelName: String!, portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        while true {
            guard let port: SMPort = SMPort.getPort(AppDelegate.getPortName(), AppDelegate.getPortSettings(), 10000) else {     // 10000mS!!!
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
            }
            
            if modelName.hasPrefix("TSP143IIIBI") == true {
                let commandArray: [UInt8] = [0x1b, 0x1c, 0x26, 0x49]     // Only TSP143IIIBI
                
                var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
                
                port.beginCheckedBlock(&printerStatus, 2, &error)
                
                if error != nil {
                    break
                }
                
                if printerStatus.offline == sm_true {
                    title   = "Printer Error"
                    message = "Printer is offline (BeginCheckedBlock)"
                    break
                }
                
                let startDate: Date = Date()
                
                var total: UInt32 = 0
                
                while total < UInt32(commandArray.count) {
                    let written: UInt32 = port.write(commandArray, total, UInt32(commandArray.count) - total, &error)
                    
                    if error != nil {
                        break
                    }
                    
                    total += written
                    
                    if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                        title   = "Printer Error"
                        message = "Write port timed out"
                        break
                    }
                }
                
                if total < UInt32(commandArray.count) {
                    break
                }
                
//              port.endCheckedBlockTimeoutMillis = 30000     // 30000mS!!!
//
//              port.endCheckedBlock(&printerStatus, 2, &error)
//
//              if error != nil {
//                  break
//              }
//
//              if printerStatus.offline == sm_true {
//                  title   = "Printer Error"
//                  message = "Printer is offline (EndCheckedBlock)"
//                  break
//              }
            }
            else {
                if port.disconnect() == false {
                    title   = "Fail to Disconnect"
                    message = "Note. Portable Printers is not supported."
                    break
                }
            }
            
            title   = "Success"
            message = ""
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
    
    static func confirmSerialNumber(_ portName: String!, portSettings: String!, timeout: UInt32, completionHandler: SendCompletionHandler?) -> Bool {
        var result: Bool = false
        
        var title:   String = ""
        var message: String = ""
        
        var error: NSError?
        
        while true {
            guard let port: SMPort = SMPort.getPort(portName, portSettings, timeout) else {
                title   = "Fail to Open Port"
                message = ""
                break
            }
            
            defer {
                SMPort.release(port)
            }
            
            var printerStatus: StarPrinterStatus_2 = StarPrinterStatus_2()
            
            port.getParsedStatus(&printerStatus, 2, &error)
            
            if error != nil {
                break
            }
            
//          if printerStatus.offline == sm_true {
//              title   = "Printer Error"
//              message = "Printer is offline (GetParsedStatus)"
//              break
//          }
            
            let startDate: Date = Date()
            
            var total: UInt32 = 0
            
            let commandArray: [UInt8] = [0x1b, 0x1d, 0x29, 0x49, 0x01, 0x00, 49]     // <ESC><GS>')''I'pLpHfn
            
            while total < UInt32(commandArray.count) {
                let written: UInt32 = port.write(commandArray, total, UInt32(commandArray.count) - total, &error)
                
                if error != nil {
                    break
                }
                
                total += written
                
//              if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                if Date().timeIntervalSince(startDate) >=  3.0 {     //  3000mS!!!
                    title   = "Printer Error"
                    message = "Write port timed out"
                    break
                }
            }
            
            if total < UInt32(commandArray.count) {
                break
            }
            
            var information: String = ""
            
            var buffer: [UInt8] = [UInt8](repeating: 0, count: 1024 + 8)
            
            var amount: UInt32 = 0
            
            while true {
//              if Date().timeIntervalSince(startDate) >= 30.0 {     // 30000mS!!!
                if Date().timeIntervalSince(startDate) >=  3.0 {     //  3000mS!!!
                    title   = "Printer Error"
//                  message = "Read port timed out"
                    message = "Can not receive information"
                    break
                }
                
                let readLength: UInt32 = port.read(&buffer, amount, 1024 - amount, &error)
                
                if error != nil {
                    break
                }
                
                if (readLength <= 0) {
                    continue;
                }
                
                amount += readLength
                
                if (amount >= 2) {
                    for i: Int in 0 ..< Int(amount - 1) {
                        if buffer[i + 0] == 0x0a &&
                            buffer[i + 1] == 0x00 {
//                          for j: Int in 0 ..< Int(amount - 7) {
                            for j: Int in 0 ..< Int(amount - 9) {
                                if buffer[j + 0] == 0x1b &&
                                   buffer[j + 1] == 0x1d &&
                                   buffer[j + 2] == 0x29 &&
                                   buffer[j + 3] == 0x49 &&
//                                 buffer[j + 4] == 0x01 &&
//                                 buffer[j + 5] == 0x00 &&
                                    buffer[j + 6] == 49 {
                                    information = ""
                                    
                                    for k: Int in j + 7 ..< Int(amount) {
                                        let text: String = String(format: "%c", buffer[k])
                                        
                                        information += text
                                    }
                                    
                                    result = true
                                    break
                                }
                            }
                            
                            break
                        }
                    }
                }
                
                if result == true {
                    break
                }
            }
            
            if result == false {
                break
            }
            
            result = false
            
            var range: Range<String.Index>?
            
            range = information.range(of: "PrSrN=")
            
            if range == nil {
                title   = "Printer Error"
                message = "Can not receive tag"
                break
            }
            
            var work: String = information.substring(from: range!.upperBound)
            
            range = work.range(of: ",")
            
            if range != nil {
                work = work.substring(to: range!.lowerBound)
            }
            
            title   = "Serial Number"
            message = work
            
            result = true
            break
        }
        
        if error != nil {
            title   = "Printer Error"
            message = error!.description
        }
        
        if completionHandler != nil {
            completionHandler!(result, title, message)
        }
        
        return result
    }
}
