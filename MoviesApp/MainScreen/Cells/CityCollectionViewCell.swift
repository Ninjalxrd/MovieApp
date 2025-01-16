//
//  CityCollectionViewCell.swift
//  MoviesApp
//
//  Created by Павел on 16.01.2025.
//

import UIKit


class CityCollectionViewCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "Montserrat-Medium", size: 18)
        label.textColor = Color.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureCell(with city: City) {
        cityLabel.text = city.name
    }
    
    private func setupUI() {
        contentView.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                cityLabel.font = UIFont(name: "Montserrat-Bold", size: 19)
            } else {
                cityLabel.font = UIFont(name: "Montserrat-Medium", size: 18)
            }
        }
    }
}

extension CityCollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

