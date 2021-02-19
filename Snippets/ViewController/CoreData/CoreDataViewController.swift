//
//  CoreDataViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//

import CoreData
import UIKit

class CoreDataViewController: UIViewController {
    // 展示数据的列表
    lazy var peopleTableView = UITableView()
    
    // 列表的数据源
    var peoples = [People]()
    var dataSource: TableViewDataSource<CoreDataViewController>!
    
    // 与CoreData交互的上下文
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "CoreData增删改查"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.plus"), style: .done, target: self, action: #selector(insertAction))
        view.addSubview(peopleTableView)
        peopleTableView.frame = view.frame
        setupTableView()
    }
    
    func setupTableView() {
        let request = People.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        dataSource = TableViewDataSource(tableView: peopleTableView, cellIdentifier: "peopleCell", fetchedResultsController: fetchedResultsController, delegate: self)
    }
    
    @objc func insertAction() {
        let alert = UIAlertController(title: "添加新的人物", message: "请填写人物信息", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {
            $0.placeholder = "姓名"
        })
        alert.addTextField(configurationHandler: {
            $0.placeholder = "年龄"
            $0.keyboardType = .numberPad
        })
        let okAction = UIAlertAction(title: "添加", style: .default, handler: { _ in
            let name = alert.textFields![0].text ?? ""
            let age = alert.textFields![1].text ?? ""
            if name.isEmpty || age.isEmpty {
                return
            }
            self.addPeople(name: name, age: Int16(age) ?? 0)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

//extension CoreDataViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        peoples.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellid = "tableViewCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellid) ?? UITableViewCell(style: .value1, reuseIdentifier: cellid)
//        let people = peoples[indexPath.row]
//        cell.textLabel?.text = people.name
//        cell.detailTextLabel?.text = people.age.description
//        return cell
//    }
//
//    // tableViewCell被点击时触发修改
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "修改人物信息", message: nil, preferredStyle: .alert)
//        let selectedPeople = peoples[indexPath.row]
//        alert.addTextField(configurationHandler: {
//            $0.placeholder = "姓名"
//            $0.text = selectedPeople.name
//        })
//        alert.addTextField(configurationHandler: {
//            $0.placeholder = "年龄"
//            $0.text = selectedPeople.age.description
//            $0.keyboardType = .numberPad
//        })
//        let okAction = UIAlertAction(title: "修改", style: .default, handler: { _ in
//            let name = alert.textFields![0].text ?? ""
//            let age = alert.textFields![1].text ?? ""
//            if name.isEmpty || age.isEmpty {
//                return
//            }
//            self.updatePeople(at: indexPath.row, newName: name, newAge: Int16(age) ?? 0)
//            self.peopleTableView.reloadData()
//        })
//        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        alert.addAction(okAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true, completion: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    // 令tableViewCell支持左滑操作
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    // 指定左滑时进行删除操作
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    // tableViewCell的左滑删除
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        deletePeople(at: indexPath.row)
//        peopleTableView.reloadData()
//    }
//}

// MARK: - CoreData增删改查

extension CoreDataViewController {
    
    func addPeople(name: String, age: Int16) {
        managedObjectContext.performChanges {
            _ = People.insert(into: self.managedObjectContext, age: age, name: name)
        }
    }
    
    func deletePeople(at index: Int) {
        managedObjectContext.delete(peoples[index] as NSManagedObject)
        do {
            try managedObjectContext.save()
            // 同步删除列表数据源中的对应数据，可以避免二次读取CoreData
            peoples.remove(at: index)
        } catch {
            print("\(error)")
        }
    }
    
    func updatePeople(at index: Int, newName: String, newAge: Int16) {
        let request: NSFetchRequest = People.fetchRequest()
        request.fetchOffset = index
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request)
            result[0].name = newName
            result[0].age = newAge
            try managedObjectContext.save()
            // 同步更新列表数据源中的对应数据，可以避免二次读取CoreData
            peoples[index].name = newName
            peoples[index].age = newAge
        } catch {
            print("\(error)")
        }
    }
}

extension CoreDataViewController: TableViewDataSourceDelegate {
    func configure(_ cell: UITableViewCell, for object: People) {
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = object.age.description
    }
    
    func tableViewDidSelectRowAt(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        managedObjectContext.performChanges {
            self.managedObjectContext.delete(self.dataSource.objectAtIndexPath(indexPath))
        }
    }
}
