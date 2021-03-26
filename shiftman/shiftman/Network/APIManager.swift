//
//  APIManager.swift
//  shiftman
//
//  Created by Stefan OShea on 25/3/21.
//

import Foundation
import Swinject

class ApiManagerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ApiManagerProtocol.self) { _ in
            APIManager()
        }
    }
}

protocol ApiManagerProtocol {
    func sendStartShiftRequest(_ request: ShiftRequestModel,
                               onSuccess: @escaping (() -> Void),
                               onError: @escaping () -> Void)
    func sendEndShiftRequest(_ request: ShiftRequestModel,
                             onSuccess: @escaping (() -> Void),
                             onError: @escaping () -> Void)
    func sendShiftHistoryRequest(onSuccess: @escaping ((Data) -> Void),
                                 onError: @escaping () -> Void)
}

class APIManager: ApiManagerProtocol {
    
    private enum Endpoint {
        private static let baseURL: String = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
        static let shiftStart: String = baseURL + "/shift/start"
        static let shiftEnd: String = baseURL + "/shift/end"
        static let shiftHistory: String = baseURL + "/shifts"
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func sendStartShiftRequest(_ request: ShiftRequestModel,
                               onSuccess: @escaping (() -> Void),
                               onError: @escaping () -> Void) {
        let endpoint = Endpoint.shiftStart
        buildRequestForEndpoint(endpoint,
                                request: request,
                                onSuccess: onSuccess,
                                onError: onError)
    }
    
    func sendEndShiftRequest(_ request: ShiftRequestModel,
                             onSuccess: @escaping (() -> Void),
                             onError: @escaping () -> Void) {
        let endpoint = Endpoint.shiftEnd
        buildRequestForEndpoint(endpoint,
                                request: request,
                                onSuccess: onSuccess,
                                onError: onError)
    }
    
    func sendShiftHistoryRequest(onSuccess: @escaping ((Data) -> Void),
                                 onError: @escaping () -> Void) {
        let endpoint = Endpoint.shiftHistory
        guard let url = URL(string: endpoint) else {
            onError()
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.GET.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Deputy eb0877843acc39f8ef6f7269937dee931c372d23",
                            forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil, response?.isResponseSuccessful() == true else {
                onError()
                return
            }
            onSuccess(data)
        }
        task.resume()
    }
    
    private func buildRequestForEndpoint(_ endpoint: String,
                                         request: ShiftRequestModel,
                                         onSuccess: @escaping (() -> Void),
                                         onError: @escaping () -> Void) {
        guard let url = URL(string: endpoint),
              let data = try? JSONEncoder().encode(request) else {
            onError()
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.POST.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Deputy eb0877843acc39f8ef6f7269937dee931c372d23",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = data

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil, response?.isResponseSuccessful() == true else {
                onError()
                return
            }
            onSuccess()
        }
        task.resume()
    }
}

