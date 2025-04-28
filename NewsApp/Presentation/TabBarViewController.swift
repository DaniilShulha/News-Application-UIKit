//
//  TabBarViewController.swift
//  NewsApp
//
//  Created by Daniil Shulga on 26.04.25.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let newsListVC = NewsListViewController()
        let newsListNavController = UINavigationController(rootViewController: newsListVC)
        newsListNavController.tabBarItem = UITabBarItem(
            title: "News",
            image: UIImage(systemName: "newspaper"),
            selectedImage: UIImage(systemName: "newspaper.fill")
        )
        
        let bookmarksVC = BookmarksViewController()
        let bookmarksNavController = UINavigationController(rootViewController: bookmarksVC)
        bookmarksNavController.tabBarItem = UITabBarItem(
            title: "Bookmarks",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )
        
        viewControllers = [newsListNavController, bookmarksNavController]
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
    }
}
