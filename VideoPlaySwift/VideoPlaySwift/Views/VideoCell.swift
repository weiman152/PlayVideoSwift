//
//  VideoCell.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/8.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var videoCover: UIImageView!
    
    @IBOutlet weak var titleDesc: UILabel!
    
    
    class func setup(tableView: UITableView, indexPath: IndexPath) -> VideoCell {
        let nib = UINib(nibName: "VideoCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "VideoCell")
        let cell: VideoCell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        return cell
    }
    
    func set(model: DataModel.Model) {
        
    }
}
