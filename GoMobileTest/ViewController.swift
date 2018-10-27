//
//  ViewController.swift
//  GoMobileTest
//
//  Created by Nhat Le on 10/26/18.
//  Copyright © 2018 Nhat Le. All rights reserved.
//

import UIKit
import Corelib

struct ZPConfig: Codable {
    let key: String
    let value: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private lazy var dataBasePath: String = {
        return Bundle.main.path(forResource: "Configuration", ofType: "db") ?? ""
    }()
    
    private var dataSource = [ZPConfig]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    private func loadData() {
        let coreLib = CorelibNewZpConfig("http://localhost:8002/keys/", "111111", dataBasePath, nil)
        do {
            let json = """
{"data" : [{"key": "bank"}, {"key": "zp"}, {"key": "enable"}, {"key": "ffff"}]}
"""
            let data = try coreLib?.getValueForKey(json)
            let decoder = JSONDecoder()
            let configs = try decoder.decode([ZPConfig].self, from: data as! Data)
            dataSource = configs
            let first = dataSource[0]
            print("-------------------------->")
            print("----->FIRST:\(first.key)--->\(first.value)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch let error {
            print("Error:\(error.localizedDescription)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        let item = dataSource[indexPath.row]
        let textString = String(format: "Item with key:%@, value: %@", item.key, item.value)
        cell.textLabel?.text = textString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

