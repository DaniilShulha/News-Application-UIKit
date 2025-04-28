//
//  SaveBookmarkUseCase.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class SaveBookmarkUseCase {
    private let repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute(_ article: Article) {
        repository.saveBookmark(article)
    }
}
