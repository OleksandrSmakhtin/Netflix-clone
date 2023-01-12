//
//  APICaller.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 19.12.2022.
//

import Foundation

enum APIError: Error {
    case failedToGetData
}


class APICAller {
    static let shared  = APICAller()
    
    
//MARK: - Trending Movies
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
         
        guard let url = URL(string: "\(Constant.BASE_URL)/3/trending/movie/day?api_key=\(Constant.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            do {
                let results =  try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    
    
//MARK: - Trending TVs
    func getTrendingTvs(completion: @escaping(Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.BASE_URL)/3/trending/tv/day?api_key=\(Constant.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
    
        }.resume()
    }
    
    
//MARK: - Upcoming Movies
                                                  // use the same type
    func getUpcomingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.BASE_URL)/3/movie/upcoming?api_key=\(Constant.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    
//MARK: - Popular
    func getPopularMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.BASE_URL)/3/movie/popular?api_key=\(Constant.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }.resume()
    }
    
    
//MARK: - Top Rated
    func getTopRatedMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.BASE_URL)/3/movie/top_rated?api_key=\(Constant.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(TrendingTitlesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    
    
    
    
}
