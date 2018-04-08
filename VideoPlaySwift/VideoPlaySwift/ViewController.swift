//
//  ViewController.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/3.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var mediaPlayer = VideoPlay.shareSingle
    
    @IBOutlet weak var playView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func playButtonAction(_ sender: Any) {
        playVideo()
        //addPlayUI()
    }
    
    
    @IBAction func continuePlayAction(_ sender: Any) {
        mediaPlayer.play()
    }
    
    @IBAction func pauseButtonAction(_ sender: Any) {
        mediaPlayer.pause()
    }
    
    
    @IBAction func removeButtomAction(_ sender: Any) {
        mediaPlayer.remove()
    }
    
    func playVideo() {
        
       let playLayer = mediaPlayer.setup(url: "http://flv3.bn.netease.com/tvmrepo/2018/4/N/L/EDDG5RGNL/SD/EDDG5RGNL-mobile.mp4", frame: playView.bounds)
        playView.layer.addSublayer(playLayer)
        mediaPlayer.play()
    }
    
    func addPlayUI() {
        let playUI = VideoPlayView(frame: playView.bounds)
        playView.addSubview(playUI)
        
    }

}

