//
//  VideoPlay.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/3.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit
import AVFoundation

protocol VideoPlayDelegate: NSObjectProtocol {
    /// 更新缓冲进度
    func updateProgress(progress: Float)
    /// 更新视频总时间
    func updateTotalTime(totalTime: Float)
    /// 更新当前播放时间 progress: 进度  value: 秒
    func updatePlayTime(progress: Float, value: Float)
    /// 播放完成
    func playFinish()
    /// 加载中
    func loading()
    /// 准备播放
    func ready()
    /// 播放错误
    func error()
}

class VideoPlay: NSObject {
    
    enum Status {
        case none
        case playing
        case pausing
    }
    
    weak var delegate: VideoPlayDelegate?
    var status: Status = Status.none

    private lazy var player: AVPlayer = {
        guard let url = currentPlayUrl else {
            return AVPlayer()
        }
        let item = AVPlayerItem(url: URL(string: url)!)
        let player = AVPlayer(playerItem: item)
        return player
    }()
    
    // 当前正在播放的视频，可以为空
    private var currentPlayUrl: String?
    // 画面层
    private var playerLayer = AVPlayerLayer()
    // 播放进度的timer
    private var playScheduleTimer = Timer()
    
    private let kvo_loadedTimeRanges = "loadedTimeRanges"
    private let kvo_status = "status"
    private let kvo_isPlaybackBufferEmpty = "playbackBufferEmpty"
    
    // 单例
    static let shareSingle = VideoPlay()
    private override init(){
        super.init()
        // 添加播放完成的通知
        addNotification()
    }
    
    public func setup(url: String, frame: CGRect) -> AVPlayerLayer {
        currentPlayUrl = url
        
        let playItem = AVPlayerItem(url: URL(string: url)!)
        player.replaceCurrentItem(with: playItem)
        // 添加观察者
        addObserverToPlayItem()
        // 监控播放进度
        setupScheduleTimer()
        
        playerLayer = AVPlayerLayer(player: self.player)
        playerLayer.frame = frame
        playerLayer.videoGravity = .resizeAspectFill
        return playerLayer
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

/// 视频操作
extension VideoPlay {
    
    func play() {
        guard let _ = currentPlayUrl else {
            print("url为空")
            return
        }
        player.play()
        status = Status.playing
    }
    
    func pause() {
        player.pause()
        status = Status.pausing
    }
    
    func remove() {
        if let playerItem = player.currentItem {
            playerItem.seek(to: kCMTimeZero, completionHandler: nil)
            playerItem.removeObserver(self, forKeyPath: kvo_loadedTimeRanges)
            playerItem.removeObserver(self, forKeyPath: kvo_status)
            playerItem.removeObserver(self, forKeyPath: kvo_isPlaybackBufferEmpty)
        }
        player.replaceCurrentItem(with: nil)
        currentPlayUrl = nil
        playerLayer.removeFromSuperlayer()
        playScheduleTimer.invalidate()
        status = Status.none
    }
    
    /// 静音
    func set(volume: Float) {
        player.volume = volume
    }
    
    /// 调到某个时间点播放
    func seekTo(time: Float) {
        let changeTime = CMTimeMakeWithSeconds(Float64(time), 1)
        player.currentItem?.seek(to: changeTime, completionHandler: { (finish) in
            //print("快进或回退完成")
        })
        
    }
    /// 获取当前播放时间
    func currentPlayTime() -> Float {
        guard let item = player.currentItem else {
            return 0.0
        }
        let time: CMTime = item.currentTime()
        let currentTime = Float(time.value) / Float(time.timescale)
        return currentTime
    }
    /// 当前正在播放的视频的url
    func currentPlayingUrl() -> String? {
        return currentPlayUrl
    }
}

/// 通知
extension VideoPlay {
    private func addNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playItemDidPlayToEnd(nitification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: nil)
    }
    
    @objc private func playItemDidPlayToEnd(nitification: Notification) {
        print("播放完成")
        // 播放完成以后，使用者需要自己决定是否移除视频
        delegate?.playFinish()
        //remove()
    }
}

/// 观察者
extension VideoPlay {
    
    //添加观察者，观察视频下载过程以及视频播放状态
    private func addObserverToPlayItem() {
        guard let item = player.currentItem else {
            return
        }
        item.addObserver(self,
                         forKeyPath: kvo_loadedTimeRanges,
                         options: .new,
                         context: nil)
        item.addObserver(self,
                         forKeyPath: kvo_status,
                         options: .new,
                         context: nil)
        item.addObserver(self,
                         forKeyPath: kvo_isPlaybackBufferEmpty,
                         options: .new,
                         context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let item = object,
              item is AVPlayerItem else {
                return
        }
        let playItem: AVPlayerItem = item as! AVPlayerItem
        
        let totalTimeM = playItem.duration
        let totalTime = Float(totalTimeM.value)/Float(totalTimeM.timescale)
        delegate?.updateTotalTime(totalTime: totalTime)
        
        switch keyPath {
            
        case kvo_status:
            
            switch playItem.status {
            case .unknown:
                delegate?.error()
            case .readyToPlay:
                delegate?.ready()
            case .failed:
                delegate?.error()
            }
            
        case kvo_loadedTimeRanges:
            // 加载时间
            let array = playItem.loadedTimeRanges
            // 本次缓冲时间范围
            let timeRange = array.first as! CMTimeRange
            let start: Float = Float(CMTimeGetSeconds(timeRange.start))
            let duration: Float = Float(CMTimeGetSeconds(timeRange.duration))
            //缓冲总时长
            let totalBuffer: TimeInterval = TimeInterval(start + duration)
            //缓冲进度
            let progress: Float = Float(totalBuffer*1.0)/Float(totalTime)
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateProgress(progress: progress)
            }
            
        case kvo_isPlaybackBufferEmpty:
            guard
                let change = change,
                let isEmpty = change[.newKey] as? Bool else {
                    return
            }
            if isEmpty {
                delegate?.loading()
            }
        default: break
            
        }
        // 缓冲
        if keyPath == kvo_loadedTimeRanges {

        }
        
    }
    
}

/// 播放进度
extension VideoPlay {
    
    func setupScheduleTimer() {
        if playScheduleTimer.isValid == true {
            playScheduleTimer.invalidate()
        }
        playScheduleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scheduleTimer), userInfo: nil, repeats: true)
    }
    
    @objc func scheduleTimer() {
        guard let item = player.currentItem else {
            return
        }
        let currentProgress = CMTimeGetSeconds(item.currentTime())/CMTimeGetSeconds(item.duration)
        let time: CMTime = item.currentTime()
        let currentTime = Float(time.value) / Float(time.timescale)
        delegate?.updatePlayTime(progress: Float(currentProgress),
                                 value: currentTime)
    }
    
}


