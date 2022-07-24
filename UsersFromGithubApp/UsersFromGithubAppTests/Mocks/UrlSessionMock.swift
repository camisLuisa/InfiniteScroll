//
//  UrlSessionMock.swift
//  UsersFromGithubAppTests
//
//  Created by Camila Luísa Farias on 24/07/22.
//

import XCTest
@testable import UsersFromGithubApp

class UrlSessionMock: URLSessionProtocol {
    var mockResponse: Data?
    var error: NetworkError?

    func dataTask(
        urlRequest: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        if let mockResponse = mockResponse {
            completionHandler(
                mockResponse, HTTPURLResponse(
                    url: URL(string: "google.com")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil),
                nil)
        } else if let error = error {
            completionHandler(nil, nil, error)
        }
        return URLSessionDataTaskProtocolMock()
    }
}
