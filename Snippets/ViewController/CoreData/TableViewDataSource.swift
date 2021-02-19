//
//  TableViewDataSource.swift
//  Snippets
//
//  Created by 温蟾圆 on 2021/2/19.
//

import UIKit
import CoreData

protocol TableViewDataSourceDelegate: class {
    associatedtype Object: NSFetchRequestResult
    associatedtype Cell: UITableViewCell
    func configure(_ cell: Cell, for object: Object)
    
    func tableViewDidSelectRowAt(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

extension TableViewDataSourceDelegate {
    func tableViewDidSelectRowAt(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}

class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    let tableView: UITableView
    let fetchedResultsController: NSFetchedResultsController<Object>
    weak var delegate: Delegate!
    let cellIdentifier: String
    
    required init(tableView: UITableView, cellIdentifier: String, fetchedResultsController: NSFetchedResultsController<Object>, delegate: Delegate) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    var selectedObject: Object? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        return objectAtIndexPath(indexPath)
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func recongifureFetchRequest(_ configure: (NSFetchRequest<Object>) -> ()) {
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: fetchedResultsController.cacheName)
        configure(fetchedResultsController.fetchRequest)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("fetch request failed")
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? Cell(style: .value1, reuseIdentifier: cellIdentifier)) as! Cell
        delegate.configure(cell, for: object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.tableViewDidSelectRowAt(tableView, didSelectRowAt: indexPath)
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                return
            }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else {
                return
            }
            let object = objectAtIndexPath(indexPath)
            guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                return
            }
            delegate.configure(cell, for: object)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else {
                return
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
