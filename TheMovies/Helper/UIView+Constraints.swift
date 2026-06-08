//
//  UIView+Constraints.swift
//  TheMovies
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

extension UIView {

    // MARK: - Setup

    /// Disables `translatesAutoresizingMaskIntoConstraints` to enable Auto Layout.
    @discardableResult
    func useAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    /// Adds a subview and optionally disables its autoresizing mask.
    @discardableResult
    func addSubview(_ view: UIView, useAutoLayout: Bool) -> Self {
        addSubview(view)
        if useAutoLayout {
            view.useAutoLayout()
        }
        return self
    }

    /// Adds multiple subviews at once.
    @discardableResult
    func addSubviews(_ views: UIView...) -> Self {
        views.forEach { addSubview($0) }
        return self
    }

    // MARK: - Pin to Superview

    /// Pins the view to the superview edges with optional padding.
    @discardableResult
    func pinToSuperview(
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let superview else { return [] }

        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Pins the view to the superview's safe area.
    @discardableResult
    func pinToSuperviewSafeArea(
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let superview else { return [] }
        let safeArea = superview.safeAreaLayoutGuide

        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: safeArea.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -padding.right))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    // MARK: - Pin to Layout Guide

    /// Pins the view to a `UILayoutGuide` (e.g. safe area).
    @discardableResult
    func pin(
        to layoutGuide: UILayoutGuide,
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -padding.right))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    // MARK: - Pin to Another View

    /// Pins the view to another view.
    @discardableResult
    func pin(
        to view: UIView,
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding.right))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Pins the top of this view to the bottom of another view.
    @discardableResult
    func pinBelow(_ view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing)
        constraint.isActive = true
        return constraint
    }

    /// Pins the bottom of this view to the top of another view.
    @discardableResult
    func pinAbove(_ view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = bottomAnchor.constraint(equalTo: view.topAnchor, constant: -spacing)
        constraint.isActive = true
        return constraint
    }

    /// Pins the trailing edge of this view to the leading edge of another view.
    @discardableResult
    func pinToLeading(of view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -spacing)
        constraint.isActive = true
        return constraint
    }

    /// Pins the leading edge of this view to the trailing edge of another view.
    @discardableResult
    func pinToTrailing(of view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: spacing)
        constraint.isActive = true
        return constraint
    }

    // MARK: - Center

    /// Centers the view inside its superview.
    @discardableResult
    func centerInSuperview(offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        guard let superview else { return [] }

        let constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)
        ]

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    @discardableResult
    func centerXInSuperview(offset: CGFloat = 0) -> NSLayoutConstraint? {
        guard let superview else { return nil }

        let constraint = centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func centerYInSuperview(offset: CGFloat = 0) -> NSLayoutConstraint? {
        guard let superview else { return nil }

        let constraint = centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset)
        constraint.isActive = true
        return constraint
    }

    // MARK: - Size

    /// Sets the width and/or height of the view.
    @discardableResult
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        if let width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Sets a square size (width = height).
    @discardableResult
    func setSquareSize(_ size: CGFloat) -> [NSLayoutConstraint] {
        setSize(width: size, height: size)
    }

    /// Sets the view's aspect ratio.
    @discardableResult
    func setAspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio)
        constraint.isActive = true
        return constraint
    }

    // MARK: - Dimension Equal to Another View

    @discardableResult
    func matchWidth(to view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func matchHeight(to view: UIView, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: constant)
        constraint.isActive = true
        return constraint
    }
}
