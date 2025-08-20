//
//  CommentsSheetView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import SwiftUI

public struct CommentsSheetView: View {
    let comments: [VehicleComment]

    public var body: some View {
        VStack(alignment: .leading) {
            Text("Comments")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            if comments.isEmpty {
                Spacer()
                Text("No comments yet...")
                    .font(.body)
                    .fontWeight(.regular)
                    .frame(alignment: .center)
                Spacer()
            }

            List(comments, id: \.id) { comment in
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top) {
                        AsyncImage(url: URL(string: comment.userImageUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()

                        }
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())

                    Text(comment.comment)
                        .font(.body)
                        .fontWeight(.regular)
                        .padding(.horizontal, 12)
                    }

                    HStack {
                        Spacer() 
                        
                        Text(comment.createdAt.toDateString())
                            .font(.caption)
                            .foregroundStyle(.secondary) 
                    }
                }
                .padding()
                .cardModifier()
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .background(.clear)
            .listStyle(.plain)
        }
    }
}
