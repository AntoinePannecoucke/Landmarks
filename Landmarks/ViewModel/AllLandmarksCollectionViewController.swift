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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLandmarkDetailsSegue":
            let cell = sender as! UICollectionViewCell
            
            guard let destination = segue.destination as? DetailsViewController,
                  let indexPath = collectionView.indexPath(for: cell)
            else {
                return
            }
            
            destination.landmark = JsonRepository.shared.getLandmarks()[indexPath.item]
            
        default:
            return
        }
    }
    
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
                return VerticalMediumCellView.build(collectionLayoutEnvironment)
            }
        }
        return layout
    }
}

extension AllLandmarksCollectionViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              let list = searchController.searchResultsController as? SearchListCollectionViewController else {
            return
        }

        list.landmarks = JsonRepository.shared.searchLandmarksWith(searchQuery)
    }
    
}

extension AllLandmarksCollectionViewController : SearchLandmarkNavigationControllerDelegate {
    
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

