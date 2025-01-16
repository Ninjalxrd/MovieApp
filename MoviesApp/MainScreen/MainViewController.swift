//
//  MainViewController.swift
//  MoviesApp
//
//  Created by Павел on 29.12.2024.
//

import UIKit

enum Section {
    case main
}

class MainViewController: UIViewController {
    
    private let mainView = MainView(frame: .zero)
    private let mainModel = MainModel()
    private var cities: [City] = []
    private var defaultSlug = "ekb"
    private var currentPage = 1
    private var currentPageForButton = 2
    private var allFilmsAreLoaded = false
    private var isLoadingNextPage = false
    private var filmsByCityCollectionViewHeight: NSLayoutConstraint?
    private var popularFilmsDataSource: UICollectionViewDiffableDataSource<Section, FilmShort>?
    private var filmsByCityDataSource: UICollectionViewDiffableDataSource<Section, FilmShort>?
    private let numberImages: [UIImage?] = (1...10).map { UIImage(named: "\($0)") }
    lazy var dataManager = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.cityCollectionView.dataSource = self
        obtainCities()
        setupPopularFilmsDataSource()
        refreshMostPopularFilms()
        refreshFilmsByCity(citySlug: defaultSlug, page: 1)
        setupFilmsByCityDataSource()
        setupCallbacks()
        setupNavigationAndTabBars()
    }
    
    private func setupNavigationAndTabBars() {
        navigationItem.title = "Что вы хотите посмотреть?"
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Color.white,
            .font: UIFont(name: "Montserrat-SemiBold", size: 16) ?? .systemFont(ofSize: 16)
        ]
        navigationItem.titleView?.tintColor = Color.white
        navigationItem.titleView?.backgroundColor = Color.white
        navigationController?.navigationBar.barTintColor = Color.backgroundGray
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        tabBarController?.tabBar.barTintColor = Color.backgroundGray
        tabBarController?.tabBar.tintColor = Color.blue
        tabBarController?.tabBar.unselectedItemTintColor = Color.lightGray
    }
    
    private func refreshMostPopularFilms() {
        Task {
            do {
                let films = try await mainModel.obtainMostPopularFilms()
                let filteredFilms = Array(films.shuffled().prefix(10))
                updatePopularFilmsDataSource(with: filteredFilms, animate: true)
                
            } catch {
                print("some error with obtaining most popular films: \(error)")
            }
        }
    }
    
    func obtainCities() {
        Task {
            do {
                cities = try await mainModel.obtainCity()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.mainView.cityCollectionView.reloadData()
                    self.mainView.cityCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
                    self.mainView.updateIndicatorPosition(for: IndexPath(item: 0, section: 0))
                }
            } catch {
                print("error with obtaining cities \(error)")
            }
        }
    }
    
    private func refreshFilmsByCity(citySlug: String, page: Int) {
        Task {
            do {
                let films = try await mainModel.obtainFilmsByCity(citySlug: citySlug, page: page)
                updateFilmsByCityDataSource(with: films, animate: false)
            } catch {
                print("some error with obtaining films by city: \(error)")
            }
        }
    }
    
    private func setupPopularFilmsDataSource() {
        popularFilmsDataSource = UICollectionViewDiffableDataSource(collectionView: mainView.popularFilmsCollectionView, cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularFilmsCollectionViewCell.identifier, for: indexPath) as! PopularFilmsCollectionViewCell
            let numberImage = self.numberImages[indexPath.row] ?? UIImage()
            cell.configurePopularFilmsCell(with: film, numberImage: numberImage)
            return cell
        })
    }
    
    private func updatePopularFilmsDataSource(with films: [FilmShort], animate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FilmShort>()
        snapshot.appendSections([.main])
        snapshot.appendItems(films)
        popularFilmsDataSource?.apply(snapshot, animatingDifferences: true)
        mainView.showMoreButton.isHidden = false
    }
    
    private func setupFilmsByCityDataSource() {
        filmsByCityDataSource = UICollectionViewDiffableDataSource(collectionView: mainView.filmsByCityCollectionView, cellProvider: { collectionView, indexPath, film in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmsByCityCollectionViewCell.identifier, for: indexPath) as! FilmsByCityCollectionViewCell
            cell.configureCell(with: film)
            return cell
        })
    }
    
    private func updateFilmsByCityDataSource(with films: [FilmShort], animate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, FilmShort>()
        snapshot.appendSections([.main])
        snapshot.appendItems(films)
        filmsByCityDataSource?.apply(snapshot, animatingDifferences: false)
        
        UIView.animate(withDuration: 0.3) {
            self.calculateHeightOfCollectionView()
            self.mainView.layoutIfNeeded()
        }
        filmsByCityCollectionViewHeight?.isActive = true
    }
    
    private func calculateHeightOfCollectionView() {
        if let layout = mainView.filmsByCityCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let numberOfItems = filmsByCityDataSource?.snapshot().numberOfItems(inSection: .main) ?? 0
            let numberOfRows = numberOfItems % 3 == 0 ? numberOfItems / 3 : (numberOfItems / 3) + 1
            let totalSpacing = layout.minimumLineSpacing * CGFloat.maximum(CGFloat(numberOfRows - 1), 0)
            let width = (mainView.filmsByCityCollectionView.frame.width - layout.minimumLineSpacing) / 3
            let height = width + 90
            let totalHeight = height * CGFloat(numberOfRows) + totalSpacing + layout.sectionInset.bottom
            
            filmsByCityCollectionViewHeight = mainView.filmsByCityCollectionView.heightAnchor.constraint(equalToConstant: totalHeight)
        }
    }
    
    
    private func loadNextPage() {
        guard !allFilmsAreLoaded || !isLoadingNextPage else { return }
        self.mainView.showMoreButton.setTitle("\(currentPageForButton + 1) страница", for: .normal)
        isLoadingNextPage = true
        Task {
            do {
                let newFilms = try await mainModel.obtainFilmsByCity(citySlug: defaultSlug, page: currentPage + 1)
                if newFilms.isEmpty {
                    allFilmsAreLoaded = true
                } else {
                    currentPage += 1
                    currentPageForButton += 1
                    updateFilmsByCityDataSource(with: newFilms, animate: false)
                }
            } catch {
                print("error with load next page \(error)")
            }
            isLoadingNextPage = false
        }
    }

    private func setupCallbacks() {
        
        mainView.onCitySelected = { [weak self] indexPath, collectionView in
            guard let self else { return }
            let citySlug = self.cities[indexPath.row].slug
            refreshFilmsByCity(citySlug: citySlug, page: 1)
            
            self.mainView.showMoreButton.setTitle("2 страница", for: .normal)
            self.currentPageForButton = 2
            self.defaultSlug = citySlug
        }
        
        mainView.onItemSelected = { [weak self] indexPath, collectionView in
            guard let self else { return }
            showFilmDetail(at: indexPath, in: collectionView)
        }
        
        mainView.onSearchButtonTapped = { [weak self] searchText in
            guard let self else { return }
            findFilm(title: searchText)
        }
        
        mainView.onShowMoreButtonTapped = { [weak self] in
            guard let self else { return }
            self.loadNextPage()
            scrollToTop()
        }
    }
    
    private func scrollToTop() {
        let scrollView = mainView.filmsScrollView
        let collectionViewY = mainView.filmsByCityCollectionView.frame.origin.y
        scrollView.setContentOffset(CGPoint(x: 0, y: collectionViewY), animated: true)
    }
    
    private func findFilm(title: String) {
        let detailViewController = DetailViewController()
        if let film = filmsByCityDataSource?.snapshot().itemIdentifiers.first(where: { $0.title.lowercased() == title.lowercased() }) {
            detailViewController.filmId = film.film_id
            navigationController?.pushViewController(detailViewController, animated: true)
            mainView.searchBar.text = ""
        } else if let film = popularFilmsDataSource?.snapshot().itemIdentifiers.first(where: { $0.title.lowercased() == title.lowercased()}) {
            detailViewController.filmId = film.film_id
            navigationController?.pushViewController(detailViewController, animated: true)
            mainView.searchBar.text = ""
        } else {
            let alert = UIAlertController(title: "Фильм не найден", message: "Перепроверьте название фильма :)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func showFilmDetail(at indexPath: IndexPath, in collectionView: UICollectionView) {
        
        var selectedFilm: FilmShort?
        
        if collectionView == mainView.popularFilmsCollectionView {
            selectedFilm = popularFilmsDataSource?.itemIdentifier(for: indexPath)
        } else if collectionView == mainView.filmsByCityCollectionView {
            selectedFilm = filmsByCityDataSource?.itemIdentifier(for: indexPath)
        }
        
        guard let film = selectedFilm else { return }
        
        let detailViewController = DetailViewController()
        detailViewController.filmId = film.film_id
        
        detailViewController.modalPresentationStyle = .fullScreen
        detailViewController.transitioningDelegate = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismissAnimationController()
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        cell.configureCell(with: cities[indexPath.row])
        return cell
    }
    
    
}

