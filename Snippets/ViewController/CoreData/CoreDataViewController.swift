//
//  CoreDataViewController.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/1/26.
//

import UIKit
import CoreData

class CoreDataViewController: UIViewController {
    
    lazy var peopleTableView = UITableView()
    
    var peoples = [People]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "CoreData"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.badge.plus"), style: .done, target: self, action: #selector(addPeople))
        
        view.addSubview(peopleTableView)
        peopleTableView.frame = view.frame
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        
        peoples = readPeoples()
        peopleTableView.reloadData()
    }
    
    @objc func addPeople() {
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
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let newPeople = NSEntityDescription.insertNewObject(forEntityName: "People", into: managedObjectContext) as! People
            newPeople.name = name
            newPeople.age = Int16(age) ?? 0
            do {
                try managedObjectContext.save()
            } catch {
                print("\(error)")
            }
            self.peoples = self.readPeoples()
            self.peopleTableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func readPeoples() -> [People] {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "People",in: managedObjectContext)
        let request = NSFetchRequest<People>(entityName: "People")
        var result: [AnyObject]?
        request.fetchOffset = 0
        request.entity = entity
        result = try! managedObjectContext.fetch(request)
        let temp = result as! [People]
        return temp
    }
}

extension CoreDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "tableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid) ?? UITableViewCell(style: .value1, reuseIdentifier: cellid)
        let people = peoples[indexPath.row]
        cell.textLabel?.text = people.name
        cell.detailTextLabel?.text = people.age.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
