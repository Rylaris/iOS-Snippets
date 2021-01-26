//
//  ViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//

import UIKit

class MainViewController: UIViewController {
    
    lazy var settingTableView = UITableView()
    
    private var settingItems: [[SettingModel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Snippets"
        
        view.addSubview(settingTableView)
        settingTableView.frame = view.frame
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        settingItems = [
            [NavigationCell(viewController: CoreDataViewController.self, style: .push, text: "CoreData增删改查")
            ]
        ]
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "aa"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "tableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid) ?? UITableViewCell(style: .value1, reuseIdentifier: cellid)
        let settingItem = settingItems[indexPath.section][indexPath.row]
        cell.imageView?.image = settingItem.leftImage
        cell.textLabel?.text = settingItem.text
        cell.detailTextLabel?.text = settingItem.detailText
        cell.accessoryType = settingItem.accessoryType
        cell.accessoryView = (settingItem as? SwitchCell)?.uiSwitch
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingItems[indexPath.section][indexPath.row].trigger()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}