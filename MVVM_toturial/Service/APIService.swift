//
//  APIService.swift
//  MVVM_toturial
//
//  Created by cuongnv on 5/28/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetWork = "No NetWork"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

protocol APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (_ success: Bool,_ photo: [Photo],_ error: APIError?) -> ())
}

class APIService: APIServiceProtocol {
    func fetchPopularPhoto(complete: @escaping (_ success: Bool,_ photo: [Photo],_ error: APIError?) -> ()) {
        DispatchQueue.global().async {
            sleep(3)
            let path = Bundle.main.path(forResource: "content", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let photos = try! decoder.decode(Photos.self, from: data)
            complete( true, photos.photos, nil )
        }
    }
}
