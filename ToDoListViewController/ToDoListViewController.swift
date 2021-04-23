//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by daito yamashita on 2021/04/19.
//

import UIKit

class ToDoListViewController: UIViewController, UICollectionViewDelegate {

    typealias Section = ToDo.Category
    
    var items = [Item]()

    let userDefault = UserDefaults.standard
    
    var collectionView: UICollectionView! = nil
    lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        applyInitialSnapshots()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.collectionView.isEditing = editing
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
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        
        // MARK: Cell削除のSwipeActionをTrailingに追加
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self ] indexPath in
            guard let self = self else { return nil }
            let selectedItem = self.dataSource.itemIdentifier(for: indexPath)
            return self.deleteItemOnSwipe(item: selectedItem!)
        }
        
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    // MARK: スワイプでセルを削除する関数
    private func deleteItemOnSwipe(item: Item) -> UISwipeActionsConfiguration? {
        let actionHandler: UIContextualAction.Handler = { action, view, completion in
            
            completion(true)
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([item])
            self.items = snapshot.itemIdentifiers
            self.dataSource.apply(snapshot)
        }
        
        saveToDoTask()
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete", handler: actionHandler)
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func configureDataSource() {
        if let savedToDoTasks = loadToDoTask() {
            items = savedToDoTasks
        } else {
            loadSampleToDoTask()
        }
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item>{ (cell, indexPath, item) in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = "\(item.title)"
            cell.contentConfiguration = contentConfiguration
            
            cell.accessories = [.multiselect(displayed: .whenNotEditing)]
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
    }
    
    func applyInitialSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(ToDo.Category.allCases)
        
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func updateDataSouce(for item: Item) {
        
    }
}

extension ToDoListViewController {
    @IBAction func unwindToToDoView(sender: UIStoryboardSegue) {
        if let ToDoViewController = sender.source as? ToDoViewController,
           let item = ToDoViewController.item {
            items.append(item)
            saveToDoTask()
            applyInitialSnapshots()
        }
    }
}

extension ToDoListViewController {
    func saveToDoTask() {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(items) else {
            return
        }
        userDefault.set(data, forKey: "todoTask")
    }

    func loadToDoTask() -> [Item]? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = userDefault.data(forKey: "todoTask"),
              let items = try? jsonDecoder.decode([Item].self, from: data) else {
            return nil
        }
        return items
    }

    func loadSampleToDoTask() {
        // MARK: 構造体を使う時はインスタンスを作らないと参照できない
        for category in ToDo.Category.allCases {
            items = category.todos.map { Item(title: $0.task)}
        }
    }
}
