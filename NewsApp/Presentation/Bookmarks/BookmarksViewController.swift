//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Daniil Shulga on 26.04.25.
//

import UIKit

class BookmarksViewController: UIViewController {
    private let viewModel = BookmarksViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No bookmarks"
        label.font = .systemFont(ofSize: 24, weight: .black)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setupBindings()
        viewModel.fetchBookmarks()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBookmarks()
    }
    
    private func setupBindings() {
        viewModel.onBookmarksUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.emptyLabel.isHidden = !(self?.viewModel.bookmarks.isEmpty)!
            }
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
    }
    
    

}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: viewModel.bookmarks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = viewModel.bookmarks[indexPath.row]
        if let navController = navigationController {
            let newsDetailVC = NewsDetailViewController()
            newsDetailVC.configure(article: article)
            navController.pushViewController(newsDetailVC, animated: true)
        } else {
            print("Navigation controller is nil")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.bookmarks.count
    }
}
