//
//  VideoPlayView.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/3.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit
import SnapKit

class VideoPlayView: UIView {

    lazy var backgroundView: UIView = {
        $0.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        return $0
    }( UIView() )
    lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = ""
        $0.isHidden = true //默认隐藏，当前版本不需要标题
        return $0
    }( UILabel() )
    lazy var timeView: UIView = {
        return $0
    }( UIView() )
    lazy var currentTimeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "00:00"
        return $0
    }( UILabel() )
    lazy var totalTimeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "00:00"
        return $0
    }( UILabel() )
    lazy var progress: UIProgressView = {
        $0.progressTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.4)
        $0.trackTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        $0.progress = 0
        return $0
    }( UIProgressView() )
    lazy var slider: CustomSlider = {
        $0.setThumbImage(#imageLiteral(resourceName: "sliderThumbImage"), for: .normal)
        $0.height = 5
        $0.maximumTrackTintColor = .clear
        $0.minimumTrackTintColor = UIColor(red: 174/255.0, green: 119/255.0, blue: 255/255.0, alpha: 1.0)
        $0.addTarget(self,
                     action: #selector(sliderTouchDown(slider:)),
                     for: .touchDown)
        $0.addTarget(self,
                     action: #selector(sliderEnd(slider:)),
                     for: .touchUpInside)
        $0.addTarget(self,
                     action: #selector(sliderValueChange(slider:)),
                     for: .valueChanged)
        return $0
    }( CustomSlider() )
    lazy var playAndPauseButton: UIButton = {
        $0.setImage(#imageLiteral(resourceName: "play"), for: .selected)
        $0.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        $0.addTarget(self,
                     action: #selector(playOrPauseButtonAction(button:)),
                     for: .touchUpInside)
        return $0
    }( UIButton() )
    lazy var topTimeView: UIView = {// 快进或者回退
        $0.isHidden = true
        return $0
    }( UIView() )
    lazy var topCurrentTimeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "00:00"
        return $0
    }( UILabel() )
    lazy var topTotalTimeLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
        $0.textAlignment = .left
        $0.text = "/00:00"
        return $0
    }( UILabel() )
    lazy var backForwardImage: UIImageView = {
        $0.image = #imageLiteral(resourceName: "backForward")
        return $0
    }( UIImageView() )
    lazy var fastForwardImage: UIImageView = {
        $0.image = #imageLiteral(resourceName: "fastForward")
        return $0
    }( UIImageView() )
    
    // 播放媒介
    private var mediaPlayer = VideoPlay.shareSingle
    // slider是否正在被手动滑动
    private var isSliderDraging: Bool = false
    // 视频总时间
    private var videoTotalTime: Float = 0.0
    // 和触摸相关的一些值
    // 用来判断手势是否移动过
    private var hasMoved: Bool = false
    // 触摸开始的位置
    private var touchBeginPoint: CGPoint?
    // 记录触摸开始时的视频播放的时间
    private var touchBeginValue: Float = 0
    // 最小移动距离
    private let leastDistance: Float = 15
    // 整个屏幕代表的时间(s)
    private let totalScreenTime: Float = 40
    // 自动隐藏
    private var autoHideTask: DelayTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
      
        backgroundColor = .clear
        
        addSubview(backgroundView)
        addSubview(playAndPauseButton)
        addSubview(topTimeView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(timeView)
        backgroundView.addSubview(progress)
        backgroundView.addSubview(slider)
        timeView.addSubview(currentTimeLabel)
        timeView.addSubview(totalTimeLabel)
        topTimeView.addSubview(topCurrentTimeLabel)
        topTimeView.addSubview(topTotalTimeLabel)
        topTimeView.addSubview(backForwardImage)
        topTimeView.addSubview(fastForwardImage)
        
        setupGestures()
    }
    
    func setupGestures() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showOrHideTap(tap:)))
        //tap.delaysTouchesBegan = true
        addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backgroundView.snp.left).offset(10)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(44)
        }
        playAndPauseButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        totalTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right).offset(0)
            make.right.equalToSuperview()
            make.centerY.equalTo(currentTimeLabel.snp.centerY)
        }
        timeView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(snp.centerY).offset(40)
            make.left.equalTo(currentTimeLabel.snp.left)
            make.right.equalTo(totalTimeLabel.snp.right)
            make.top.equalTo(currentTimeLabel.snp.top)
            make.bottom.equalTo(currentTimeLabel.snp.bottom)
        }
        slider.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(49)
        }
        progress.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalTo(slider.snp.centerY)
            make.right.equalToSuperview()
            make.height.equalTo(4.5)
        }
        backForwardImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        topCurrentTimeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalTo(backForwardImage.snp.right)
            make.centerY.equalToSuperview()
        }
        topTotalTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(topCurrentTimeLabel.snp.right)
            make.centerY.equalTo(topCurrentTimeLabel.snp.centerY)
        }
        fastForwardImage.snp.makeConstraints { (make) in
            make.left.equalTo(topTotalTimeLabel.snp.right)
            make.centerY.equalTo(topTotalTimeLabel.snp.centerY)
        }
        topTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(91)
            make.centerX.equalToSuperview()
            make.left.equalTo(backForwardImage.snp.left).offset(0)
            make.top.equalTo(topCurrentTimeLabel.snp.top).offset(0)
            make.right.equalTo(fastForwardImage.snp.right).offset(0)
            make.bottom.equalTo(topCurrentTimeLabel.snp.bottom).offset(0)
        }
        
    }

}

/// 点击事件相关
extension VideoPlayView {
    
    /// 显示\隐藏 控制按钮事件
    @objc func showOrHideTap(tap: UITapGestureRecognizer) {
        if backgroundView.isHidden == true {
            controlsUI(hide: false)
        }
        handleAutoHide()
    }
    
    @objc func playOrPauseButtonAction(button: UIButton) {
        button.isSelected = !button.isSelected
        button.isSelected ? pause() : play()
    }
    
    @objc func sliderTouchDown(slider: CustomSlider) {
        isSliderDraging = true
        Cancel(task: autoHideTask)
    }
    
    @objc func sliderEnd(slider: CustomSlider) {
        isSliderDraging = false
        let time = slider.value * videoTotalTime
        mediaPlayer.seekTo(time: time)
        handleAutoHide()
    }
    
    @objc func sliderValueChange(slider: CustomSlider) {
        let time = slider.value * videoTotalTime
        let timeStr = timeToHMS(time: time)
        currentTimeLabel.text = timeStr
    }
    
    // 显示和隐藏控件
    @objc func controlsUI(hide: Bool) {
        backgroundView.isHidden = hide
        playAndPauseButton.isHidden = hide
    }
    // 隐藏控件
    @objc func controlHide() {
        controlsUI(hide: true)
    }
}

/// 播放相关
extension VideoPlayView {
    
    /// 带播放控件的视频播放器
    func playVideo(url: String, frame: CGRect) {
        self.frame = frame
        mediaPlayer.delegate = self
        let playerLayer = mediaPlayer.setup(url: url, frame: frame)
        self.layer.insertSublayer(playerLayer, at: 0)
        play()
        // 开始播放之后，3s隐藏UI
        DispatchQueue.main.asyncAfter(deadline: .now()+3.0) {[weak self] in
            self?.controlsUI(hide: true)
        }
    }
    
    func play() {
        mediaPlayer.play()
    }
    
    func pause() {
        mediaPlayer.pause()
    }
    
    func remove() {
        mediaPlayer.remove()
        removeFromSuperview()
    }
    
    func set(volume: Float) {
        mediaPlayer.set(volume: volume)
    }
    /// 调到时间点time进行播放
    func seekToTime(time: Float) {
        mediaPlayer.seekTo(time: time)
    }
}

/// 代理相关
extension VideoPlayView: VideoPlayDelegate {
    
    func updateProgress(progress: Float) {
        self.progress.progress = progress
    }
    
    func updateTotalTime(totalTime: Float) {
        videoTotalTime = totalTime
        let time = timeToHMS(time: totalTime)
        totalTimeLabel.text = " / \(time)"
        topTotalTimeLabel.text = " / \(time)"
    }
    
    func updatePlayTime(progress: Float, value: Float) {
        if isSliderDraging == true {
            // 如果slider正在被手动拖动的话，暂时不更新正在播放的进度
            return
        }
        slider.value = progress
        currentTimeLabel.text = timeToHMS(time: value)
        topCurrentTimeLabel.text = timeToHMS(time: value)
    }
    
    func playFinish() {
        removeFromSuperview()
    }
}

/// touches 快进或回退“手势”
extension VideoPlayView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 如果有多个手指点击则不做出响应
        guard let touch = touches.first,
              touches.count == 1,
              touch.tapCount == 1,
            (event?.allTouches?.count)! == 1 else {
            return
        }
        
        super.touchesBegan(touches, with: event)
        
        // 触摸开始, 初始化一些值
        hasMoved = false
        touchBeginValue = slider.value
        // 位置
        touchBeginPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 如果有多个手指点击则不做出响应
        guard let touch = touches.first,
            touches.count == 1,
            touch.tapCount == 1,
            (event?.allTouches?.count)! == 1 else {
                return
        }
        
        super.touchesMoved(touches, with: event)
        
        // 如果移动距离过小，就判断没有移动
        let tempPoint = touch.location(in: self)
        if fabsf(Float(tempPoint.x - (touchBeginPoint?.x)!)) < leastDistance {
            return
        }
        hasMoved = true
        isSliderDraging = true
        let value = moveProgressControll(tempPoint: tempPoint)
        timeValueChanging(value: value)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSliderDraging = false
        self.topTimeView.isHidden = true
        super.touchesEnded(touches, with: event)
        if hasMoved == true {
            let tempPoint = touches.first?.location(in: self)
            let value = moveProgressControll(tempPoint: tempPoint!)
            seekToTime(time: value)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesCancelled(touches, with: event)
        if hasMoved == true {
            let tempPoint = touches.first?.location(in: self)
            let value = moveProgressControll(tempPoint: tempPoint!)
            seekToTime(time: value)
        }
    }
    
    /// 用来控制移动过程中计算手指划过的时间
    func moveProgressControll(tempPoint: CGPoint) -> Float {
        let temp = (tempPoint.x - (touchBeginPoint?.x)!)/(UIScreen.main.bounds.size.width)
        var tempValue = touchBeginValue * videoTotalTime + totalScreenTime * Float(temp)
        if tempValue > videoTotalTime {
            tempValue = videoTotalTime
        } else if tempValue < 0 {
            tempValue = 0
        }
        return tempValue
    }
    /// 用来显示时间的view在时间发生变化时所作的操作
    func timeValueChanging(value: Float) {
        if value > (touchBeginValue * videoTotalTime) {
            backForwardImage.isHidden = true
            fastForwardImage.isHidden = false
        } else {
            backForwardImage.isHidden = false
            fastForwardImage.isHidden = true
        }
        topTimeView.isHidden = false
        
        topCurrentTimeLabel.text = timeToHMS(time: value)
        let tempValue = value / videoTotalTime
        slider.setValue(tempValue, animated: true)

    }
}

/// 工具相关
extension VideoPlayView {
    
    /// 把浮点型的秒转成时分秒字符串
    func timeToHMS(time: Float) -> String {
        
        let format = DateFormatter()
        if time / 3600 >= 1 {
            format.dateFormat = "HH:mm:ss"
        } else {
            format.dateFormat = "mm:ss"
        }
        let string = format.string(from: Date(timeIntervalSince1970: TimeInterval(time)))
        return string
    }
    
    func handleAutoHide(_ cancel: Bool = false) {
        Cancel(task: autoHideTask)
        autoHideTask = nil
        if !cancel {
            autoHideTask = Delay(time: 3.0) { [weak self] in
                guard let this = self else { return }
                print("自动隐藏")
                this.controlsUI(hide: true)
            }
        }
    }
    
}







