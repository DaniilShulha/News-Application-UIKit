//
//  BookmarksViewModel.swift
//  NewsApp
//
//  Created by Daniil Shulga on 26.04.25.
//

import Foundation

class BookmarksViewModel {
    private let fetchBookmarksUseCase: FetchBookmarksUseCase
    
    var bookmarks: [Article] = []
    var onBookmarksUpdated: (() -> Void)?

    init() {
        self.fetchBookmarksUseCase = FetchBookmarksUseCase.init(repository: NewsRepository())
    }
    
    func fetchBookmarks() {
        bookmarks = fetchBookmarksUseCase.execute()
        onBookmarksUpdated?()
    }
}
