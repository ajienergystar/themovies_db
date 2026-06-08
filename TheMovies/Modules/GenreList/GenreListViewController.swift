//
//  GenreListViewController.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class GenreListViewController: UIViewController {

    var presenter: GenreListPresenterProtocol?

    private var genres: [Genre] = []

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let stateView = StateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        title = "Genres"
        view.backgroundColor = .systemBackground

        tableView.register(GenreListCell.self, forCellReuseIdentifier: GenreListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 52
        tableView.useAutoLayout()

        stateView.useAutoLayout()
        stateView.onRetry = { [weak self] in
            self?.presenter?.retryTapped()
        }

        view.addSubviews(tableView, stateView)
        tableView.pinToSuperviewSafeArea()
        stateView.pinToSuperviewSafeArea()

        stateView.isHidden = true
    }
}

extension GenreListViewController: GenreListViewProtocol {
    func showLoading() {
        stateView.isHidden = false
        tableView.isHidden = true
        stateView.configure(with: .loading)
    }

    func hideLoading() {
        stateView.isHidden = true
        tableView.isHidden = false
    }

    func showGenres(_ genres: [Genre]) {
        self.genres = genres
        stateView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }

    func showEmpty() {
        stateView.isHidden = false
        tableView.isHidden = true
        stateView.configure(with: .empty(
            title: "No Genres",
            message: "No movie genres are available right now.",
            systemImage: "film.stack"
        ))
    }

    func showError(_ error: AppError) {
        stateView.isHidden = false
        tableView.isHidden = true
        stateView.configure(with: .error(error))
    }
}

extension GenreListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: GenreListCell.reuseIdentifier,
            for: indexPath
        ) as? GenreListCell else {
            return UITableViewCell()
        }
        cell.configure(with: genres[indexPath.row].name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectGenre(at: indexPath.row)
    }
}
