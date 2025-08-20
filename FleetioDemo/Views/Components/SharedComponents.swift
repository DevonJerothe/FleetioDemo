//
//  SharedComponents.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/19/25.
//

import SwiftUI

// moving all shared components into a single file to clean up the main views.

struct StatusBadge: View {
    let name: String
    let color: Color
    
    var body: some View {
            HStack {
                Text(name)
                    .font(.caption2)
                    .fontWeight(.medium)
                
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.secondarySystemBackground).opacity(0.9))
            .clipShape(Capsule())
    }
}

struct FilterItem: View {
    let defaultText: String
    let selectedText: String?
    let selectedColor: Color
    let icon: String?

    var body: some View {
        HStack {
            if let icon {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            }
            Text(selectedText ?? defaultText)
                .font(.subheadline)
            
            Image(systemName: "chevron.down")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
        }
        .padding(6)
        .background(selectedText == nil ? .clear : selectedColor.opacity(0.6))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.systemGray), lineWidth: 1)
        )
    }
}

struct InfoCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct DetailRow: View {
    let label: String
    let value: String?
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value ?? "Not Set")
                .fontWeight(.medium)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

struct StatusCard: View {
    let title: String
    let count: Int
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
            
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
