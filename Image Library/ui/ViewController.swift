//
//  ViewController.swift
//  Image Library
//
//  Created by PayTren on 11/25/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelError: UILabel!
    var viewModel : ImagePixabayViewModel?
    var query : String = "Fruits"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        viewModel = ImagePixabayViewModel(q: query)
        setupViewController()
        tableView.reloadData()
    }
    
    func setupViewController() {
        self.setNavBarAsPlainWhiteWithTitle(title: "Image Gallery")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.separatorStyle = .singleLine
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getListImagePixabay()
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(indexPath: indexPath)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.cellModels.count ?? 0
    }
    
    fileprivate func getCell(indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel?.cellModels[indexPath.section] ?? ImagePixabayItemModel(urlImage: "", username: "", viewsCount: 0)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as! ImageTableViewCell
        cell.buildCell(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        
            self.viewModel?.page = (self.viewModel?.page ?? 0) + 1
            getListImagePixabay(indcBottom: spinner)
        }
    }
}


extension ViewController {
    func getListImagePixabay(indcBottom : UIActivityIndicatorView? = nil) {
        activityIndicator.startAnimating()
        let success : GetImagePixabaySuccessHandler = { [weak self] response in
            guard let `self` = self else {
                return
            }
            
            self.activityIndicator.stopAnimating()
            indcBottom?.stopAnimating()
            self.viewModel?.updateData(data: response.hits)
            self.tableView.reloadData()
        }
        let failure : FailureImagePixabayHandler = { [weak self] (error) in
            guard let `self` = self else { return }
            // to do: stop loading
            self.activityIndicator.stopAnimating()
            indcBottom?.stopAnimating()
            
            guard let `error` = error else {
                // to do: Show general error
                self.labelError.isHidden = false
                return
            }
        }
        self.viewModel?.getImagePixabay(q: self.viewModel?.q ?? "", success: success, failure: failure)
    }
}
