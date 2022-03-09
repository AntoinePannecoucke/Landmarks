//
//  AllLandmarksCollectionViewController.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class AllLandmarksCollectionViewController: UICollectionViewController {

    enum Section {
        case main
    }
    
    enum Item : Hashable {
        case mediumCell(Landmark)
    }
    
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        loadInitialState()
    }

    private func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .mediumCell(let landmark):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalMediumCellView.reuseIdentifier, for: indexPath) as? VerticalMediumCellView
                cell?.configure(landmark)
                return cell
            }
        })
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        let items = JsonRepository.shared.getLandmarks().map(Item.mediumCell)
        snapshot.appendItems(items, toSection: Section.main)
        
        return snapshot
    }
    
    private func loadInitialState() {
        let snapshot = createSnapshot()
        diffableDataSource.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, collectionLayoutEnvironment in
            guard let self = self,
                  let section = self.diffableDataSource.sectionIdentifier(for: sectionIndex) else {
                      return nil
                  }
            
            switch section {
            case .main:
                return self.buildMediumCellLayout()
            }
        }
        return layout
    }
    
    private func buildMediumCellLayout() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
}

