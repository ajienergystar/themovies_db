//
//  CollectionViewLayouts.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

enum CollectionViewLayouts {

    static func movieGrid() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(280)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(280)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(AppTheme.gridSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = AppTheme.gridSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: AppTheme.gridSpacing,
            leading: AppTheme.gridSpacing,
            bottom: AppTheme.gridSpacing,
            trailing: AppTheme.gridSpacing
        )

        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [footer]

        return UICollectionViewCompositionalLayout(section: section)
    }
}
