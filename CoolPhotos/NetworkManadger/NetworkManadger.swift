//
//  NetworkManadger.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation

final class NetworkManadger: NetworkManadgerProtocol {
    
    static let shared = NetworkManadger()
    private init(){}
    
    let networkRequestSearchPhoto = NetworkRequestSearchPhoto()
    let networkRequestPhotoDetailInfirmation = NetworkRequestPhotoDetailInfirmation()
    
    func requestPhoto(searchName: String, completion: @escaping (PhotoSearchModel?) -> ()) {
        networkRequestSearchPhoto.requestPhoto(searchName: searchName) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: PhotoSearchModel.self, data: data)

            completion(decode)
        }
    }
    
    func requestPhoto(id: String, completion: @escaping (PhotoStatisticsModel?) -> ()) {
        networkRequestPhotoDetailInfirmation.requestStatistics(byId: id) { data, error in
            if let error = error {
                print("Не смог получить данные: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: PhotoStatisticsModel.self, data: data)

            completion(decode)
        }
    }
}

protocol NetworkManadgerProtocol {
    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T?
}

extension NetworkManadgerProtocol {

    func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()

        guard let data = data else { fatalError("Не смог получить данные") }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects

        } catch let jsonError {
            print("Не смог распарсить данные по твоей модели", jsonError)
            return nil
        }
    }
}
