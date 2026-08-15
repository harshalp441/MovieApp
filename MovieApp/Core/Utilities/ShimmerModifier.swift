//
//  ShimmerModifier.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {

    let duration: Double

    init(duration: Double = 1.25) {
        self.duration = duration
    }

    func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let progress = (time.truncatingRemainder(dividingBy: duration)) / duration
            let center = -0.6 + 2.2 * progress

            content
                .overlay(
                    LinearGradient(
                        stops: [
                            .init(color: .clear, location: 0.0),
                            .init(color: Color.white.opacity(0.45), location: 0.5),
                            .init(color: .clear, location: 1.0)
                        ],
                        startPoint: UnitPoint(x: center - 0.7, y: 0.5),
                        endPoint: UnitPoint(x: center + 0.7, y: 0.5)
                    )
                )
                .mask(content)
                .clipped()
        }
    }
}

// MARK: - Rectangular Shimmer Placeholder Modifier

struct RectangleShimmerModifier: ViewModifier {

    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat
    let color: Color

    init(
        width: CGFloat? = nil,
        height: CGFloat = 16,
        cornerRadius: CGFloat = 4,
        color: Color = Color(.systemGray5)
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.color = color
    }

    func body(content: Content) -> some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(color)
            .frame(height: height)
            .frame(maxWidth: width ?? .infinity, alignment: .leading)
            .shimmering()
    }
}

// MARK: - View Extensions

extension View {
    func shimmering(duration: Double = 1.25) -> some View {
        modifier(ShimmerModifier(duration: duration))
    }

    /// Renders a rectangular shimmer placeholder with subtle continuous corner radius for text and metadata badges
    func rectangleShimmer(
        width: CGFloat? = nil,
        height: CGFloat = 16,
        cornerRadius: CGFloat = 4,
        color: Color = Color(.systemGray5)
    ) -> some View {
        modifier(
            RectangleShimmerModifier(
                width: width,
                height: height,
                cornerRadius: cornerRadius,
                color: color
            )
        )
    }
}
