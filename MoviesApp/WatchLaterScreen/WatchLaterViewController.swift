//
//  WatchLaterViewController.swift
//  MoviesApp
//
//  Created by Павел on 11.01.2025.
//

import CoreData
import UIKit

class WatchLaterViewController: UIViewController {

    
    private let watchLaterModel = WatchLaterModel()
    private let watchLaterView = WatchLaterView(frame: .zero)
    private var fetchedResultController: NSFetchedResultsController<Film>!
    private var tableViewDataSource: UITableViewDiffableDataSource<Section, Film>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view = watchLaterView
        setupFetchedResultController()
        setupDataSource()
        setupCallbacks()
    }
    
    private func setupFetchedResultController() {
        fetchedResultController = CoreDataManager.shared.createFetchResultsController()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Ошибка при выполнении fetch запроса: \(error)")
        }
    }
    
    private func setupCallbacks() {
        watchLaterView.onItemSelected = { [weak self] indexPath, tableView in
            guard let self else { return }
            self.showFilmDetail(at: indexPath, tableView: tableView)
        }
    }
    
    private func showFilmDetail(at indexPath: IndexPath, tableView: UITableView) {
        let selectedFilm = tableViewDataSource?.itemIdentifier(for: indexPath)
        
        guard let film = selectedFilm else { return }
        let detailViewController = DetailViewController()
        detailViewController.filmId = Int(film.film_id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    private func setupDataSource() {
        tableViewDataSource = UITableViewDiffableDataSource(tableView: watchLaterView.watchListTableView, cellProvider: {
            tableView, indexPath, film in
            let cell = tableView.dequeueReusableCell(withIdentifier: WatchLaterTableViewCell.identifier, for: indexPath) as! WatchLaterTableViewCell
            cell.configureCell(with: film)
            return cell
        })
        updateDataSourceWithCachedData()
    }
    
    private func updateDataSourceWithCachedData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Film>()
        snapshot.appendSections([.main])
        if let films = fetchedResultController?.fetchedObjects {
            snapshot.appendItems(films)
        } else {
            print("error with fetching films")
        }
        tableViewDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension WatchLaterViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        updateDataSourceWithCachedData()
    }
}
