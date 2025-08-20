//
//  ContactsView.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/18/25.
//

import SwiftUI

struct ContactsView: View {
    @State private var viewModel: ContactsViewModel = ContactsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                // filter bar - just going to be sort order due to time and no menu based filters availabel
                
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.blue)
                    Spacer()
                } else if viewModel.contacts.isEmpty {
                    Text("No Contacts...")
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.contacts, id: \.id) { contact in
                            ContactTileView(contact: contact)
                                .onAppear() {
                                    if contact.id == viewModel.contacts.last?.id {
                                        Task {
                                            await viewModel.loadMoreItems()
                                        }
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Contacts")
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search Contacts..."
            )
            .onSubmit {
                Task {
                    await viewModel.searchItems()
                }
            }
            .onAppear {
                Task {
                    if viewModel.contacts.isEmpty {
                        await viewModel.loadInitialData()
                    }
                }
            }
        }
    }
}
