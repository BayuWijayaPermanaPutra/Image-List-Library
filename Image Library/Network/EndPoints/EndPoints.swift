//
//  EndPoints.swift
//  Image Library
//
//  Created by PayTren on 11/30/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Foundation

class EndPoint {
    static var apiKeyPixabay : String { get { return "14410460-881c1fedac1cb7e1a9b524347" } }
    static var baseUrl : String { get { return "https://pixabay.com/api/" } }
    static var baseUrlWithKey : String { get { return baseUrl + "?key=" + apiKeyPixabay }}
}
