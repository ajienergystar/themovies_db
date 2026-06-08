//
//  LayoutHelper.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

/// Common spacing constants for programmatic layout.
enum LayoutSpacing {
    static let extraSmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let extraLarge: CGFloat = 32
}

/// Helper for more complex programmatic layout operations.
enum LayoutHelper {

    /// Activates a collection of constraints at once.
    static func activate(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.activate(constraints)
    }

    /// Deactivates a collection of constraints at once.
    static func deactivate(_ constraints: [NSLayoutConstraint]) {
        NSLayoutConstraint.deactivate(constraints)
    }

    /// Returns a constraint with the given priority.
    static func constraint(
        _ constraint: NSLayoutConstraint,
        priority: UILayoutPriority
    ) -> NSLayoutConstraint {
        constraint.priority = priority
        return constraint
    }

    /// Embeds a child view in a parent view with optional safe area pinning.
    @discardableResult
    static func embed(
        _ child: UIView,
        in parent: UIView,
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero,
        useSafeArea: Bool = false
    ) -> [NSLayoutConstraint] {
        child.useAutoLayout()
        parent.addSubview(child)

        if useSafeArea {
            return child.pinToSuperviewSafeArea(edges: edges, padding: padding)
        }
        return child.pinToSuperview(edges: edges, padding: padding)
    }

    /// Creates a scroll view with a content view inside, ready for Auto Layout.
    static func makeScrollableContent(
        scrollView: UIScrollView = UIScrollView(),
        contentView: UIView = UIView()
    ) -> (scrollView: UIScrollView, contentView: UIView) {
        scrollView.useAutoLayout()
        contentView.useAutoLayout()

        scrollView.addSubview(contentView)
        contentView.pinToSuperview()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        return (scrollView, contentView)
    }
}
