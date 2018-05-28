//
//  Photo.swift
//  MVVM_toturial
//
//  Created by cuongnv on 5/28/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let name: String
    let description: String?
    let created_at: Date
    let image_url: String
    let for_sale: Bool
    let camera: String?
}
