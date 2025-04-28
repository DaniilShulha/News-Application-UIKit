//
//  NewsListViewController.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import UIKit

class NewsListViewController: UIViewController {
    
    var viewModel = NewsListViewModel()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["General", "Business", "Technology"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        segmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        setupBindings()
        viewModel.fetchNews(category: "general")
    }
    
    private func setupBindings() {
        viewModel.onNewsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel.onLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.startAnimating()
            }
        }
        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["General", "Business", "Technology"])
        segment.selectedSegmentIndex = 0
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    @objc private func refreshNews() {
        viewModel.fetchNews(category: segmentedControl.selectedSegmentIndex.toCategory())
        tableView.refreshControl?.endRefreshing()
    }
    
    @objc private func categoryChanged() {
        viewModel.fetchNews(category: segmentedControl.selectedSegmentIndex.toCategory())
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
    }

}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as! NewsTableViewCell
        cell.configure(with: viewModel.articles[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NewsDetailViewController()
        vc.configure(article: viewModel.articles[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension Int {
    func toCategory() -> String {
        switch self {
        case 0: return "general"
        case 1: return "business"
        case 2: return "technology"
        default: return "general"
        }
    }
}
