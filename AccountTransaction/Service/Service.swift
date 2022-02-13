//
//  Service.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import Alamofire
import Foundation
import SwiftyJSON

class Service {
    struct ErrorAPI: Error {
        let type: String
        let statusCode: Int?
        let description: String
        let userInfo: JSON
        let errorCode: Int
    }
    
    static let defaultError = ErrorAPI(
        type: "Default",
        statusCode: 0,
        description: "Something went wrong, please try again later",
        userInfo: [],
        errorCode: 0
    )
    
    @discardableResult
    class func request(
        httpMethod method: HTTPMethod,
        pathUrl pathURL: String,
        preferredBaseURL: String = "",
        parameters: [String: Any]? = nil,
        token: String = "",
        encoding: ParameterEncoding = URLEncoding.default,
        success: @escaping (_ json: JSON)->(),
        failure: @escaping (ErrorAPI)->()) -> Request {
            
            let baseURL = preferredBaseURL.isEmpty ? Constant.Service.baseURL : preferredBaseURL
            
            var headers: HTTPHeaders? = nil
            if !token.isEmpty {
                headers = ["Authorization": token]
            }
            
            return AF.request("\(baseURL)\(pathURL)", method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers).validate().responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success:
                    guard let data = response.data, let responseJSON = try? JSON(data: data) else {
                        debugPrint("HTTP Request Error: --Response Null")
                        failure(defaultError)
                        return
                    }
                    
                    success(responseJSON)
                case .failure(let error):
                    var callBackError = defaultError
                    
                    if error._code == NSURLErrorTimedOut ||
                        error._code == NSURLErrorNotConnectedToInternet ||
                        error._code == NSURLErrorNetworkConnectionLost {
                        
                        callBackError =  ErrorAPI(
                            type: "NoInternet",
                            statusCode: 1,
                            description: "No Internet Connection",
                            userInfo: [],
                            errorCode: 0
                        )
                    } else {
                        callBackError = ErrorAPI(
                            type: "NotAcceptable",
                            statusCode: 404,
                            description: error.localizedDescription,
                            userInfo: [],
                            errorCode: 0)
                    }
                    
                    failure(callBackError)
                }
            })
        }
}
