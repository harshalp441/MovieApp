//
//  MovieRowSkeleton.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct MovieRowSkeleton: View {

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.systemGray5))
                .frame(width: 75, height: 110)
                .shimmering()

            VStack(alignment: .leading, spacing: 8) {
                EmptyView()
                    .rectangleShimmer(height: 16, cornerRadius: 4)

                EmptyView()
                    .rectangleShimmer(width: 130, height: 16, cornerRadius: 4)

                HStack(spacing: 12) {
                    EmptyView()
                        .rectangleShimmer(width: 45, height: 14, cornerRadius: 4)

                    EmptyView()
                        .rectangleShimmer(width: 50, height: 14, cornerRadius: 4)
                }
                .padding(.top, 2)

                EmptyView()
                    .rectangleShimmer(height: 12, cornerRadius: 4, color: Color(.systemGray6))

                EmptyView()
                    .rectangleShimmer(width: 160, height: 12, cornerRadius: 4, color: Color(.systemGray6))

                Spacer(minLength: 0)
            }

            Spacer()

            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 22, height: 22)
                .shimmering()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List(0..<4, id: \.self) { _ in
        MovieRowSkeleton()
    }
    .listStyle(.plain)
}
