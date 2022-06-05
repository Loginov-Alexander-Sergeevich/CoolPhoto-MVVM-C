//
//  DetailedInformationPhotoViewController.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation
import UIKit
import RealmSwift

final class DetailedInformationPhotosViewController: UIViewController {
    
    var viewModel: DetailedInformationPhotosViewModel!
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameAuthorLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let dateOfCreationLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let numberOfDownloadsLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        return stackView
    }()
    
    
    lazy var addToFavoritesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .gray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        activityIndicator.style = UIActivityIndicatorView.Style.large
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setView()
        cofigurationConstraints()

        updateDataPhoto()
    }

    
    private func updateDataPhoto() {
        
        self.activityIndicator.startAnimating()
        viewModel?.updatePhotoCollection = {[weak self] in
            
            self?.numberOfDownloadsLabel.text = self?.viewModel!.numberOfDownloads
            self?.nameAuthorLabel.text = self?.viewModel?.nameAuthor
            self?.dateOfCreationLabel.text = self?.viewModel?.dateOfCreation
            self?.locationLabel.text = self?.viewModel?.location
            
            guard let image = self?.viewModel?.photoUrl else {return}
            let imageUrl = URL(string: image)
            self?.photoImageView.sd_setImage(with: imageUrl, completed: nil)
            
            self?.viewModel?.isFavorite = true
            self?.addToFavoritesButton.tintColor = .gray
            
            self?.activityIndicator.stopAnimating()
        }
        
        viewModel?.updateFaviritePhoto = {[weak self] in
            
            self?.numberOfDownloadsLabel.text = self?.viewModel?.realmDBItems?.numberOfDownloads
            self?.nameAuthorLabel.text = self?.viewModel?.realmDBItems?.nameAvtor
            self?.dateOfCreationLabel.text = self?.viewModel?.realmDBItems?.creatDate
            self?.locationLabel.text = self?.viewModel?.realmDBItems?.location
            
            guard let image = self?.viewModel?.realmDBItems?.photoUrl else {return}
            let imageUrl = URL(string: image)
            self?.photoImageView.sd_setImage(with: imageUrl, completed: nil)
            
            self?.viewModel?.isFavorite = false
            self?.addToFavoritesButton.tintColor = .red
            
            self?.activityIndicator.stopAnimating()
        }
        

        
        viewModel?.detailedInformationPhotosViewDidLoad()
    }
    
    
    
    private func setView() {
        view.addSubviews([photoImageView, stackView, addToFavoritesButton, activityIndicator])
        stackView.addArrangedSubviews([nameAuthorLabel, dateOfCreationLabel, locationLabel, numberOfDownloadsLabel])
    }
    
    private func cofigurationConstraints() {
        let botomSize = CGSize(width: 50, height: 50)
        photoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(self.stackView.snp.top)
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(110)
            make.bottom.equalTo(addToFavoritesButton.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        addToFavoritesButton.snp.makeConstraints { make in
            make.size.equalTo(botomSize)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func addPhoto() {
        
        if viewModel!.isFavorite! {
            alertAddPhoto()
        } else {
            alertDeletPhoto()
        }
    }
    
    func alertAddPhoto() {
        let aletr = UIAlertController(title: """
                                     Добавить в "Любимые фото"
                                     """,
                                      message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        let add = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            
            self?.viewModel?.saveDataInRealmBD()
            self?.navigationController?.popViewController(animated: true)
        }
        
        aletr.addAction(cancel)
        aletr.addAction(add)
        
        self.present(aletr, animated: true, completion: nil)
    }
    
    func alertDeletPhoto() {
        let aletr = UIAlertController(title: "Удалить фото?",
                                      message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        let delet = UIAlertAction(title: "Удалить", style: .default) { [weak self] _ in
            
            self?.viewModel?.deletDataInRealmBD()
            self?.navigationController?.popViewController(animated: true)
        }
        
        aletr.addAction(cancel)
        aletr.addAction(delet)
        
        self.present(aletr, animated: true, completion: nil)
    }
}


