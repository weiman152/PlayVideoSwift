# PlayVideoSwift
swift语言封装的视频播放器。

把视频播放功能和视频的UI独立开来。

如果你只想使用视频播放的功能，自己定义UI，没问题，完全可以。

如果你想使用定义好的UI，也可以。

如果你要使用封装的UI，也就是VideoPlayView，  需要导入autolayout的一个库 SnapKit 。类似于OC中的Masonry。不过这个库是swift版本的。

依赖库：
SnapKit（自动布局）
Kingfisher（加载网络图片）
这两个库都是纯swift版本的，都很好用。

demo中是使用cocopods进行导入的。

platform :ios, '9.0'
inhibit_all_warnings!

target 'VideoPlaySwift' do
use_frameworks!

pod 'SnapKit'
pod 'Kingfisher'

end


只使用视屏播放功能：
视频播放的类： VideoPlay，继承自NSObject。

效果简单截图：

列表：

![Alt text](https://github.com/weiman152/PlayVideoSwift/blob/master/ScreenShots/%E8%A7%86%E9%A2%91%E5%88%97%E8%A1%A8.png)

<br>

列表播放：

![Alt text](https://github.com/weiman152/PlayVideoSwift/blob/master/ScreenShots/%E8%A7%86%E9%A2%91%E5%88%97%E8%A1%A8%E6%92%AD%E6%94%BE.gif)

<br><br>


没有UI，纯播放:
![Alt text](https://github.com/weiman152/PlayVideoSwift/blob/master/ScreenShots/%E6%B2%A1%E6%9C%89UI%EF%BC%8C%E7%BA%AF%E6%92%AD%E6%94%BE.gif)

<br><br>

带UI的播放：
![Alt text](https://github.com/weiman152/PlayVideoSwift/blob/master/ScreenShots/%E5%B8%A6UI%E7%9A%84%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE.gif)

<br><br>


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
    
    
    使用带UI的播放器VideoPlayView，这是一个继承自UIView的类，封装了基本的UI，
    
    比如视频的title（默认隐藏），
    
    视频总时长
    
    视频当前播放时长
    
    视频缓冲条
    
    视频进度滑动条
    
    播放/暂停 按钮
    
    使用方式：
    
    @IBOutlet weak var playView: UIView!
    
    // 带UI的视频
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
    
    
    
    
    
    
    
    
    
    
    
    
