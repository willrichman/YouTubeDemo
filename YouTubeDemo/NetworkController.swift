//
//  NetworkController.swift
//  YouTubeDemo
//
//  Created by William Richman on 4/26/15.
//  Copyright (c) 2015 Will Richman. All rights reserved.
//

import UIKit

class NetworkController {
    
    let baseURL = "https://www.googleapis.com/youtube/v3/search"
    let APIKey = "AIzaSyCjepqbIjcTQnnsKzoiAPZDeueEaUyBCow"
    
    let baseTime: Double = 1114214400 - NSTimeIntervalSince1970 // Day of first YouTube video
    let timeInterval: Double = 2629740  // Approximately one month
    var maxTime: Double
    let RFC3339DateFormatter = NSDateFormatter()
    let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    
    var notYetPlayed = [String]()
    var alreadyPlayed = Dictionary<String, Bool>()
    
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
    
    func returnRandomVideoID(completionHandler: (errorDescription: String?) -> Void) -> String? {
        var videoToPlay: String?
        if self.notYetPlayed.isEmpty {
            populateRandomVideoSet({ (errorDescription) -> Void in
                if errorDescription != nil {
                    let randomIndex = Int(arc4random_uniform(UInt32(self.notYetPlayed.count - 1)))
                    videoToPlay = self.notYetPlayed[randomIndex]
                    self.notYetPlayed.removeAtIndex(randomIndex)
                    self.alreadyPlayed[videoToPlay!] = true
                }
            })
        } else {
            let randomIndex = Int(arc4random_uniform(UInt32(self.notYetPlayed.count - 1)))
            videoToPlay = self.notYetPlayed[randomIndex]
            self.notYetPlayed.removeAtIndex(randomIndex)
            self.alreadyPlayed[videoToPlay!] = true
            
        }
        return videoToPlay
    }
    
    func populateRandomVideoSet(completionHandler: (errorDescription: String?) -> Void) {
        // Returns and populates an array of video IDs from a random month
        let baseQuery = "key=" + APIKey + "&q=cats&part=id&type=video&videoDuration=short&videoEmbeddable=true&maxResults=25"
        let monthTuple = returnRandomMonth()
        let startDate = monthTuple.0
        let endDate = monthTuple.1
        let fullQuery = baseQuery + "&publishedAfter=" + startDate! + "&publishedBefore=" + endDate!
        let fullURLString = self.baseURL + fullQuery
        let fullURL = NSURL(string: fullURLString)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(fullURL!, completionHandler: { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse {
                if error != nil {
                    // If there is an error in the web request, print to console
                    println(error.localizedDescription)
                } else {
                    switch httpResponse.statusCode {
                    case 200...299:
                        println("Success!!")
                        let newArray = self.parseJSONIntoArray(data)
                        if newArray != nil {
                            self.notYetPlayed = newArray!
                            completionHandler(errorDescription: nil)
                        } else {
                            completionHandler(errorDescription: "There was an error with the data returned")
                        }
                    case 400...499:
                        println("error on the client")
                        println(httpResponse.description)
                        completionHandler(errorDescription: httpResponse.description)
                    case 500...599:
                        println("error on the server")
                        completionHandler(errorDescription: httpResponse.description)
                    default:
                        println("something bad happened")
                        completionHandler(errorDescription: httpResponse.description)
                    }
                }
            } else {
                println("Something bad happened")
            }
        })
    }
    
    func returnRandomMonth() -> (String?, String?) {
        // Returns a random start and end date equal to approximately a month within the operating dates of YouTube
        let startTime = Double(arc4random_uniform(UInt32(self.maxTime - self.baseTime))) + self.baseTime
        let endTime = startTime + timeInterval
        let startTimeRFC = self.RFC3339DateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: startTime))
        println(startTimeRFC)
        let endTimeRFC = self.RFC3339DateFormatter.stringFromDate(NSDate(timeIntervalSinceReferenceDate: endTime))
        println(endTimeRFC)
        return (startTimeRFC, endTimeRFC)
    }
    
    func parseJSONIntoArray(rawJSONData: NSData) -> [String]? {
        return nil
    }
}

