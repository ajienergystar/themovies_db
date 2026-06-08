//
//  MovieListViewController.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class MovieListViewController: UIViewController {

    var presenter: MovieListPresenterProtocol?

    private var movies: [Movie] = []
    private var isFooterLoading = false

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayouts.movieGrid())
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.reuseIdentifier)
        collectionView.register(
            LoadingFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: LoadingFooterView.reuseIdentifier
        )
        return collectionView
    }()

    private let stateView = StateView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.useAutoLayout()

        stateView.useAutoLayout()
        stateView.onRetry = { [weak self] in
            self?.presenter?.retryTapped()
        }

        view.addSubviews(collectionView, stateView)
        collectionView.pinToSuperviewSafeArea()
        stateView.pinToSuperviewSafeArea()
        stateView.isHidden = true
    }
}

extension MovieListViewController: MovieListViewProtocol {
    func setTitle(_ title: String) {
        self.title = title
    }

    func showLoading() {
        stateView.isHidden = false
        collectionView.isHidden = true
        stateView.configure(with: .loading)
    }

    func hideLoading() {
        stateView.isHidden = true
        collectionView.isHidden = false
    }

    func showMovies(_ movies: [Movie]) {
        self.movies = movies
        stateView.isHidden = true
        collectionView.isHidden = false
        collectionView.reloadData()
    }

    func appendMovies(_ movies: [Movie]) {
        let startIndex = self.movies.count
        self.movies.append(contentsOf: movies)
        let indexPaths = (startIndex..<self.movies.count).map { IndexPath(item: $0, section: 0) }
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: indexPaths)
        }
    }

    func showEmpty() {
        stateView.isHidden = false
        collectionView.isHidden = true
        stateView.configure(with: .empty(
            title: "No Movies",
            message: "No movies were found for this genre.",
            systemImage: "film"
        ))
    }

    func showError(_ error: AppError) {
        if movies.isEmpty {
            stateView.isHidden = false
            collectionView.isHidden = true
            stateView.configure(with: .error(error))
        }
    }

    func showFooterLoading(_ isLoading: Bool) {
        isFooterLoading = isLoading
        collectionView.collectionViewLayout.invalidateLayout()
        if let footer = collectionView.supplementaryView(
            forElementKind: UICollectionView.elementKindSectionFooter,
            at: IndexPath(item: 0, section: 0)
        ) as? LoadingFooterView {
            isLoading ? footer.startAnimating() : footer.stopAnimating()
        }
    }
}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviePosterCell.reuseIdentifier,
            for: indexPath
        ) as? MoviePosterCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.item])
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: LoadingFooterView.reuseIdentifier,
                for: indexPath
              ) as? LoadingFooterView else {
            return UICollectionReusableView()
        }
        isFooterLoading ? footer.startAnimating() : footer.stopAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectMovie(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter?.loadNextPageIfNeeded(currentIndex: indexPath.item)
    }
}
