//
//  ViewController.swift
//  MVVM_toturial
//
//  Created by cuongnv on 5/28/18.
//  Copyright © 2018 cuongnv. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: PhotoListViewModel = {
        return PhotoListViewModel(apiService: APIService())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        initView()
        initVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let idex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: idex, animated: true)
        }
    }
    
    func initView() {
        self.navigationItem.title = "Nguyen Cuong"
        
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alerMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isloading ?? false
                if isLoading {
                    self?.ActivityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }else {
                    self?.ActivityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoListTableViewCell
        
        let cellML = viewModel.getCellViewModel(at: indexPath)
        
        cell.titleLabel.text = cellML.titleText
        cell.detailLAbel.text = cellML.desctext
        cell.dateLabel.text = cellML.dateText
        
        cell.imageViewCell.sd_setImage(with: URL(string: cellML.imageURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.viewModel.userPressed(at: indexPath)
        return viewModel.isAllowSegue ? indexPath : nil
    }
    
}

extension ViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoDetaiViewController{
            if let photo = viewModel.selectedPhoto {
                vc.imageUrl = photo.image_url
            }
        }
    }
}
