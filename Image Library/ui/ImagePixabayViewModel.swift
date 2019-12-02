//
//  ImagePixabayViewModel.swift
//  Image Library
//
//  Created by PayTren on 12/1/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Foundation

class ImagePixabayViewModel {
    var q : String
    var page : Int = 1
    var cellModels : [ImagePixabayItemModel] = []
    
    init(q: String) {
        self.q = q
    }
    
    private static func buildCellModels() ->  [ImagePixabayItemModel] {
        
        var cellModels: [ImagePixabayItemModel] = []
        cellModels.append(ImagePixabayItemModel(urlImage: "https://increasify.com.au/wp-content/uploads/2016/08/default-image.png", username: "Bayu", viewsCount: 2000))
        cellModels.append(ImagePixabayItemModel(urlImage: "https://increasify.com.au/wp-content/uploads/2016/08/default-image.png", username: "Bayu", viewsCount: 2000))
        cellModels.append(ImagePixabayItemModel(urlImage: "https://increasify.com.au/wp-content/uploads/2016/08/default-image.png", username: "Bayu", viewsCount: 2000))
        
        return cellModels
    }
    
    func updateData(data : [ImageHitModel]){
        if page == 1 {
            cellModels.removeAll()
        }
        for item in data {
            cellModels.append(ImagePixabayItemModel(urlImage: item.webformatURL, username: item.user, viewsCount: item.views))
        }
    }
    
    func getImagePixabay(q:String, success: GetImagePixabaySuccessHandler?, failure: FailureImagePixabayHandler?) {
        ImagePixabayService().getImagePixabay(q: q, page: String(page)) { result in
            switch result {
            case .success(let obj):
                success?(obj)
            case .failure(let err):
                failure?(err)
            }
        }
    }
    
}
