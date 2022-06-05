//
//  FavoritePhotosCell.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import UIKit

protocol FavoritePhotosCollectionViewCellProtocol {
    static var reuseIdentifier: String { get }
    func configure(with imageUrl: DetailInformationPhotoRealmModel)
}

final class FavoritePhotosCollectionViewCell: UICollectionViewCell, FavoritePhotosCollectionViewCellProtocol {

    static var reuseIdentifier: String = "FavoritePhotosCell"
    
    let favoritePhotosImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        cofigurationConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell() {
        contentView.addSubviews([favoritePhotosImageView])
    }
    
    func cofigurationConstraints() {
        favoritePhotosImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.edges.equalTo(self.contentView)
        }
    }
    
    
    func configure(with imageUrl: DetailInformationPhotoRealmModel) {
        let url = URL(string: imageUrl.photoUrl)
        
        favoritePhotosImageView.sd_setImage(with: url, completed: nil)
    }
}
