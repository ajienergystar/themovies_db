//
//  UIStackView+Layout.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

extension UIStackView {

    /// Creates a horizontal `UIStackView` with common configuration.
    static func horizontal(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        arrangedSubviews: [UIView] = []
    ) -> UIStackView {
        makeStackView(
            axis: .horizontal,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            arrangedSubviews: arrangedSubviews
        )
    }

    /// Creates a vertical `UIStackView` with common configuration.
    static func vertical(
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        arrangedSubviews: [UIView] = []
    ) -> UIStackView {
        makeStackView(
            axis: .vertical,
            spacing: spacing,
            alignment: alignment,
            distribution: distribution,
            arrangedSubviews: arrangedSubviews
        )
    }

    /// Adds multiple arranged subviews at once.
    @discardableResult
    func addArrangedSubviews(_ views: UIView...) -> Self {
        views.forEach { addArrangedSubview($0) }
        return self
    }

    /// Removes all arranged subviews from the stack.
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    private static func makeStackView(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat,
        alignment: UIStackView.Alignment,
        distribution: UIStackView.Distribution,
        arrangedSubviews: [UIView]
    ) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
