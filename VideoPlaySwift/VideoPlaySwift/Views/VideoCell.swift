//
//  VideoCell.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/8.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit
import Kingfisher

protocol VideoCellDelegate: NSObjectProtocol {
    
    /// 检查当前正在播放的视频和点击的视频是否是同一个视频
    func checkPlayingVideo(indexPath: IndexPath)
}

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var videoCover: UIImageView!
    @IBOutlet weak var titleDesc: UILabel!
    
    weak var delegate: VideoCellDelegate?
    private var videoUrl: String?
    private let mediaPlayerWithoutUI = VideoPlay.shareSingle
    private let mediaPlayer = VideoPlayView()
    private var cellIndexPath: IndexPath?
    
    class func setup(tableView: UITableView, indexPath: IndexPath) -> VideoCell {
        let nib = UINib(nibName: "VideoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VideoCell")
        let cell: VideoCell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.cellIndexPath = indexPath
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
        guard let urlStr = videoUrl,
              let indexPath = cellIndexPath else {
            return
        }
        
        delegate?.checkPlayingVideo(indexPath: indexPath)
        
        //使用不带任何UI的播放器
        //usePlayerWithoutUI(urlStr: urlStr)

        //使用带UI的播放器
        usePlayerWithUI(urlStr: urlStr)
       
    }
    
    func usePlayerWithoutUI(urlStr: String) {
        //
        let playLayer = mediaPlayerWithoutUI.setup(url: urlStr, frame: playView.bounds)
        playView.layer.addSublayer(playLayer)
        mediaPlayer.play()
    }
    
    private func usePlayerWithUI(urlStr: String) {
        playView.addSubview(mediaPlayer)
        mediaPlayer.playVideo(url: urlStr, frame: playView.bounds)
    }
    
}
