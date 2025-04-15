//
//  CatalogViewModel.swift
//  ProductCatalog
//
//  Created by RUPALI VERMA on 15/04/25.
//

import Foundation

class CatalogViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var favorites: [Int: Bool] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
            self.networkService = networkService
            
            if let savedFavorites = UserDefaults.standard.dictionary(forKey: "favorites") as? [String: Bool] {
                self.favorites = savedFavorites.reduce(into: [Int: Bool]()) { result, pair in
                    if let id = Int(pair.key) {
                        result[id] = pair.value
                    }
                }
            }
        }
    
    func fetchProducts() {
           guard let url = URL(string: "https://api.escuelajs.co/api/v1/products") else {
               errorMessage = "Invalid URL"
               return
           }
           
           isLoading = true
           
           networkService.fetchData(from: url) { [weak self] (result: Result<[Product], Error>) in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let products):
                       self?.products = products
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                   }
               }
           }
       }
    
    func filter(category: String?, priceMax: Double?) -> [Product] {
        var filtered = products

        if let category = category, category != "All" {
            filtered = filtered.filter { product in
                product.category.name == category
            }
        }

        if let priceMax = priceMax {
            filtered = filtered.filter { product in
                priceMax == 100 ?  product.price > 50 : product.price <= priceMax
            }
        }

        return filtered
    }

    
    func toggleFavorite(id: Int) {
       
        favorites[id] = !(favorites[id] ?? false)
        
        let stringFavorites = favorites.reduce(into: [String: Bool]()) { result, pair in
            result[String(pair.key)] = pair.value
        }
        
        UserDefaults.standard.set(stringFavorites, forKey: "favorites")
        
        objectWillChange.send()
    }

    
    func isFavorite(id: Int) -> Bool {
        favorites[id] ?? false
    }
}
