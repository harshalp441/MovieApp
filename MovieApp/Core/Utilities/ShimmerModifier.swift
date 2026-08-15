//
//  ShimmerModifier.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {

    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    let width = geo.size.width
                    let height = geo.size.height

                    LinearGradient(
                        stops: [
                            .init(color: Color.clear, location: 0.0),
                            .init(color: Color.white.opacity(0.45), location: 0.5),
                            .init(color: Color.clear, location: 1.0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: width, height: height)
                    .offset(x: phase * width)
                }
            )
            .mask(content)
            .clipped()
            .onAppear {
                phase = -1
                withAnimation(
                    .linear(duration: 1.25)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        modifier(ShimmerModifier())
    }
}
