//
//  WatchLaterView.swift
//  MoviesApp
//
//  Created by Павел on 11.01.2025.
//

import UIKit

class WatchLaterView: UIView {
    
    private final let constant: CGFloat = 10
    var onItemSelected: ((IndexPath, UITableView) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Color.backgroundGray
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var watchListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WatchLaterTableViewCell.self, forCellReuseIdentifier: WatchLaterTableViewCell.identifier)
        tableView.backgroundColor = Color.backgroundGray
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func setupUI() {
        addSubview(watchListTableView)
        NSLayoutConstraint.activate([
            watchListTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            watchListTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            watchListTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -constant),
            watchListTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}

extension WatchLaterView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.2,
                           animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
                           completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = .identity
                }
            })
            onItemSelected?(indexPath, tableView)
        }
    }
}
