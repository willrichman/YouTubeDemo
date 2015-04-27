    //
//  PlayerViewController.swift
//  YouTubeDemo
//
//  Created by William Richman on 4/24/15.
//  Copyright (c) 2015 Will Richman. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    
    let playerVars: NSMutableDictionary = [
        "autoplay" : 1,
        "rel" : 0,
        "controls":0,
        "playsinline" : 1,
        "autohide" : 1,
        "showinfo" : 0,
        "modestbranding" : 1,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.playerView.delegate = self
        NetworkController.controller.returnRandomVideoID { (id, errorDescription) -> Void in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.playerView.loadWithVideoId(id!, playerVars: self.playerVars as [NSObject : AnyObject])

            }
        }
        
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
        self.startNewVideo()
    }
    
    // MARK: YTPlayerViewDelegate functions

    func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        println(state.value)
        if state.value == 1 {
            // If player ends, add new video
            self.startNewVideo()
        } else if state.value == 0 {
            // If player can't load video, start new video
            self.startNewVideo()
        }
    }
    
    // MARK: Custom video load function
    
    func startNewVideo() {
        self.playerView.stopVideo()
        NetworkController.controller.returnRandomVideoID { (id, errorDescription) -> Void in
            if errorDescription != nil {
                println(errorDescription)
            } else {
                self.playerView.loadVideoById(id!, startSeconds: 0, suggestedQuality: YTPlaybackQuality.Large)
            }
        }
    }
}

