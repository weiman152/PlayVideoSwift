//
//  ListViewController.swift
//  VideoPlaySwift
//
//  Created by iOS on 2018/4/8.
//  Copyright © 2018年 weiman. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    private var list:[DataModel.Model] = [DataModel.Model]()
    private var oldIndexPath: IndexPath = IndexPath(row: -1, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建数据
        list = DataModel.makeData()
        
    }
    
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoCell = VideoCell.setup(tableView: tableView, indexPath: indexPath)
        cell.set(model: list[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
    
    
}

extension ListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var scrollRect = scrollView.frame
        scrollRect.origin.y = scrollView.contentOffset.y
        if oldIndexPath.row > -1 {
            let cell = tableView.cellForRow(at: oldIndexPath)
            let viewrect = cell?.frame
            let isIntersection: Bool = viewrect!.intersects(scrollRect)
            if !isIntersection {
                oldIndexPath = IndexPath(row: -1, section: 0)
                VideoPlay.shareSingle.remove()
            }
            
        }
    }
}

extension ListViewController: VideoCellDelegate {
    
    func checkPlayingVideo(indexPath: IndexPath) {
        if oldIndexPath.row != indexPath.row {
            VideoPlay.shareSingle.remove()
        }
        oldIndexPath = indexPath
    }
    
}



