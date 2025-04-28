//
//  CoreDataManager.swift
//  NewsApp
//
//  Created by znexie on 25.04.25.
//

import CoreData
import UIKit

public final class CoreDataManager {
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer

    private init() {
        // Проверяем, что модель данных существует
        guard let modelURL = Bundle.main.url(forResource: "NewsApp", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load CoreData model")
        }
        
        persistentContainer = NSPersistentContainer(name: "NewsApp", managedObjectModel: managedObjectModel)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load CoreData store: \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createArticle(_ article: Article) {
        let context = persistentContainer.viewContext
        let entity = NewsArticle(context: context)
        entity.title = article.title
        entity.desc = article.description
        entity.content = article.content
        entity.author = article.author
        entity.publishedAt = article.publishedAt
        entity.source = article.source.name
        entity.url = article.url
        entity.imgUrl = article.urlToImage
        
        do {
            try context.save()
        } catch {
            print("Failed to save article: \(error)")
        }
    }
    
   func fetchBookmarks() -> [NewsArticle] {
        let fetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        do {
            let articles = try context.fetch(fetchRequest)
            //print("Fetched \(articles.count) articles")
            return articles
        } catch {
            //print("Failed to fetch articles: \(error)")
            return []
        }
    }
    
    public func fetchArticle(title: String) -> NewsArticle? {
        let fetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        do {
            let articles = try context.fetch(fetchRequest)
            //print("Fetched article with title: \(title), found: \(articles.count)")
            return articles.first
        } catch {
            //print("Failed to fetch article: \(error)")
            return nil
        }
    }
    
    func deleteArticle(url: String) -> Bool {
        let fetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        return context.performAndWait {
            do {
                let articles = try context.fetch(fetchRequest)
                //print("Found \(articles.count) articles for URL: \(url)")
                //articles.forEach { article in
                //    print("Article in DB: URL: \(article.url ?? "nil"), Title: \(article.title ?? "nil")")
                //}
                
                guard let article = articles.first else {
                    //print("No article found to delete for URL: \(url)")
                    return false
                }
                
                context.delete(article)
                try context.save()
                //print("Article deleted successfully: \(url)")
                return true
            } catch {
                //print("Failed to delete article: \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func isBookmarked(url: String) -> Bool {
        let fetchRequest: NSFetchRequest<NewsArticle> = NewsArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        
        return context.performAndWait {
            do {
                let articles = try context.fetch(fetchRequest)
                let isBookmarked = !articles.isEmpty
                //print("Checked bookmark for URL: \(url), isBookmarked: \(isBookmarked)")
                //articles.forEach { article in
                    //print("Found article in DB: URL: \(article.url ?? "nil"), Title: \(article.title ?? "nil")")
                //}
                return isBookmarked
            } catch {
                //print("Failed to check bookmark: \(error)")
                return false
            }
        }
    }
}
