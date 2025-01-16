//
//  PopularFilmsCollectionViewCell.swift
//  MoviesApp
//
//  Created by Павел on 29.12.2024.
//

import UIKit

class PopularFilmsCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var posterView: UIView = {
        let view = UIView()
        view.addSubview(posterImageView)
        view.addSubview(numberImageView)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var numberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = Color.white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
    
    func configurePopularFilmsCell(with film: FilmShort, numberImage: UIImage) {
        numberImageView.image = numberImage
        
        activityIndicator.startAnimating()
        Task {
            let image = try? await ImageService.downloadImage(by: film.poster.image)
            posterImageView.image = image
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupUI() {
        
        contentView.addSubview(posterView)
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            posterImageView.topAnchor.constraint(equalTo: posterView.topAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: posterView.trailingAnchor),
            posterImageView.widthAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 0.85),
            posterImageView.heightAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 0.9),
            
            activityIndicator.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            
            numberImageView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: -60),
            numberImageView.leadingAnchor.constraint(equalTo: posterImageView.leadingAnchor, constant: -26),
            numberImageView.widthAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 0.85),
            numberImageView.heightAnchor.constraint(equalTo: posterImageView.heightAnchor, multiplier: 0.38)
        ])
    }
}

extension PopularFilmsCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
