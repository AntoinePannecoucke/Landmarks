//
//  ViewController.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    enum Section : String, CaseIterable{
        case featured = "Featured"
        case lakes = "Lakes"
        case mountains = "Mountains"
        case favorites = "Favorites"
        case rivers = "Rivers"
    }
    
    enum Item : Hashable {
        case bigCell(Landmark, id:UUID = UUID())
        case smallCell(Landmark, id:UUID = UUID())
    }
    
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        
        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        loadInitialState()
    }
    
    private func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .bigCell(let landmark, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalBigCellView.reuseIdentifier, for: indexPath) as? HorizontalBigCellView
                cell?.configure(landmark)
                return cell
            case .smallCell(let landmark, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalSmallCellView.reuseIdentifier, for: indexPath) as? HorizontalSmallCellView
                cell?.configure(landmark)
                return cell
            }
        })
        
        diffableDataSource.supplementaryViewProvider = .some{ collectionView, elementKind, indexPath in
            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                let section = self.diffableDataSource.sectionIdentifier(for: indexPath.section)
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier,
                    for: indexPath) as? HeaderCollectionReusableView
                header?.configure(section)
                return header
            default:
                return nil
            }
            
        }
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
        snapshot.appendItems(montainsItems, toSection: Section.mountains)
        
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
            case .mountains:
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
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(125), heightDimension: .absolute(150))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(125), heightDimension: .absolute(150))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}



extension UICollectionReusableView {
    static var reuseIdentifier : String {
        return String(describing: self)
    }
}

