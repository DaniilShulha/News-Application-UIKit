//
//  FetchNewsUseCase.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class FetchNewsUseCase {
    private var repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        repository.fetchNews(category: category, completion: completion)
    }
    
}
