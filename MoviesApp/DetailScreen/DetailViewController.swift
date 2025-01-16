//
//  DetailViewController.swift
//  MoviesApp
//
//  Created by Павел on 05.01.2025.
//

import UIKit
import SafariServices
import CoreData

class DetailViewController: UIViewController {
    
    lazy var dataManager = CoreDataManager.shared
    private let detailModel = DetailModel()
    private let detailView = DetailView(frame: .zero)
    private var filmImagesDataSource: UICollectionViewDiffableDataSource<Section, String>?
    var filmId: Int?
    var film: FilmDetail?
    private var isFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        refreshFilmDetails()
        setupFilmImagesSource()
        setupNavigationBar()
        setupCallbacks()
        checkIfFavorite()
    }
    
    private func setupTrailerURL(with trailerURL: String?) {
        if let url = trailerURL {
            detailView.onTrailerButtonTap = {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.alpha = 0.8
                    self.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: { _ in
                    let safariVC = SFSafariViewController(url: URL(string: url) ?? URL(string: "https://www.youtube.com/")!)
                    safariVC.modalPresentationStyle = .pageSheet
                    self.present(safariVC, animated: true, completion: {
                        UIView.animate(withDuration: 0.3) {
                            self.view.alpha = 1.0
                            self.view.transform = .identity
                        }
                    })
                })
            }
        }
    }
    
    private func refreshFilmDetails() {
        guard let film_id = filmId else { return }
        Task {
            do {
                let film = try await detailModel.obtainFilmDetails(film_id: film_id)
                self.film = film
                updateView(with: film)
            } catch {
                print("some error with obtaining film details \(error)")
            }
        }
    }
    
    private func setupFilmImagesSource() {
        filmImagesDataSource = UICollectionViewDiffableDataSource(collectionView: detailView.imagesCollectionView, cellProvider: { collectionView, indexPath, filmImages in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            cell.configureCell(with: filmImages)
            return cell
        })
        detailView.imagesCollectionView.dataSource = filmImagesDataSource
    }
    
    private func updateView(with filmDetail: FilmDetail) {
        detailView.ratingLabel.text = "\(filmDetail.rating ?? 0.0)"
        detailView.titleLabel.text = "\(filmDetail.title)"
        detailView.yearLabel.text = "\(filmDetail.year)"
        detailView.durationLabel.text = "\(filmDetail.runningTime ?? 0) минут"
        detailView.genreLabel.text = "\(filmDetail.genres.first?.name ?? "")"
        detailView.descriptionLabel.text = "\(detailModel.removeTags(filmDescription: filmDetail.description))"
        detailView.starsNamesLabel.text = "\(filmDetail.stars)"
        setupTrailerURL(with: filmDetail.trailerURL)
        Task {
            if let posterImage = try? await ImageService.downloadImage(by: filmDetail.poster.image) {
                DispatchQueue.main.async {
                    self.detailView.posterImageView.image = posterImage
                }
            }
        }
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filmDetail.images.map {$0.image})
        filmImagesDataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupNavigationBar() {
        let favoriteBarButtonItem = UIBarButtonItem(customView: detailView.favoriteButton)
        lazy var backBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), primaryAction: onBackButtonAction)
        navigationItem.title = detailView.titleLabel.text
        navigationItem.leftBarButtonItem = backBarButtonItem
        navigationItem.rightBarButtonItem = favoriteBarButtonItem
        navigationController?.navigationBar.tintColor = Color.white
        navigationController?.navigationBar.barTintColor = Color.backgroundGray
    }
    
    private lazy var onBackButtonAction = UIAction { [weak self] _ in
        guard let self else { return}
        self.navigationController?.popViewController(animated: true)
    }
    
    private func checkIfFavorite() {

        guard let filmId = filmId else { return }
        
        let backgroundContext = self.dataManager.persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Film> = Film.fetchRequest()
            let predicate = NSPredicate(format: "film_id == %d", Int32(filmId))
            fetchRequest.predicate = predicate
            
            do {
                let film = try backgroundContext.fetch(fetchRequest)
                self.isFavorite = !film.isEmpty
                let newImage = self.isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
                DispatchQueue.main.async {
                    self.detailView.favoriteButton.setImage(newImage, for: .normal)
                }
            } catch {
                print("Failed to fetch film: \(error)")
            }
        }
        
    }
    
    private func setupCallbacks() {
        detailView.onSaveButtonTap = { [weak self] in
            guard let self else { return }
            
            self.isFavorite.toggle()
            let newImage = self.isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
            
            UIView.animate(withDuration: 0.2, animations: {
                self.detailView.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    self.detailView.favoriteButton.transform = .identity
                    self.detailView.favoriteButton.setImage(newImage, for: .normal)
                }
            })
            
            if self.isFavorite {
                if let film = self.film {
                    self.dataManager.saveFilm(film: film)
                }
            } else {
                if let filmId = self.filmId {
                    self.dataManager.deleteFilm(filmId: filmId)
                }
            }
        }
    }
}
