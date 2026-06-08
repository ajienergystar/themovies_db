//
//  GenreChipView.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

final class GenreChipView: UIView {

    private let label = UILabel()

    init(name: String) {
        super.init(frame: .zero)
        label.text = name
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppTheme.chipBackground
        layer.cornerRadius = 12

        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .label

        addSubview(label)
        label.useAutoLayout()
        label.pinToSuperview(edges: .all, padding: UIEdgeInsets(
            top: LayoutSpacing.extraSmall,
            left: LayoutSpacing.small,
            bottom: LayoutSpacing.extraSmall,
            right: LayoutSpacing.small
        ))
    }
}
