//
//  GithubAPIManager.swift
//  UsersFromGithubApp
//
//  Created by Camila Luísa Farias on 22/07/22.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol { func resume() }

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
extension URLSession: URLSessionProtocol {
    func dataTask(urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: urlRequest, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}

protocol GithubAPIManagerProtocol {
    func getUsers(perPage: Int, sinceId: Int?, completion: @escaping (Result<[User], NetworkError>) -> Void)
}

class GithubAPIManager: GithubAPIManagerProtocol {
    private let session: URLSessionProtocol
    private let dispatchQueueWrapper: DispatchQueueWrapperProtocol
    
    init(
        session: URLSessionProtocol = URLSession.shared,
         dispatchQueueWrapper: DispatchQueueWrapperProtocol = DispatchQueueWrapper()
    ) {
        self.session = session
        self.dispatchQueueWrapper = dispatchQueueWrapper
    }
    
    func getUsers(perPage: Int = 30, sinceId: Int? = nil, completion: @escaping (Result<[User], NetworkError>) -> Void) {
        
        var components = makeGithubAPIComoponents()
        components.queryItems = [
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "since", value: (sinceId != nil) ? "\(sinceId!)" : "")
        ]
        
        guard let url = components.url else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let urlRequest = URLRequest(url: url, timeoutInterval: 10)
        
        let task = session.dataTask(urlRequest: urlRequest) { [weak self] data, urlResponse, error in

            self?.dispatchQueueWrapper.mainAsync {
                
                if error != nil {
                    completion(.failure(.failed(error: error!)))
                } else if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let response = try decoder.decode([User].self, from: data)

                        completion(.success(response))
                    } catch {
                        completion(.failure(.errorDecode))
                    }
                } else {
                    print("unknown dataTask error")
                    completion(.failure(.unknownError))
                }
            }
        }
        
        task.resume()        
    }
}

private extension GithubAPIManager {
    struct GithubAPI {
        static let scheme = "https"
        static let host = "api.github.com"
        static let path = "/users"
    }
    
    func makeGithubAPIComoponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = GithubAPI.scheme
        components.host = GithubAPI.host
        components.path = GithubAPI.path
        
        return components
    }
}
