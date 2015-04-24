//
//  PlayerViewController.swift
//  YouTubeDemo
//
//  Created by William Richman on 4/24/15.
//  Copyright (c) 2015 Will Richman. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    
    let playerVars: NSDictionary = ["controls":0,
        "playsinline" : 1,
        "autohide" : 1,
        "showinfo" : 0,
        "modestbranding" : 1,
        "loop" : 1,
        "playlist" : "Veg63B8ofnQ"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.playerView.loadWithVideoId("Veg63B8ofnQ", playerVars: playerVars as [NSObject : AnyObject])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

