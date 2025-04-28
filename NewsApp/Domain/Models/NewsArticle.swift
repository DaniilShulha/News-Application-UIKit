//
//  NewArticle.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import Foundation

struct Article: Codable {
    public var title: String
    public var description: String?
    public var content: String?
    public var author: String?
    public var publishedAt: String
    public var source: Source
    public var url: String
    public var urlToImage: String?
    
    struct Source: Codable {
        let name: String
    }
}
