//
//  WatchLaterTableViewCell.swift
//  MoviesApp
//
//  Created by Павел on 12.01.2025.
//

import UIKit

class WatchLaterTableViewCell: UITableViewCell {
    
    private final let constant: CGFloat = 10
    private let posterHeight: CGFloat = 180
    private let posterWidth: CGFloat = 120
    private let iconSize: CGFloat = 20
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.backgroundColor = Color.backgroundGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Color.white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 16)
        label.textColor = Color.white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rating")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.orangeRating
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var genreImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ticket.white")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var yearImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calendar.white")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var durationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "clock.white")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Medium", size: 16)
        label.textColor = Color.white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingImage, ratingLabel])
        stackView.backgroundColor = Color.backgroundGray
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var genreStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [genreImage, genreLabel])
        stackView.backgroundColor = Color.backgroundGray
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var yearStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearImage, yearLabel])
        stackView.backgroundColor = Color.backgroundGray
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var durationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [durationImage, durationLabel])
        stackView.backgroundColor = Color.backgroundGray
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, ratingStackView, genreStackView, yearStackView, durationStackView])
        stackView.backgroundColor = Color.backgroundGray
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(infoStackView)
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constant),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: posterHeight),
            posterImageView.widthAnchor.constraint(equalToConstant: posterWidth),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            
            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: constant),
            infoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: constant),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constant),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -constant)
        ])
        
        NSLayoutConstraint.activate([
            ratingImage.heightAnchor.constraint(equalToConstant: iconSize),
            ratingImage.widthAnchor.constraint(equalToConstant: iconSize),
            
            genreImage.heightAnchor.constraint(equalToConstant: iconSize),
            genreImage.widthAnchor.constraint(equalToConstant: iconSize),
            
            yearImage.heightAnchor.constraint(equalToConstant: iconSize),
            yearImage.widthAnchor.constraint(equalToConstant: iconSize),
            
            durationImage.heightAnchor.constraint(equalToConstant: iconSize),
            durationImage.widthAnchor.constraint(equalToConstant: iconSize)
        ])
    }
    
    func configureCell(with film: Film) {
        
        activityIndicator.startAnimating()
        if let image = UIImage(data: film.poster ?? Data()) {
            posterImageView.image = image
            activityIndicator.stopAnimating()
        }
        
        titleLabel.text = film.title
        ratingLabel.text = String(film.rating)
        yearLabel.text = String(film.year)
        genreLabel.text = film.genre
        durationLabel.text = String("\(film.duration) минут")
    }
}

extension WatchLaterTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
