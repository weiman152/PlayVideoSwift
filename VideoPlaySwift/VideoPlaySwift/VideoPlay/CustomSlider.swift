//
//  CustomSlider.swift
//  CustomSlider
//
//  Created by iOS on 2018/4/4.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class CustomSlider: UISlider {
    
    var height: CGFloat = 0.0

    override func minimumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
    
    override func maximumValueImageRect(forBounds bounds: CGRect) -> CGRect {
        return self.bounds
    }
    // 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        return CGRect.init(x: rect.origin.x, y: (bounds.size.height-height)/2, width: bounds.size.width, height: height)
    }
    // 改变滑块的触摸范围
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
    }

}
