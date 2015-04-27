//
//  NetworkController.swift
//  YouTubeDemo
//
//  Created by William Richman on 4/26/15.
//  Copyright (c) 2015 Will Richman. All rights reserved.
//

import UIKit

class NetworkController {
    
    let APIKey = "AIzaSyCjepqbIjcTQnnsKzoiAPZDeueEaUyBCow"
    let baseTime: Double = 1114214400 - NSTimeIntervalSince1970 // Day of first YouTube video
    let timeInterval: Double = 2629740  // Approximately one month
    var maxTime: Double?
    var notYetPlayed = [String]()
    var alreadyPlayed = Dictionary<String, Bool>()
    let RFC3339DateFormatter = NSDateFormatter()
    let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    
    // MARK: Singleton method and initializer
    class var controller: NetworkController {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : NetworkController? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkController()
        }
        return Static.instance!
    }
}
