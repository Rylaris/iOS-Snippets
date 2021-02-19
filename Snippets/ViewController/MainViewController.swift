//
//  ViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    lazy var settingTableView = UITableView()
    
    let locationManager = CLLocationManager()
    
    private var settingItems: [[SettingModel]] = []
    private var cellTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Snippets"
        
        view.addSubview(settingTableView)
        settingTableView.frame = view.frame
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        settingItems = [
            [NavigationCell(viewController: ARViewController.self, style: .push, text: "ARKit+SceneKit模型跟随表情"),
             NavigationCell(viewController: CoreDataViewController.self, style: .push, text: "CoreData增删改查")
            ],
            [NavigationCell(viewController: AnimationViewController.self, style: .push, text: "视图控制器过渡动画"),
             NavigationCell(viewController: CoreAnimationAndCoreGraphicsViewController.self, style: .push, text: "使用CoreAnimation与CoreGraphics绘图"),
             NavigationCell(viewController: FloatingViewController.self, style: .push, text: "使用手势拖动缩放浮窗"),
//             NavigationCell(viewController: TimeScrollViewController.self, style: .push, text: "数字滚动")
            ]
        ]
        
        cellTitles = [
            "基础框架",
            "动画"
        ]
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return cellTitles[section]
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
