//
//  DeleteBookmarkUseCase.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class DeleteBookmarkUseCase {
    private var repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute(URL: String) {
        repository.deleteBookmark(URL: URL)
    }
}
