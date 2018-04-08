# PlayVideoSwift
swift语言封装的视频播放器。

把视频播放功能和视频的UI独立开来。

如果你只想使用视频播放的功能，自己定义UI，没问题，完全可以。

如果你想使用定义好的UI，也可以。

只使用视屏播放功能：
视频播放的类： VideoPlay，继承自NSObject。

代理：

protocol VideoPlayDelegate: NSObjectProtocol {

    /// 更新缓冲进度
    func updateProgress(progress: Float)
    
    /// 更新视频总时间
    func updateTotalTime(totalTime: Float)
    
    /// 更新当前播放时间 progress: 进度  value: 秒
    func updatePlayTime(progress: Float, value: Float)
    
    /// 播放完成
    func playFinish()
    
}



使用简单案例：

   private var mediaPlayer = VideoPlay.shareSingle
    
    @IBOutlet weak var playView: UIView!
    
    func playVideo() {
        
       let playLayer = mediaPlayer.setup(url: "http://flv3.bn.netease.com/tvmrepo/2018/4/N/L/EDDG5RGNL/SD/EDDG5RGNL-mobile.mp4", frame: playView.bounds)
        playView.layer.addSublayer(playLayer)
        mediaPlayer.play()
    }
    
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
    
    
    
    
