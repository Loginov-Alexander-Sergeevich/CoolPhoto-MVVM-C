//
//  PhotoCollectionViewModel.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation

final class SearchPhotoViewModel {

    let title = "Коллекция фотографий"
    
    var timer: Timer?
    
    var resultsRequestItem = [PhotoSearchResultsRequest]()
    
    func searchPhoto(name: String, completion: @escaping() -> ()) {
        NetworkManadger.shared.requestPhoto(searchName: name) {[weak self] serchResults in
            guard let results = serchResults?.results else { return }
            
            self?.resultsRequestItem = results
            completion()
        }
    }
}
