//
//  ViewController.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    enum Section : CaseIterable{
        case featured
        case lakes
        case montains
        case favorites
        case rivers
    }
    
    enum Item : Hashable {
        case bigCell(Landmark, id:UUID = UUID())
        case smallCell(Landmark, id:UUID = UUID())
    }
    
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        loadInitialState()
    }
    
    private func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .bigCell(let landmark, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalBigCell", for: indexPath) as? HorizontalBigCellView
                cell?.configure(landmark)
                return cell
            case .smallCell(let landmark, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalSmallCell", for: indexPath) as? HorizontalSmallCellView
                cell?.configure(landmark)
                return cell
            }
        })
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)
        
        let featuredItems = JsonRepository.shared.getFeaturedLandmarks().map { landmark in
            return Item.bigCell(landmark)
        }
        snapshot.appendItems(featuredItems, toSection: Section.featured)
        
        let lakeItems = JsonRepository.shared.getLandmarksOf(.lakes).map { landmark in
            return Item.smallCell(landmark)
        }
        snapshot.appendItems(lakeItems, toSection: Section.lakes)
        
        let montainsItems = JsonRepository.shared.getLandmarksOf(.montains).map { landmark in
            return Item.smallCell(landmark)
        }
        snapshot.appendItems(montainsItems, toSection: Section.montains)
        
        let favoriteItems = JsonRepository.shared.getFavoriteLandmarks().map { landmark in
            return Item.bigCell(landmark)
        }
        snapshot.appendItems(favoriteItems, toSection: Section.favorites)
        
        let riversItems = JsonRepository.shared.getLandmarksOf(.rivers).map { landmark in
            return Item.smallCell(landmark)
        }
        snapshot.appendItems(riversItems, toSection: Section.rivers)
        
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
            case .featured:
                return self.buildBigCellLayout()
            case .lakes:
                return self.buildSmallCellLayout()
            case .montains:
                return self.buildSmallCellLayout()
            case .favorites:
                return self.buildBigCellLayout()
            case .rivers:
                return self.buildSmallCellLayout()
            }
        }
        return layout
    }
    
    private func buildBigCellLayout() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func buildSmallCellLayout() -> NSCollectionLayoutSection{
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(125), heightDimension: .absolute(150))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(125), heightDimension: .absolute(150))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
}



extension UICollectionReusableView {
    static var reuseIdentifier : String {
        return String(describing: self)
    }
}

