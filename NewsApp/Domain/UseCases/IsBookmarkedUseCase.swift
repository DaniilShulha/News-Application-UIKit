//
//  isBookmarkedUseCase.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class IsBookmarkedUseCase {
    private var repository: NewsRepository
    
    init(repository: NewsRepository) {
        self.repository = repository
    }
    
    func execute(URL: String) -> Bool {
        repository.isBookmarked(URL: URL)
    }
}

