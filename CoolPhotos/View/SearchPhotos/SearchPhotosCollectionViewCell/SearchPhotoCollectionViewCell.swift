//
//  PhotoCollectionCell.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import UIKit
import SDWebImage

protocol SearchPhotoCollectionViewCellProtocol {
    static var reuseIdentifier: String { get }
    func configure(with app: PhotoSearchResultsRequest)
}


final class SearchPhotoCollectionViewCell: UICollectionViewCell, SearchPhotoCollectionViewCellProtocol {
    
    static var reuseIdentifier: String = "PhotoCollectionCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
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
        contentView.addSubviews([photoImageView])
    }
    
    func cofigurationConstraints() {
        photoImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.edges.equalTo(self.contentView)
        }
    }
    
    func configure(with app: PhotoSearchResultsRequest) {
        let photoURL = app.urls["regular"]
        
        guard let imageUrl = photoURL else { return }
        
        let url = URL(string: imageUrl!)
        
        photoImageView.sd_setImage(with: url, completed: nil)
    }
}
