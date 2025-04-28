//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class NewsListViewModel {
    private let newsRepository: Repository
    var articles: [Article] = []
    
    var onNewsUpdated: (() -> Void)?
    var onLoading: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(newsRepository: Repository = NewsRepository()) {
        self.newsRepository = newsRepository
    }
    
    func fetchNews(category: String) {
        onLoading?()
        newsRepository.fetchNews(category: category) { [weak self] result in
            switch result {
            case .success(let articles):
//                print("Fetched \(articles.count) articles:")
//                articles.forEach { article in
//                    print("Title: \(article.title)")
//                    print("Description: \(article.description ?? "None")")
//                    print("Image URL: \(article.urlToImage ?? "None")")
//                    print("----")
//                }
                self?.articles = articles
                self?.onNewsUpdated?()
            case .failure(let error):
                print("Failed to fetch news: \(error)")
                self?.onError?(error)
            }
        }
    }
}
