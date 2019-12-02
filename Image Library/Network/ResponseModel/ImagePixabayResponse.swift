//
//  ImagePixabayResponse.swift
//  Image Library
//
//  Created by PayTren on 11/30/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Foundation
import Gloss

struct ImagePixabayResponse : JSON_Initable {
    typealias T = ImagePixabayResponse
    let hits : [ImageHitModel]
    
    static func create(json: JSON) -> ImagePixabayResponse? {
        return ImagePixabayResponse(json)
    }
    
    init?(_ json:JSON){
        hits = ImagePixabayResponse.parseData(json)
    }
    
    fileprivate static func parseData(_ json: JSON) -> [ImageHitModel] {
        if let data: [JSON] = "hits" <~~ json {
            let images = data.compactMap({ (dict: JSON) -> ImageHitModel? in
                if let images = ImageHitModel(dict) {
                    return images
                }
                return nil
            })
            return images
        }
        return []
    }
}


/*
 {
 comments = 101;
 downloads = 79600;
 favorites = 463;
 id = 2756467;
 imageHeight = 2620;
 imageSize = 3514940;
 imageWidth = 3925;
 largeImageURL = "https://pixabay.com/get/54e7d0454e54ab14f6da8c7dda79367a113edee155516c4870287ed69645c65ab9_1280.jpg";
 likes = 499;
 pageURL = "https://pixabay.com/photos/salad-fruits-berries-healthy-2756467/";
 previewHeight = 100;
 previewURL = "https://cdn.pixabay.com/photo/2017/09/16/19/21/salad-2756467_150.jpg";
 previewWidth = 150;
 tags = "salad, fruits, berries";
 type = photo;
 user = silviarita;
 userImageURL = "https://cdn.pixabay.com/user/2019/06/09/20-47-43-742_250x250.jpg";
 "user_id" = 3142410;
 views = 156075;
 webformatHeight = 427;
 webformatURL = "https://pixabay.com/get/54e7d0454e54ab14f6da8c7dda79367a113edee155516c4870287ed69645c65ab9_640.jpg";
 webformatWidth = 640;
 }
 */

struct ImageHitModel : JSON_Initable {
    typealias T = ImageHitModel
    let largeImageURL : String
    let webformatHeight : Double
    let webformatWidth : Double
    let likes : Double
    let imageWidth : Double
    let imageHeight : Double
    let id : Double
    let user_id : Double
    let views : Double
    let comments : Double
    let pageURL : String
    let webformatURL : String
    let type : String
    let tags : String
    let downloads : Double
    let user : String
    let favorites : Double
    let imageSize : Double
    let previewHeight : Double
    let previewWidth : Double
    let userImageURL : String
    let previewURL : String

    static func create(json: JSON) -> ImageHitModel.T? {
        return ImageHitModel(json)
    }
    
    init?(_ json:JSON) {
        largeImageURL = "largeImageURL" <~~ json ?? ""
        webformatHeight = "webformatHeight" <~~ json ?? 0
        webformatWidth = "webformatWidth" <~~ json ?? 0
        likes = "likes" <~~ json ?? 0
        imageWidth = "imageWidth" <~~ json ?? 0
        imageHeight = "imageHeight" <~~ json ?? 0
        id = "id" <~~ json ?? 0
        user_id = "user_id" <~~ json ?? 0
        views = "views" <~~ json ?? 0
        comments = "comments" <~~ json ?? 0
        pageURL = "pageURL" <~~ json ?? ""
        webformatURL = "webformatURL" <~~ json ?? ""
        type = "type" <~~ json ?? ""
        tags = "tags" <~~ json ?? ""
        downloads = "downloads" <~~ json ?? 0
        user = "user" <~~ json ?? ""
        favorites = "favorites" <~~ json ?? 0
        imageSize = "imageSize" <~~ json ?? 0
        previewHeight = "previewHeight" <~~ json ?? 0
        previewWidth = "previewWidth" <~~ json ?? 0
        userImageURL = "userImageURL" <~~ json ?? ""
        previewURL = "previewURL" <~~ json ?? ""
        
    }
}
