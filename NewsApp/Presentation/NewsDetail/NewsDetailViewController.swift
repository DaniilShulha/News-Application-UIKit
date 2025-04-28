//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by znexie on 26.04.25.
//

import UIKit
import SwiftSoup

class NewsDetailViewController: UIViewController {
    private var viewModel: NewsDetailViewModel?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    

    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    lazy var bookmarkBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //lazy var titleLabel = createLabel(fontSize: 20, weight: .black, textColor: guard .)
    
    lazy var authorLabel = createLabel(fontSize: 16, weight: .medium, textColor: .secondaryLabel)

    lazy var dateLabel = createLabel(fontSize: 16, weight: .medium, textColor: .secondaryLabel)
    
    
    func createLabel(fontSize: Int, weight: UIFont.Weight, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: CGFloat(fontSize), weight: weight)
        return label
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Article"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentTextView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: bookmarkBtn)
        bookmarkBtn.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        setupBindings()
        
    }
    
    func configure(article: Article) {
        viewModel = NewsDetailViewModel(article: article)
        titleLabel.text = article.title
        authorLabel.text = article.author
        dateLabel.text = article.publishedAt
        contentTextView.text = article.content
        if let url = article.urlToImage {
            imageView.kf.setImage(with: URL(string: url))
        }
        updateBookmarkButton()
    }
    
    
    
    private func updateBookmarkButton() {
        let image = viewModel?.isBookmarked ?? false ? "bookmark.fill" : "bookmark"
        bookmarkBtn.setImage(UIImage(systemName: image), for: .normal)
    }
    
    @objc private func bookmarkButtonTapped() {
        viewModel?.toggleBookmark()
    }
    
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = .systemBackground
    }
    
    private func setupBindings() {
        viewModel?.onBookmarkStatusChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.updateBookmarkButton()
            }
        }
    }
}
