//
//  Network.swift
//  Image Library
//
//  Created by PayTren on 11/29/19.
//  Copyright © 2019 PayTren. All rights reserved.
//

import Gloss
import Alamofire

protocol APIRequestProtocol {
    var url: String { get }
    var params: Parameters? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
    func rendered(using sessionManger: SessionManager) -> DataRequest
}

protocol JSON_Initable {
    associatedtype T
    static func create(json: JSON) -> T?
}

protocol NWErrorProtocol {
    static func create(from response: DataResponse<Any>) -> Self
    static func create(from error: Error) -> Self // used for multipart upload
}

enum NWResult<T: JSON_Initable, E: NWErrorProtocol> {
    case success(obj: T)
    case failure(err: E)
}

enum NWArrayResult<T: JSON_Initable, E: NWErrorProtocol> {
    case successWithArray(obj: [T])
    case failure(err: E)
}

class BasicAuthorizedAPIRequest: APIRequestProtocol {
    let url: String
    let params: Parameters?
    let method: HTTPMethod
    var headers: HTTPHeaders? = [
        "Content-Type" : "application/json",
        "OSName" : "Type:iOS;Version:\(UIDevice.current.systemVersion);"]
    let encoding: ParameterEncoding
    var escapeResponseCodeChecking : Bool
    
    init(url: String, method: HTTPMethod, params: Parameters? = nil, additionalHeaders: HTTPHeaders? = nil, encoding: ParameterEncoding = JSONEncoding.default, escapeResponseCodeChecking: Bool = false) {
        self.url = url
        self.params = params
        self.method = method
        self.encoding = encoding
        if let additionalHeaders = additionalHeaders {
            self.headers = additionalHeaders
        }
        self.escapeResponseCodeChecking = escapeResponseCodeChecking
    }
    
    func rendered(using sessionManger: SessionManager) -> DataRequest {
        return sessionManger.requestCall(self.url, method: method, parameters: params, encoding: encoding, headers: self.headers)
    }
    
    //hit ini
    func perform<T,E>(using sessionManager: SessionManager, completion: @escaping (NWResult<T,E>) -> Void ) {
        rendered(using: sessionManager).validate().responseJSON { (response) in
            self.printResponse(response: response)
            switch response.result {
            case .success:
                if let json: JSON = response.result.value as? JSON, let obj = T.create(json: json) as? T {
                    if self.escapeResponseCodeChecking {
                        completion(.success(obj: obj))
                    } else {
                        if let responseCode: String = json.valueForKeyPath(keyPath: "responseCode") as? String {
                            if responseCode == "00" {
                                completion(.success(obj: obj))
                            } else {
                                completion(.failure(err: E.create(from: response)))
                            }
                        } else {
                            completion(.failure(err: E.create(from: response)))
                        }
                    }
                } else {
                    // TODO- Refactor this to accomdate throwing error when unable to parse response to expected object.
                    completion(.failure(err: E.create(from: response)))
                }
            case .failure(_):
                completion(.failure(err: E.create(from: response)))
            }
        }
    }
    
    func performArray<T,E>(using sessionManager: SessionManager, completion: @escaping (NWArrayResult<T,E>) -> Void ) {
        rendered(using: sessionManager).validate().responseJSON { (response) in
            self.printResponse(response: response)
            switch response.result {
            case .success:
                if let jsons: [JSON] = response.result.value as? [JSON] {
                    let objects: [T] = jsons.compactMap { (json) -> T? in
                        return T.create(json: json) as? T
                    }
                    completion(.successWithArray(obj: objects))
                } else {
                    // TODO- Refactor this to accomdate throwing error when unable to parse response to expected object.
                    completion(.failure(err: E.create(from: response)))
                }
            case .failure(_):
                completion(.failure(err: E.create(from: response)))
            }
        }
    }
    
    fileprivate func printResponse(response: DataResponse<Any>) {
        print("\n\n\nResponse: \(response)\nRequest header: \(response.request?.allHTTPHeaderFields?.debugDescription ?? "nil")\nURL: \(url)\nMethod: \(response.request?.httpMethod ?? "nil")\n\n\n")
    }
}

extension Alamofire.SessionManager {
    func requestCall(_ url: URLConvertible,
                     method: HTTPMethod,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding = URLEncoding.default,
                     headers: HTTPHeaders? = nil) -> DataRequest {
        return self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}


class NetworkManager {
    static let shared = NetworkManager()
    
    let manager: Alamofire.SessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            EndPoint.baseUrl: ServerTrustPolicy.disableEvaluation
        ]
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        
        let _manager = Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        return _manager
    }()
}

enum AppAPIError: Error {
    case noInternetConnection
    case cannotFindHost
    case unknown(message: String?)
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection, .cannotFindHost: return "Kamu sedang offline, silahkan cek koneksi atau pastikan paket datamu aktif"
        case .unknown(let message): return message ?? "Something went wrong"
        }
    }
    
    static func from(errorCode: Int, message: String? = nil) -> AppAPIError {
        switch errorCode {
        case NSURLErrorNotConnectedToInternet,NSURLErrorTimedOut:
            return .noInternetConnection
        case NSURLErrorCannotFindHost:
            return .cannotFindHost
        default:
            return .unknown(message: message)
        }
    }
}

struct NWError: NWErrorProtocol {
    
    static func create(from response: DataResponse<Any>) -> NWError {
        if let error = response.error as NSError? {
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut, NSURLErrorCannotFindHost:
                let errorType = AppAPIError.from(errorCode: error.code)
                return NWError(status: error.code, responseCode: String(error.code), responseMessage: errorType.localizedDescription, errorType: errorType)
            default: break
            }
        }
        let status = response.response?.statusCode ?? -1
        guard let data = response.data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? JSON else {
            let errorType: AppAPIError = .unknown(message: nil)
            return NWError(status: status, responseCode: "01", responseMessage: errorType.localizedDescription, errorType: .unknown(message: nil))
        }
        
        let responseCode: String? = "responseCode" <~~ json
        let responseMessage: String = "responseMessage" <~~ json ?? HTTPURLResponse.localizedString(forStatusCode: status)
        return NWError(status: status, responseCode: responseCode, responseMessage: responseMessage, errorType: .unknown(message: responseMessage))
    }
    
    static func create(from error: Error) -> NWError {
        if let error = error as NSError? {
            switch error.code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorTimedOut, NSURLErrorCannotFindHost:
                let errorType = AppAPIError.from(errorCode: error.code)
                return NWError(status: error.code, responseCode: String(error.code), responseMessage: errorType.localizedDescription, errorType: errorType)
            default: break
            }
        }
        let status = -1
        let responseCode: String? = "-1"
        let responseMessage: String = error.localizedDescription
        return NWError(status: status, responseCode: responseCode, responseMessage: responseMessage, errorType: .unknown(message: responseMessage))
    }
    
    let status: Int
    let responseCode: String?
    let responseMessage: String
    var errorType: AppAPIError
}
