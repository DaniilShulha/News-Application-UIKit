//
//  NewsArticle+CoreDataProperties.swift
//  NewsApp
//
//  Created by znexie on 25.04.25.
//
//

import Foundation
import CoreData

@objc(NewsArticle)
public class NewsArticle: NSManagedObject {

}


extension NewsArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsArticle> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }

    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var content: String?
    @NSManaged public var author: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var source: String?
    @NSManaged public var url: String?
    @NSManaged public var imgUrl: String?

}

extension NewsArticle : Identifiable {

}
