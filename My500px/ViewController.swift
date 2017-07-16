//
//  ViewController.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit

class Category500px {
    var id: Int
    var name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var arrAll: [Category500px] = [Category500px]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        prepareData()
        view.addSubview(tableView)
    }
    
    func prepareData() {
        arrAll.removeAll()
        
        arrAll.append(Category500px(id: 25, name: "Wedding"))
        arrAll.append(Category500px(id: 23, name: "flower"))
        arrAll.append(Category500px(id: 16, name: "fashion"))
        arrAll.append(Category500px(id: 3, name: "sea"))
        arrAll.append(Category500px(id: 23, name: "food"))
        arrAll.append(Category500px(id: 21, name: "Street"))
    }
    
    // MARK: - DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let b = arrAll[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.textLabel?.text = b.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CollectionController()
        vc.category = arrAll[indexPath.row]
        navigationController!.pushViewController(vc, animated: true)
    }
}
