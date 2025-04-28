//
//  APIClient.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation
import Alamofire



class NewsAPIClient {
    private let baseURL = "https://newsapi.org/v2/top-headlines"
    private let apiKey = "ad58adfb16de4c03865bdcf94a7c2077"
    
    func fetchNews(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let parameters: [String: String] = [
            "category": category,
            "apiKey": apiKey,
            "country": "us"
        ]
        
        //print("Requesting news for category: \(category)")
        AF.request(baseURL, parameters: parameters).responseDecodable(of: NewsResponse.self) { response in
            switch response.result {
            case .success(let newsResponse):
                //print("Received \(newsResponse.articles.count) articles:")
                newsResponse.articles.forEach { article in
                    //print("Title: \(article.title), Image URL: \(article.urlToImage ?? "None")")
                }
                completion(.success(newsResponse.articles))
            case .failure(let error):
                //print("Network error: \(error)")
                completion(.failure(error))
            }
        }
    }
}

struct NewsResponse: Decodable {
    let articles: [Article]
}
