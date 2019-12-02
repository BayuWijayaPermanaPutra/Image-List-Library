//
//  ImagePixabayService.swift
//  Image Library
//
//  Created by PayTren on 12/1/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Alamofire
import Gloss

typealias GetImagePixabaySuccessHandler = (ImagePixabayResponse) -> ()
typealias FailureImagePixabayHandler = (NWError?) -> ()

class ImagePixabayService {
    
    let sessionManager: SessionManager
    init(with session: SessionManager = NetworkManager.shared.manager) {
        sessionManager = session
    }
    
    func getImagePixabay(q: String, page:String, completion: @escaping (NWResult<ImagePixabayResponse, NWError>) -> Void) {
        let request = ImagePixabayRequest(q: q, page: page)
        request.perform(using: sessionManager) { (result: NWResult<ImagePixabayResponse, NWError>) in
            completion(result)
        }
    }
    
}
