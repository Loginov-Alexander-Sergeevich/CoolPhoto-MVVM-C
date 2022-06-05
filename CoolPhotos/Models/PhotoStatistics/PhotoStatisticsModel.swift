//
//  PhotoStatisticsModel.swift
//  MVVMArchitecture + С
//
//  Created by Александр Александров on 20.05.2022.
//

import Foundation

struct PhotoStatisticsModel: Decodable {
    let downloads: Downloads?
}

struct Downloads: Decodable {
    let total: Int?
}
