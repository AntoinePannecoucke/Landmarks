//
//  ViewController.swift
//  Landmarks
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLandmarkDetailsSegue":
            
            let cell = sender as! UICollectionViewCell
            
            guard let destination = segue.destination as? DetailsViewController,
                  let indexPath = collectionView.indexPath(for: cell)
            else {
                return
            }
            
            let section = diffableDataSource.sectionIdentifier(for: indexPath.section)
            
            switch section {
            case .featured:
                destination.landmark = JsonRepository.shared.getFeaturedLandmarks()[indexPath.item]
            case .lakes:
                destination.landmark = JsonRepository.shared.getLandmarksOf(.lakes)[indexPath.item]
            case .mountains:
                destination.landmark = JsonRepository.shared.getLandmarksOf(.montains)[indexPath.item]
            case .favorites:
                destination.landmark = JsonRepository.shared.getFavoriteLandmarks()[indexPath.item]
            case .rivers:
                destination.landmark = JsonRepository.shared.getLandmarksOf(.rivers)[indexPath.item]
            default:
                break
            }
            
        default:
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier)
        
        let searchController = UISearchController(searchResultsController: SearchListCollectionViewController.instantiate(self))
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
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
                return HorizontalBigCellView.build(collectionLayoutEnvironment)
            case .lakes:
                return HorizontalSmallCellView.build(collectionLayoutEnvironment)
            case .mountains:
                return HorizontalSmallCellView.build(collectionLayoutEnvironment)
            case .favorites:
                return HorizontalBigCellView.build(collectionLayoutEnvironment)
            case .rivers:
                return HorizontalSmallCellView.build(collectionLayoutEnvironment)
            }
        }
        return layout
    }
}


extension HomeViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              let list = searchController.searchResultsController as? SearchListCollectionViewController else {
            return
        }

        list.landmarks = JsonRepository.shared.searchLandmarksWith(searchQuery)
    }
    
}


extension UICollectionReusableView {
    static var reuseIdentifier : String {
        return String(describing: self)
    }
}

extension HomeViewController : SearchLandmarkNavigationControllerDelegate {
    
    func goToDetailsOf(_ landmark: Landmark) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController,
              let navigationController = self.navigationController
        else {
            return
        }
        
        viewController.landmark = landmark
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}


