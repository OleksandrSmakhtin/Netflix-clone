//
//  APICaller.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 19.12.2022.
//

import Foundation

enum APIError {
    case failedToGetData
}


class APICAller {
    static let shared  = APICAller()
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
         
        guard let url = URL(string: "\(Constant.BASE_URL)/3/trending/all/day?api_key=\(Constant.API_KEY)") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            
            do {
                let results =  try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
    
}
