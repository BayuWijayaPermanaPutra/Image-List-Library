//
//  ImagePixabayRequest.swift
//  Image Library
//
//  Created by PayTren on 12/1/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Foundation

class ImagePixabayRequest : BasicAuthorizedAPIRequest {
    init(q : String, page: String) {
        let endpoint = EndPoint.baseUrlWithKey + "&q=\(q)&per_page=15&page\(page)"
        super.init(url: endpoint, method: .get, params: nil, escapeResponseCodeChecking: true)
    }
}
