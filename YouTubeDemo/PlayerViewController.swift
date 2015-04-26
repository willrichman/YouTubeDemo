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
//        "loop" : 1,
//        "playlist" : "Veg63B8ofnQ"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()

        self.playerView.loadWithVideoId("Veg63B8ofnQ", playerVars: playerVars as [NSObject : AnyObject])
        
    }
    
    // MARK: Status bar functions

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false;
    }
    
    // MARK: IBAction functions
    
    @IBAction func pressedNewVideo(sender: AnyObject) {
    }
}

