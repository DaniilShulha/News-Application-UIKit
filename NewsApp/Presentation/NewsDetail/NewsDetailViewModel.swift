//
//  NewsDetailViewModel.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

class NewsDetailViewModel {
    private let article: Article
    private let saveBookmarkUseCase: SaveBookmarkUseCase
    private let isBookmarkedUseCase: IsBookmarkedUseCase
    private let deleteBookmarkUseCase: DeleteBookmarkUseCase
    
    var isBookmarked: Bool {
        isBookmarkedUseCase.execute(URL: article.url)
    }
    
    var onBookmarkStatusChanged: (() -> Void)?
    
    init(article: Article) {
        self.article = article
        self.saveBookmarkUseCase = SaveBookmarkUseCase(repository: NewsRepository())
        self.deleteBookmarkUseCase = DeleteBookmarkUseCase(repository: NewsRepository())
        self.isBookmarkedUseCase = IsBookmarkedUseCase(repository: NewsRepository())
    }
    
    func toggleBookmark() {
        if isBookmarked {
            deleteBookmarkUseCase.execute(URL: article.url)
        } else {
            saveBookmarkUseCase.execute(article)
        }
        onBookmarkStatusChanged?()

    }
}
