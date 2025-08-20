//
//  ContactTileView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

struct ContactTileView: View {
    @Environment(NavigationViewModel.self) var navManager
    
    let contact: ContactModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AsyncImage(url: URL(string: contact.defaultImageUrl ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text(contact.name ?? "")
                        .font(.subheadline)
                    Text(contact.employeeNumber ?? "")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text(contact.email ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .contentShape(Rectangle())
        .onTapGesture {
            navManager.navigate(to: .contactDetails(contact: contact))
        }
    }
}
