//
//  PhotoCollectionViewController.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit
import SnapKit



final class SearchPhotosViewController: UIViewController {
    
    var delegate: PhotoCollectionCoordinatorProtocol!
    var viewModel: SearchPhotoViewModel!
    var photoCollectionDataSource: UICollectionViewDiffableDataSource<Section, PhotoSearchResultsRequest>?
    
    lazy var searchContriller: UISearchController = {
        let search = UISearchController()
        search.searchBar.sizeToFit()
        search.searchBar.placeholder = "Поиск фото"
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.delegate = self
        return search
    }()
    
    lazy var photoCollectionCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(SearchPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SearchPhotoCollectionViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        return  collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .systemRed
        activityIndicator.style = UIActivityIndicatorView.Style.large
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
        cofigurationConstraints()
        photoCollectionCollectionView.dataSource = photoCollectionDataSource
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurationNavigationController()
    }
    
    private func configurationNavigationController() {
        navigationItem.searchController = searchContriller
        navigationItem.title = viewModel.title
    }
    
    func setView() {
        view.addSubviews([photoCollectionCollectionView, activityIndicator])
    }
    
    func cofigurationConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure<T: SearchPhotoCollectionViewCellProtocol>(_ CellId: T.Type, with resultsRequest: PhotoSearchResultsRequest, for indexPath: IndexPath) -> T {
        guard let cell = photoCollectionCollectionView.dequeueReusableCell(withReuseIdentifier: CellId.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(CellId)")
        }
        cell.configure(with: resultsRequest)
        return cell
    }
    
    func createDataSource() {
        photoCollectionDataSource = UICollectionViewDiffableDataSource<Section, PhotoSearchResultsRequest>(collectionView: photoCollectionCollectionView){ collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)
            
            switch section {
            default:
                return self.configure(SearchPhotoCollectionViewCell.self, with: itemIdentifier, for: indexPath)
            }
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PhotoSearchResultsRequest>()
        
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(viewModel.resultsRequestItem, toSection: section)
        }
        photoCollectionDataSource?.apply(snapshot)
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section(rawValue: sectionIndex)!

            switch section {
            case .searchPhoto:
                return self.createPhotoCollectionSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    func createPhotoCollectionSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 0)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)

        return layoutSection
    }
}

extension SearchPhotosViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.activityIndicator.startAnimating()
        viewModel.timer?.invalidate()
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: {[weak self] _ in
            self?.viewModel.searchPhoto(name: searchText) {
                self?.createDataSource()
                self?.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        })
    }
}

extension SearchPhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.resultsRequestItem[indexPath.item] 
        delegate.onSelect(resultsRequest: data)
    }
}
