//
//  NewsRepository.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

protocol Repository {
    func fetchNews(category: String, completion: @escaping (Result<[Article], Error>) -> Void)
    func saveBookmark(_ article: Article)
    func deleteBookmark(URL: String)
    func isBookmarked(URL:String) -> Bool
    func fetchBookmarks() -> [Article]
}

class NewsRepository: Repository {
    private let apiClient = NewsAPIClient()
    private let coreDataManager = CoreDataManager.shared
    
    func fetchNews(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        apiClient.fetchNews(category: category, completion: completion)
    }
    
    func saveBookmark(_ article: Article) {
        coreDataManager.createArticle(article)
    }
    
    func deleteBookmark(URL: String) {
        coreDataManager.deleteArticle(url: URL)
    }
    
    func isBookmarked(URL: String) -> Bool {
        coreDataManager.isBookmarked(url: URL)
    }
    
    func fetchBookmarks() -> [Article] {
        coreDataManager.fetchBookmarks().map { article in
            Article(
                title: article.title ?? "",
                description: article.desc,
                content: article.content,
                author: article.author,
                publishedAt: article.publishedAt ?? "",
                source: .init(name: article.source ?? ""),
                url: article.url ?? "",
                urlToImage: article.imgUrl 
            )
        }
    }
    
    
}
