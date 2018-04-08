//
//  VideoCell.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/8.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit
import Kingfisher

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var videoCover: UIImageView!
    
    @IBOutlet weak var titleDesc: UILabel!
    
    private var videoUrl: String?
    
    class func setup(tableView: UITableView, indexPath: IndexPath) -> VideoCell {
        let nib = UINib(nibName: "VideoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VideoCell")
        let cell: VideoCell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        return cell
    }
    
    func set(model: DataModel.Model) {
        
        videoUrl = model.videoUrl
        
        if let strUrl = model.authorImage, let url = URL(string: strUrl) {
            let res: ImageResource = ImageResource(downloadURL: url)
            authorImage.kf.setImage(with: res)
        }
        if let strUrl = model.videoCover, let url = URL(string: strUrl) {
            let res: ImageResource = ImageResource(downloadURL: url)
            videoCover.kf.setImage(with: res)
        }
        
        authorName.text = model.authorName
        time.text = model.time
        titleDesc.text = model.videoDesc
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        guard let urlStr = videoUrl else {
            return
        }
        let mediaPlayer = VideoPlay.shareSingle
        let playLayer = mediaPlayer.setup(url: urlStr, frame: playView.bounds)
        playView.layer.addSublayer(playLayer)
        mediaPlayer.play()
    }
    
}
