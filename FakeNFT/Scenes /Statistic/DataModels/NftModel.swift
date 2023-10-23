//
//  NftModel.swift
//  FakeNFT
//
//  Created by Александр Пичугин on 15.10.2023.
//

import Foundation

struct NftModel: Codable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let id: String
}
