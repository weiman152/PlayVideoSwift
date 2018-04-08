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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VideoCell = VideoCell.setup(tableView: tableView, indexPath: indexPath)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    
}



