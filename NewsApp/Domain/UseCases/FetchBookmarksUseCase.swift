//
//  FetchBookmarksUseCase.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class FetchBookmarksUseCase {
    private var repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute() -> [Article] {
        repository.fetchBookmarks()
    }
}
