//
//  PhotoListViewModel.swift
//  MVVM_toturial
//
//  Created by cuongnv on 5/28/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import Foundation

class PhotoListViewModel {
    
    let apiService: APIServiceProtocol
    
    private var photos = [Photo]()
    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel](){
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    var isloading: Bool = false {
        didSet{
            self.updateLoadingStatus?()
        }
    }
    
    
    var alerMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCell: Int {
        return cellViewModels.count
    }
    
    var isAllowSegue: Bool = false
    var selectedPhoto: Photo?
    
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()-> ())?
    var updateLoadingStatus: (()-> ())?
    
    func initFetch() {
        self.isloading = true
        apiService.fetchPopularPhoto { (success, photos, error) in
            self.isloading = false
            if let error = error {
                self.alerMessage = error.rawValue
            }else {
                self.processFetchedPhoto(photos)
            }
        }
    }
    
    private func processFetchedPhoto(_ photos: [Photo]){
        self.photos = photos
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append(creatCellViewModel(photo))
        }
        self.cellViewModels = vms
    }
    
    func getCellViewModel( at indexPath: IndexPath) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func creatCellViewModel(_ photo: Photo) -> PhotoListCellViewModel {
        var descTextContainner: [String] = [String]()
        if let camera = photo.camera {
            descTextContainner.append(camera)
        }
        if let desciption = photo.description {
            descTextContainner.append(desciption)
        }
        let desc = descTextContainner.joined(separator: " - ")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return PhotoListCellViewModel(titleText: photo.name,
                                      desctext: desc,
                                      imageURL: photo.image_url,
                                      dateText: dateFormatter.string(from: photo.created_at))
    }
    
}

extension PhotoListViewModel {
    func userPressed(at indexpath: IndexPath) {
        let photo = self.photos[indexpath.row]
        if photo.for_sale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        }else{
            self.isAllowSegue = false
            self.selectedPhoto = nil
            self.alerMessage = "This item is not for sale"
        }
    }
}

struct PhotoListCellViewModel {
    let titleText: String
    let desctext: String
    let imageURL: String
    let dateText: String
}
