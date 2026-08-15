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
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color(.systemGray5))
                        .frame(height: 28)
                        .frame(maxWidth: 240)
                        .shimmering()
                }
                
                // Badges (Rating, Runtime, Year)
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 26)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 75, height: 26)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        .frame(width: 65, height: 26)
                }
                .shimmering()
                
                // Genre Pills
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { _ in
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(width: 70, height: 28)
                    }
                }
                .shimmering()
            }
            .padding(.horizontal)
            
            // 3. Storyline Section (Card-specific shimmer)
            VStack(alignment: .leading, spacing: 10) {
                Text("Storyline")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let overview = initialMovie?.overview, !overview.isEmpty {
                    Text(overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(height: 14)
                            .frame(maxWidth: .infinity)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(height: 14)
                            .frame(maxWidth: .infinity)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(width: 220, height: 14)
                    }
                    .shimmering()
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
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray5))
                                        .frame(width: 85, height: 12)
                                    
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray6))
                                        .frame(width: 65, height: 10)
                                }
                                .frame(width: 100, alignment: .topLeading)
                            }
                            .frame(width: 100, alignment: .top)
                            .shimmering()
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
