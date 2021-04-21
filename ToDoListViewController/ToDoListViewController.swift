//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/19.
//

import UIKit

class ToDoListViewController: UIViewController {

    enum Section {
        case main
    }
    
    var items = [Item]()

    let userDefault = UserDefaults.standard
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedToDoTasks = loadToDoTask() {
            items += savedToDoTasks
        } else {
            loadSampleToDoTask()
        }
        
        configureHierarchy()
        configureDataSource()
    }
}

extension ToDoListViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>{ (cell, indexPath, item) in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "\(item.title)"
            cell.contentConfiguration = contentConfiguration
            
            cell.accessories = [.multiselect(displayed: .always), .reorder(), .delete()]
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.reorderingHandlers.canReorderItem = { item in return true }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
//        // MEMO: 構造体を使う時はインスタンスを作らないと参照できない
//        for category in ToDo.Category.allCases {
//            let items = category.todos.map { Item(title: $0.task)}
//            snapshot.appendItems(items)
//        }
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ToDoListViewController {
    @IBAction func unwindToToDoView(sender: UIStoryboardSegue) {
        if let ToDoViewController = sender.source as? ToDoViewController,
           let item = ToDoViewController.item {
            items.append(item)
            saveToDoTask()
        }
    }
}

extension ToDoListViewController {
    func saveToDoTask() {
        userDefault.set(items, forKey: "todoTask")
        userDefault.synchronize()
    }
    
    func loadToDoTask() -> [Item]? {
        let value = userDefault.object(forKey: "todoTask")
        guard let itemss = value as? [Item] else {
            return nil
        }
        return itemss
    }
    
    func loadSampleToDoTask() {
        for category in ToDo.Category.allCases {
            items = category.todos.map { Item(title: $0.task)}
        }
    }
}

