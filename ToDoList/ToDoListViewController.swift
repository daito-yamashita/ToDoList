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
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            contentConfiguration.text = "\(item)"
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
        
        // MEMO: 構造体を使う時はインスタンスを作らないと参照できない
        for category in ToDo.Category.allCases {
            let items = category.todos.map { Item(title: $0.task)}
            snapshot.appendItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

