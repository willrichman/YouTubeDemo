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
    var maxTime: Double
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
    
    init() {
        self.RFC3339DateFormatter.locale = enUSPOSIXLocale
        self.RFC3339DateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        self.RFC3339DateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let currentDate = NSDate().timeIntervalSince1970
        self.maxTime = currentDate - self.timeInterval
    }
    
    // MARK: Video retrieval functions
    
    func returnRandomVideoID() -> String? {
        if self.notYetPlayed.isEmpty {
            populateRandomVideoSet()
        }
        let randomIndex = Int(arc4random_uniform(UInt32(self.notYetPlayed.count - 1)))
        var videoToPlay = self.notYetPlayed[randomIndex]
        self.notYetPlayed.removeAtIndex(randomIndex)
        self.alreadyPlayed[videoToPlay] = true
        return videoToPlay
    }
    
    func populateRandomVideoSet() {
        let baseQuery = "key=" + APIKey + "&q=cats&part=id&type=video&videoDuration=short&videoEmbeddable=true"
        let monthTuple = returnRandomMonth()
        let startDate = monthTuple.0
        let endDate = monthTuple.1
        let fullQuery = baseQuery + "&publishedAfter=" + startDate! + "&publishedBefore=" + endDate!
    }
    
    func returnRandomMonth() -> (String?, String?) {
        let startTime = Double(arc4random_uniform(UInt32(self.maxTime - self.baseTime))) + self.baseTime
        let endTime = startTime + timeInterval
        let startTimeRFC = self.RFC3339DateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: startTime))
        println(startTimeRFC)
        let endTimeRFC = self.RFC3339DateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: endTime))
        println(endTimeRFC)
        return (startTimeRFC, endTimeRFC)
    }
}

