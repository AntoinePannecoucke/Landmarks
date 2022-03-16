//
//  SearchListCollectionViewController.swift
//  Landmarks
//
//  Created by lpiem on 16/03/2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchListCollectionViewController: UICollectionViewController {

    enum Section {
        case main
    }
    
    enum Item : Hashable{
        case cell(Landmark)
    }
    
    var landmarks : Array<Landmark> = [] {
        didSet {
            loadInitialState()
        }
    }
    
    var delegate : SearchLandmarkNavigationControllerDelegate? = nil
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showLandmarkDetailsSegue":
            let cell = sender as! UICollectionViewCell
            
            guard let destination = segue.destination as? DetailsViewController,
                  let indexPath = collectionView.indexPath(for: cell)
            else {
                return
            }
            
            destination.landmark = landmarks[indexPath.item]
            
        default:
            return
        }
    }
    
    var diffableDataSource : UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        configureDataSource()
        collectionView.collectionViewLayout = createLayout()
        loadInitialState()
    }
    
    private func configureDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .cell(let landmark):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell
                cell?.configure(landmark)
                return cell
            }
        })
    }
        
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }

        delegate.goToDetailsOf(landmarks[indexPath.item])
    }
    
    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        let searchedItems = landmarks.map { landmark in
            return Item.cell(landmark)
        }
        snapshot.appendItems(searchedItems, toSection: Section.main)
        
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
                return NSCollectionLayoutSection.list(using: .init(appearance: .insetGrouped), layoutEnvironment: collectionLayoutEnvironment)
            }
        }
        return layout
    }

    

}

extension SearchListCollectionViewController {
    static func instantiate(_ delegate : SearchLandmarkNavigationControllerDelegate) -> SearchListCollectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchListCollectionViewController") as! SearchListCollectionViewController
        
        controller.delegate = delegate
        
        return controller
    }
}

protocol SearchLandmarkNavigationControllerDelegate {
    func goToDetailsOf(_ landmark : Landmark)
}
