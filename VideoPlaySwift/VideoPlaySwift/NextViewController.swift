//
//  NextViewController.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/3.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    @IBOutlet weak var playView: UIView!
    
    private var player = VideoPlayView()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startPlay(_ sender: Any) {

        player.playVideo(url: "http://flv3.bn.netease.com/tvmrepo/2018/4/N/L/EDDG5RGNL/SD/EDDG5RGNL-mobile.mp4", frame: playView.bounds)
        playView.addSubview(player)
    }
    
    @IBAction func continuePlay(_ sender: Any) {
        player.play()
    }
    
    @IBAction func pause(_ sender: Any) {
        player.pause()
    }
    
    
    @IBAction func remove(_ sender: Any) {
        player.remove()
    }
    
}
