//
//  ContentView.swift
//  ProductCatalog
//
//  Created by RUPALI VERMA on 15/04/25.
//

import SwiftUI

struct CatalogView: View {
    @StateObject private var viewModel = CatalogViewModel()
    @State private var filteredProducts: [Product] = []
    @State private var showFilters = false
    @State private var isShowingFavorites: Bool = false

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        
                        Text("\(filteredProducts.count) results")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding([.top, .horizontal])
                        
                        List(filteredProducts) { product in
                            HStack(alignment: .center, spacing: 12) {
                                
                                AsyncImage(url: URL(string: product.images.first ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.title)
                                        .font(.headline)
                                    Text(product.category.name)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(String(format: "$%.2f", product.price))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.toggleFavorite(id: product.id)
                                    updateFilteredProducts()
                                }) {
                                    Image(systemName: viewModel.isFavorite(id: product.id) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
                
            }
            .navigationTitle("Products")
            .toolbar {
                Button("Filter") { showFilters = true }
            }
            .toolbar {
                Button(isShowingFavorites ? "Show All" : "Favorites") {
                    isShowingFavorites.toggle()
                    updateFilteredProducts()
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterView(viewModel: viewModel, filteredProducts: $filteredProducts)
            }
            .onAppear {
                viewModel.fetchProducts()
                filteredProducts = viewModel.products
            }
            .onChange(of: viewModel.products) {
                filteredProducts = viewModel.products
            }
        }
    }

    private func updateFilteredProducts() {
        if isShowingFavorites {
            filteredProducts = viewModel.products.filter { viewModel.isFavorite(id: $0.id) }
        } else {
            filteredProducts = viewModel.products
        }
    }
}


struct FilterView: View {
    @ObservedObject var viewModel: CatalogViewModel
    @Binding var filteredProducts: [Product]
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedCategory: String? = nil
    @State private var selectedPriceMax: Double? = nil
    
    let categories = ["All", "Clothes", "Electronics", "Furniture", "Shoes", "Miscellaneous"]
    let priceOptions: [Double?] = [nil, 50, 100]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category")) {
                    ForEach(categories, id: \.self) { category in
                        HStack {
                            Text(category)
                            Spacer()
                            if selectedCategory == category || (category == "All" && selectedCategory == nil) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCategory = (category == "All") ? nil : category
                        }
                    }
                }
                
                Section(header: Text("Price")) {
                    ForEach(priceOptions, id: \.self) { price in
                        HStack {
                            Text(priceText(for: price))
                            Spacer()
                            if selectedPriceMax == price {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedPriceMax = price
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .destructiveAction) {
                    Button("Clear") {
                        clearFilters()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        applyFilters()
                    }
                    .bold()
                }
            }
        }
    }
    
    private func applyFilters() {
        filteredProducts = viewModel.filter(category: selectedCategory, priceMax: selectedPriceMax)
        dismiss()
    }
    
    private func clearFilters() {
        selectedCategory = nil
        selectedPriceMax = nil
        filteredProducts = viewModel.filter(category: nil, priceMax: nil)
        dismiss()
    }
    
    func priceText(for price: Double?) -> String {
        switch price {
        case nil: return "Any"
        case 50: return "Up to $50"
        case 100: return "Up to $100"
        default: return "$\(Int(price!))"
        }
    }
}




