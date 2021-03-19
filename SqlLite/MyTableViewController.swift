//
//  MyTableViewController.swift
//  SqlLite
//
//  Created by Muna Abdelwahab on 3/17/21.
//

import UIKit
import SDWebImage
import SQLite3

class MyTableViewController: UITableViewController {

    var friend : [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = friend[indexPath.row].name
        cell.detailTextLabel?.text = String(friend[indexPath.row].id!)
        cell.imageView?.sd_setImage(with: URL(string: friend[indexPath.row].image!))

        return cell
    }
}
