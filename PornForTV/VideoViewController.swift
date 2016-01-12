//
//  VideoViewController.swift
//  PornForTV
//
//  Created by Tomoya_Hirano on H28/01/12.
//  Copyright © 平成28年 noppefoxwolf. All rights reserved.
//

import AVKit

class VideoViewController: AVPlayerViewController {
  class func viewController(url:NSURL)->VideoViewController{
    let vc = VideoViewController()
    vc.url = url
    return vc
  }
  var url:NSURL!
  override func viewDidLoad() {
    super.viewDidLoad()
    player = AVPlayer(URL: url)
    player?.actionAtItemEnd = .None
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: player?.currentItem)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func playerItemDidReachEnd(notification:NSNotification){
    let p = notification.object
    p?.seekToTime(kCMTimeZero)
  }
  
  func playPause(){
    if player?.rate == 0 {
      player?.play()
    }else{
      player?.pause()
    }
  }
}