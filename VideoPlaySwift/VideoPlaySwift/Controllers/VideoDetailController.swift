//
//  VideoDetailController.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/8.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class VideoDetailController: UIViewController {
    
    // 带UI的视频
    private var player = VideoPlayView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let playingUrl = VideoPlay.shareSingle.currentPlayingUrl() {
           player.playVideo(url: playingUrl, frame: view.bounds)
        }
        view.addSubview(player)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
