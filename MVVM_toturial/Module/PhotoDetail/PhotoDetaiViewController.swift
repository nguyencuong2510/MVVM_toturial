//
//  PhotoDetaiViewController.swift
//  MVVM_toturial
//
//  Created by cuongnv on 5/28/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoDetaiViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL = imageUrl {
            imageView.sd_setImage(with: URL(string: imageURL), completed: nil)
        }
    }
    

}
