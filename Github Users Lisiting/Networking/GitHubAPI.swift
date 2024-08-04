//
//  GitHubAPI.swift
//  Github Users Lisiting
//
//  Created by Kua Jun Hong on 03/08/2024.
//

import Foundation

class GitHubAPI {
    static let baseURL = "https://api.github.com"
    
    static func getUsers(page: Int, completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "\(baseURL)/users?per_page=30&page=\(page)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    static func getUserDetails(url: String, completion: @escaping (Result<UserDetails, Error>) -> Void) {
        performRequest(urlString: url, completion: completion)
    }
    
    static func getRepositories(url: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let urlString = url + "?sort=stars"
        performRequest(urlString: urlString, completion: completion)
    }
    
    private static func performRequest<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
