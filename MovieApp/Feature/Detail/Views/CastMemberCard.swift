//
//  CastMemberCard.swift
//  MovieApp
//
//  Created by Harshal Patankar on 15/08/26.
//

import SwiftUI

struct CastMemberCard: View {
    
    let member: CastMember
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            imageContent
                .frame(width: 100, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                if let character = member.character, !character.isEmpty {
                    Text(character)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(width: 100, alignment: .topLeading)
        }
        .frame(width: 100, alignment: .top)
    }
    
    @ViewBuilder
    private var imageContent: some View {
        if let url = TMDBImageHelper.profile(path: member.profilePath, width: 185) {
            CachedAsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholderAvatar
                case .empty:
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.systemGray5))
                        .shimmering()
                default:
                    placeholderAvatar
                }
            }
        } else {
            placeholderAvatar
        }
    }
    
    private var placeholderAvatar: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.secondarySystemBackground))
            .overlay {
                VStack(spacing: 4) {
                    Image(systemName: "person.fill")
                        .font(.title2)
                        .foregroundColor(.secondary.opacity(0.7))
                }
            }
    }
}
