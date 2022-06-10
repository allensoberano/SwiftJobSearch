//
//  ViewController.swift
//  SwiftJobSearch
//
//  Created by Allen Soberano on 6/8/22.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private var itemsCollectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private let menuItems = ["About", "Job Search", "Podcasts", "Places We Love", "Dev Music", "Contact", "The Team"]
    private let menuIcons = ["info.circle", "magnifyingglass.circle", "music.mic", "globe.americas", "headphones", "envelope", "person.3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiate()
    }
}

extension RootViewController: ViewContainer {
    func styleView() {
        styleNavBar()
    }
    
    func addSubviews() {
        addCollectionView()
        configureDataSource()
    }
    
    private func styleNavBar(){
        navigationItem.title = "Swift Job Search"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .purple
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func addCollectionView(){
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        //collectionView.delegate = self
        collectionView.register(RootViewCollectionViewCell.self, forCellWithReuseIdentifier: RootViewCollectionViewCell.reuseIdentifer)
        itemsCollectionView = collectionView
    }
}

extension RootViewController: CollectionViewConfiguration {
    
    func configureLayout() -> UICollectionViewCompositionalLayout {

        let singleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(2/4)))
        
        let doubleItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))
        
        let doubleGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1/2)),
                subitems: [doubleItem, doubleItem])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(1.0)),
            subitems: [singleItem, doubleGroup])
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
    
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: itemsCollectionView){
            (collectionView, indexPath, itemName) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RootViewCollectionViewCell.reuseIdentifer, for: indexPath) as? RootViewCollectionViewCell else {
                fatalError("Cannot create new cell")
            }
            
            cell.update(title: itemName, icon: UIImage(systemName: self.menuIcons[indexPath.row])!)
            
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(menuItems, toSection: .main)
        
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
}

extension RootViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
    let detailsVC = SecondViewController()
    navigationController?.pushViewController(detailsVC, animated: true)
  }
}

