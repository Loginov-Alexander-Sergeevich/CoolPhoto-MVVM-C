//
//  PhotoSearchResultModel.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation

enum Section: Int, CaseIterable {
    case searchPhoto
}

struct PhotoSearchModel: Decodable, Hashable {
    let total: Int?
    let results: [PhotoSearchResultsRequest]?
}

struct PhotoSearchResultsRequest: Decodable, Hashable {
    let id: String?
    let created_at: String
    let urls: [URLKing.RawValue: String?]
    let user: User

    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Decodable, Hashable {
    let firstName: String?
    let lastName: String?
    let location: String?


    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case location
    }
}
