//
//  DetailSkeletonView.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct DetailSkeletonView: View {

    var initialMovie: Movie? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 1. Hero Player Placeholder (Card-specific shimmer)
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemGray5))
                .aspectRatio(16 / 9, contentMode: .fit)
                .shimmering()
                .padding(.horizontal)

            // 2. Header Info (Card-specific shimmer)
            VStack(alignment: .leading, spacing: 12) {
                if let title = initialMovie?.title {
                    Text(title)
                        .font(.title.weight(.bold))
                        .foregroundColor(.primary)
                } else {
                    EmptyView()
                        .rectangleShimmer(width: 240, height: 28, cornerRadius: 4)
                }

                // Badges with inline logos (Rating, Runtime, Year) - Rectangular Shimmers
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 26)
                        .shimmering()

                    EmptyView()
                        .rectangleShimmer(width: 65, height: 22, cornerRadius: 4)

                    EmptyView()
                        .rectangleShimmer(width: 50, height: 22, cornerRadius: 4)
                }

                // Genre Items - Rectangular Shimmers (Flow Layout)
                FlowLayout(horizontalSpacing: 8, verticalSpacing: 8) {
                    ForEach(0..<3, id: \.self) { _ in
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(width: 70, height: 24)
                            .shimmering()
                    }
                }
            }
            .padding(.horizontal)

            // 3. Storyline Section (Card-specific shimmer)
            VStack(alignment: .leading, spacing: 10) {
                Text("Storyline")
                    .font(.headline)
                    .foregroundColor(.primary)

                if let overview = initialMovie?.overview, !overview.isEmpty {
                    Text(overview)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        EmptyView()
                            .rectangleShimmer(height: 14, cornerRadius: 4, color: Color(.systemGray6))

                        EmptyView()
                            .rectangleShimmer(height: 14, cornerRadius: 4, color: Color(.systemGray6))

                        EmptyView()
                            .rectangleShimmer(width: 220, height: 14, cornerRadius: 4, color: Color(.systemGray6))
                    }
                }
            }
            .padding(.horizontal)

            // 4. Top Cast Section (Fixed 3 items with card-specific shimmer)
            VStack(alignment: .leading, spacing: 12) {
                Text("Top Cast")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 12) {
                        ForEach(0..<3, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: 6) {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.systemGray5))
                                    .frame(width: 100, height: 130)
                                    .shimmering()

                                VStack(alignment: .leading, spacing: 2) {
                                    EmptyView()
                                        .rectangleShimmer(width: 85, height: 12, cornerRadius: 4)

                                    EmptyView()
                                        .rectangleShimmer(width: 65, height: 10, cornerRadius: 4, color: Color(.systemGray6))
                                }
                                .frame(width: 100, alignment: .topLeading)
                            }
                            .frame(width: 100, alignment: .top)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    DetailSkeletonView()
}
