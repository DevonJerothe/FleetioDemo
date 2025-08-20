//
//  ContactDetailsView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

public struct ContactDetailsView: View {
    let contactDetails: ContactModel
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: URL(string: contactDetails.defaultImageUrl ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundStyle(.secondary)
                    }
                    .frame(width: 75, height: 75)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(contactDetails.name ?? "")
                            .font(.headline)
                            .fontWeight(.bold)

                        Text("\(contactDetails.jobTitle ?? "") \(contactDetails.employee ?? false ? "- Employee" : "")")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Details")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 0) {
                        DetailRow(label: "Email", value: contactDetails.email)
                        Divider()
                        DetailRow(label: "Phone", value: contactDetails.homePhoneNumber)
                        Divider()
                        DetailRow(label: "Mobile", value: contactDetails.mobilePhoneNumber)
                        Divider()
                        DetailRow(label: "Address", value: contactDetails.streetAddress)
                    }
                    .cardModifier()
                }
            }
            .padding()
        }
        .navigationTitle(contactDetails.name ?? "Contact Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
