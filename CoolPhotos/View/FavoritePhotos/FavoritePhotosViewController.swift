//
//  FavoritePhotosViewController.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import UIKit

final class FavoritePhotosViewController: UIViewController {

    var viewModel: FavoritePhotosViewModel!
    var delegat: FavoritePhotosCoordinatorProtocol!
    var favoritePhotosDataSource: UICollectionViewDiffableDataSource<Section, DetailInformationPhotoRealmModel>?
    
    lazy var favoritePhotosCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(FavoritePhotosCollectionViewCell.self, forCellWithReuseIdentifier: FavoritePhotosCollectionViewCell.reuseIdentifier)
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
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurationNavigationController()
        
        self.createDataSource()
        self.reloadData()
    }
    
    private func configurationNavigationController() {
        navigationItem.title = viewModel.title
    }
    
    func setView() {
        view.addSubviews([favoritePhotosCollectionView, activityIndicator])
    }
    
    func cofigurationConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure<T: FavoritePhotosCollectionViewCellProtocol>(_ cellId: T.Type, with realmBD: DetailInformationPhotoRealmModel, for indexPath: IndexPath) -> T {
        guard let cell = favoritePhotosCollectionView.dequeueReusableCell(withReuseIdentifier: cellId.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(cellId)")
        }
        cell.configure(with: realmBD)
        return cell
    }
    
    func createDataSource() {
        favoritePhotosDataSource = UICollectionViewDiffableDataSource<Section, DetailInformationPhotoRealmModel>(collectionView: favoritePhotosCollectionView){ collectionView, indexPath, itemIdentifier in
            let section = Section(rawValue: indexPath.section)
            
            switch section {
            default:
                return self.configure(FavoritePhotosCollectionViewCell.self, with: itemIdentifier, for: indexPath)
            }
        }
    }
    
    func reloadData() {
        
        self.activityIndicator.startAnimating()
        viewModel.timer?.invalidate()
        viewModel.timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true, block: { [weak self] _ in
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, DetailInformationPhotoRealmModel>()

            let items = RealmManadger.shared.items()
            Section.allCases.forEach { section in
                
                snapshot.appendSections([section])
                snapshot.appendItems(Array(items), toSection: section)
            }
            self?.favoritePhotosDataSource?.apply(snapshot)
            self?.activityIndicator.stopAnimating()
        })
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = Section(rawValue: sectionIndex)!

            switch section {
            case .searchPhoto:
                return self.createfavoritePhotosSection(using: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 5
        layout.configuration = config
        return layout
    }
    
    func createfavoritePhotosSection(using section: Section) -> NSCollectionLayoutSection {
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

extension FavoritePhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = RealmManadger.shared.detailInformationPhotoRealmModel[indexPath.item]
        delegat.onSelect(itemRealmBD: item)
    }
}
