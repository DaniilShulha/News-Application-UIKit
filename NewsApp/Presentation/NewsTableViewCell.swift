import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(sourceLabel)
        contentView.addSubview(newsImageView)
        
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            newsImageView.widthAnchor.constraint(equalToConstant: 100),
            newsImageView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            sourceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            sourceLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 8),
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description ?? "No description available" 
        sourceLabel.text = article.source.name
        
        if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
            newsImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.2))],
                completionHandler: { result in
                    switch result {
                    case .success:
                        print("Image loaded for article: \(article.title)")
                    case .failure(let error):
                        print("Failed to load image for \(article.title): \(error)")
                    }
                }
            )
        } else {
            newsImageView.image = UIImage(systemName: "photo")
            print("No image URL for article: \(article.title)")
        }
    }
}
