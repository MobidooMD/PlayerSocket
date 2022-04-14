//
//  LogManager.swift
//  PlayerSocket
//
//  Created by 김원철 on 2022/04/13.
//

import Foundation
import Lottie
import os.log

enum LogType: String {
    case Normal = "SAUCELog 🧡 *** Normal"
    case Network = "SAUCELog 💜 *** Network"
    case UI = "SAUCELog ❣️ *** UI"
    case Marketing = "SAUCELog 💚 *** Marketing"
    case Push = "SAUCELog 💙 Push"
    case WebSocket = "SAUCELog 💡 Socket"
    case Kinesis = "SAUCELog ⭐️ Kinesis"
}

class LogManager: NSObject {
    
    private static let FORCE_LOG = false
    
    static func print(output: Any?, logType: LogType = .Normal, osLogType: OSLogType = .default, file: String = #file, line: Int = #line) {
        
        var filename: NSString = file as NSString
        filename = filename.lastPathComponent as NSString
        
        if FORCE_LOG {
            if let output = output as? CVarArg {
                NSLog("%@ : %@ ----- %i Line ----- ::: %@", logType.rawValue, filename, #line, output)
            }
        } else {
            #if DEBUG
            saucePrint(output: output, osLogType: osLogType, logType: logType, filename: filename, line: line)
            #else
            if #available(iOS 12.0, *) {
                os_log("", "")
            } else {
                Swift.print("")
            }
            #endif
        }
        
    }
    
    private static func saucePrint(output: Any?, osLogType: OSLogType, logType: LogType, filename: NSString, line: Int) {
        
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: logType.rawValue)
        
        if #available(iOS 12.0, *) {
            if let output = output as? CVarArg {
                os_log(osLogType, log: log, "%@ ----- %i Line ----- %@", filename, line, output)
            }
        } else {
            Swift.print("SAUCE LOG : \(filename) ----- \(line) Line ----- \n\(output ?? "")")
        }
        
    }
    
}
