//
//  MainView.swift
//  MoviesApp
//
//  Created by Павел on 29.12.2024.
//

import UIKit

class MainView: UIView {
    
    private final let constant: CGFloat = 10
    private final let spacing: CGFloat = 10
    private final let defaultHeightForCities: CGFloat = 70
    private var indicatorLeadingConstraint: NSLayoutConstraint?
    private var indicatorWidthConstraint: NSLayoutConstraint?
    var onCitySelected: ((IndexPath, UICollectionView) -> Void)?
    var onItemSelected: ((IndexPath, UICollectionView) -> Void)?
    var onSearchButtonTapped: ((String) -> Void)?
    var onShowMoreButtonTapped: (() -> Void)?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundGray
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var cancelAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.endEditing(true)
    }
    
    private func addCancelButtonToKeyboard(textField: UITextField) {
        let toolbar = UIToolbar()
        let cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), primaryAction: cancelAction)
        toolbar.sizeToFit()
        toolbar.items = [cancelButton]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        textField.inputAccessoryView = toolbar
    }
    
    lazy var showMoreButton: UIButton = {
        let button = UIButton(primaryAction: showMoreAction)
        button.setTitle("2 страница", for: .normal)
        button.setTitleColor(Color.white, for: .normal)
        button.setTitleColor(Color.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "Montserrat-Semibold", size: 16)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = Color.darkerThanLightButLighterThanDark
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private lazy var showMoreAction = UIAction { [weak self] _ in
        guard let self else { return }
        self.onShowMoreButtonTapped?()
    }
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск"
        search.translatesAutoresizingMaskIntoConstraints = false
        search.backgroundImage = UIImage()
        search.tintColor = Color.darkerThanLightButLighterThanDark
        search.delegate = self
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(Color.lightGray ?? .systemGray6, renderingMode: .alwaysOriginal)
        search.setImage(searchIcon, for: .search, state: .normal)
        
        let searchTextField = search.searchTextField
        searchTextField.backgroundColor = Color.darkerThanLightButLighterThanDark
        searchTextField.textColor = Color.white
        searchTextField.layer.cornerRadius = 16
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont(name: "Montserrat-Medium", size: 18)
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Montserrat-Medium", size: 18) ?? UIFont.systemFont(ofSize: 18),
            .foregroundColor: Color.lightGray ?? .systemGray5
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Поиск", attributes: placeholderAttributes)
        addCancelButtonToKeyboard(textField: searchTextField)

        return search
    }()
    
    lazy var popularFilmsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundGray
        collectionView.register(PopularFilmsCollectionViewCell.self, forCellWithReuseIdentifier: PopularFilmsCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var cityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundGray
        collectionView.delegate = self
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.selectItem(at: IndexPath(index: 0), animated: true, scrollPosition: .left)
        return collectionView
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.darkerThanLightButLighterThanDark
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var filmsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(searchBar)
        scrollView.addSubview(popularFilmsCollectionView)
        scrollView.addSubview(cityCollectionView)
        scrollView.addSubview(indicatorView)
        scrollView.addSubview(filmsByCityCollectionView)
        scrollView.addSubview(showMoreButton)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var filmsByCityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Color.backgroundGray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilmsByCityCollectionViewCell.self, forCellWithReuseIdentifier: FilmsByCityCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private func setupUI() {
        addSubview(filmsScrollView)
        
        indicatorLeadingConstraint = indicatorView.leadingAnchor.constraint(equalTo: cityCollectionView.leadingAnchor)
        indicatorWidthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            filmsScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            filmsScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filmsScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filmsScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            searchBar.topAnchor.constraint(equalTo: filmsScrollView.topAnchor, constant: constant),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            
            popularFilmsCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: constant),
            popularFilmsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            popularFilmsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            popularFilmsCollectionView.heightAnchor.constraint(equalToConstant: 250),
            
            cityCollectionView.topAnchor.constraint(equalTo: popularFilmsCollectionView.bottomAnchor, constant: constant),
            cityCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityCollectionView.heightAnchor.constraint(equalToConstant: defaultHeightForCities),
            cityCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            indicatorView.heightAnchor.constraint(equalToConstant: 4),
            indicatorView.bottomAnchor.constraint(equalTo: cityCollectionView.bottomAnchor, constant: -2),
            indicatorLeadingConstraint!,
            indicatorWidthConstraint!,
            
            filmsByCityCollectionView.topAnchor.constraint(equalTo: cityCollectionView.bottomAnchor, constant: constant),
            filmsByCityCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            filmsByCityCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            
            showMoreButton.topAnchor.constraint(equalTo: filmsByCityCollectionView.bottomAnchor, constant: constant),
            showMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            showMoreButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45),
            showMoreButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.06),
            showMoreButton.bottomAnchor.constraint(equalTo: filmsScrollView.contentLayoutGuide.bottomAnchor, constant: -constant)
        ])
    }
    
    func updateIndicatorPosition(for indexPath: IndexPath) {
        guard let attributes = cityCollectionView.layoutAttributesForItem(at: indexPath) else { return }
        let cellFrame = cityCollectionView.convert(attributes.frame, to: filmsScrollView)
        indicatorWidthConstraint?.constant = cellFrame.width
        indicatorLeadingConstraint?.constant = cellFrame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == cityCollectionView, let selectedIndexPath = cityCollectionView.indexPathsForSelectedItems?.first else { return }
        updateIndicatorPosition(for: selectedIndexPath)
    }
}

extension MainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filmsByCityCollectionView {
            let totalSpacing = constant * 2 + spacing
            let width = (collectionView.bounds.width - totalSpacing) / 3
            let height = width + 90
            return CGSize(width: width, height: height)
        } else if collectionView == popularFilmsCollectionView{
            return CGSize(width: 150, height: 250)
        } else {
            let totalSpacing = constant + spacing
            let width = (collectionView.bounds.width - totalSpacing) / 2
            let height = defaultHeightForCities
            return CGSize(width: width, height: height)
        }
    }
}

extension MainView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2,
                           animations: {
                               cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                           },
                           completion: { _ in
                               UIView.animate(withDuration: 0.2) {
                                   cell.transform = .identity
                               }
                           })
        }
        if collectionView == filmsByCityCollectionView || collectionView == popularFilmsCollectionView {
            onItemSelected?(indexPath, collectionView)
        } else {
            onCitySelected?(indexPath, collectionView)
            updateIndicatorPosition(for: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            cell.alpha = 0
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.3, delay: 0.05 * Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.alpha = 1
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    
}

extension MainView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        onSearchButtonTapped?(searchText)
    }
}

