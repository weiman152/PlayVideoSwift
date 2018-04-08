//
//  DataModel.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/8.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class DataModel: NSObject {
    
    struct Model: Codable {
        var authorImage: String?
        var authorName: String?
        var time: String?
        var videoUrl: String?
        var videoDesc: String?
        var videoCover: String?
    }
    
    /// 创建数据
    class func makeData() -> [Model] {
        var videoList = [Model]()
        do {
            var model1 = Model()
            model1.authorImage = "http://img1.cache.netease.com/m/newsapp/video/default.jpg"
            model1.authorName = "头条推荐"
            model1.time = "3月16日"
            model1.videoUrl = "http://flv3.bn.netease.com/tvmrepo/2018/4/N/J/EDDSUKMNJ/SD/EDDSUKMNJ-mobile.mp4"
            model1.videoDesc = "老二去吧电关一下，这洗澡水有点热"
            model1.videoCover = "http://vimg1.ws.126.net/image/snapshot/2018/4/K/O/VDDSUL2KO.jpg"
            videoList.append(model1)
        }
        do {
            var model1 = Model()
            model1.authorImage = "http://vimg1.ws.126.net/image/snapshot/2017/2/B/S/VCC0H51BS.jpg"
            model1.authorName = "东施频频笑"
            model1.time = "3月28日"
            model1.videoUrl = "http://flv3.bn.netease.com/tvmrepo/2018/4/N/Q/EDDSUEONQ/SD/EDDSUEONQ-mobile.mp4"
            model1.videoDesc = "就服那句:老子半截身子 入土了。。哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
            model1.videoCover = "http://vimg3.ws.126.net/image/snapshot/2018/4/0/V/VDDSUF90V.jpg"
            videoList.append(model1)
        }
        do {
            var model1 = Model()
            model1.authorImage = "http://vimg1.ws.126.net/image/snapshot/2016/2/L/9/VBG7H78L9.jpg"
            model1.authorName = "笑翻天"
            model1.time = "2018-04-07 21:12:06"
            model1.videoUrl = "http://flv3.bn.netease.com/tvmrepo/2018/4/O/R/EDDSUEQOR/SD/EDDSUEQOR-mobile.mp4"
            model1.videoDesc = "关注我告诉你们软件名字"
            model1.videoCover = "http://vimg2.ws.126.net/image/snapshot/2018/4/D/B/VDDSUFBDB.jpg"
            videoList.append(model1)
        }
        do {
            var model1 = Model()
            model1.authorImage = "http://vimg3.ws.126.net/image/snapshot/2017/2/6/H/VCC09Q76H.jpg"
            model1.authorName = "奇葩研究所"
            model1.time = "2018-04-03 21:12:05"
            model1.videoUrl = "http://flv3.bn.netease.com/tvmrepo/2018/4/D/M/EDDSUETDM/SD/EDDSUETDM-mobile.mp4"
            model1.videoDesc = "绝对是亲生的！！！哈哈哈"
            model1.videoCover = "http://vimg3.ws.126.net/image/snapshot/2018/4/B/9/VDDSUFAB9.jpg"
            videoList.append(model1)
        }
        do {
            var model1 = Model()
            model1.authorImage = "http://vimg2.ws.126.net/image/snapshot/2017/2/S/T/VCCUNO3ST.jpg"
            model1.authorName = "短视频"
            model1.time = "2018-04-05 21:12:05"
            model1.videoUrl = "http://flv3.bn.netease.com/tvmrepo/2018/4/V/B/EDDSUE0VB/SD/EDDSUE0VB-mobile.mp4"
            model1.videoDesc = "其实土狗也不错，也很可爱"
            model1.videoCover = "http://vimg3.ws.126.net/image/snapshot/2018/4/9/5/VDDSUEJ95.jpg"
            videoList.append(model1)
        }
        do {
            var model1 = Model()
            model1.authorImage = "http://vimg2.ws.126.net/image/snapshot/2017/2/S/T/VCCUNO3ST.jpg"
            model1.authorName = "短视频"
            model1.time = "2018-04-03 21:11:40"
            model1.videoUrl = "http://flv3.bn.netease.com/tvmrepo/2018/4/7/M/EDDSUE27M/SD/EDDSUE27M-mobile.mp4"
            model1.videoDesc = "就喜欢你这种逗比，没办法。啦啦啦就喜欢你这种逗比，没办法。啦啦啦就喜欢你这种逗比，没办法。啦啦啦就喜欢你这种逗比，没办法。啦啦啦就喜欢你这种逗比，没办法。啦啦啦就喜欢你这种逗比，没办法。啦啦啦就喜欢你这种逗比，没办法。啦啦啦"
            model1.videoCover = "http://vimg2.ws.126.net/image/snapshot/2018/4/4/3/VDDSUEH43.jpg"
            videoList.append(model1)
        }
        
        
        
        return videoList
    }

}
