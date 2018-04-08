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
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
}



