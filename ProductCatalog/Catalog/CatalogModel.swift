//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by RUPALI VERMA on 15/04/25.
//

import Foundation

// MARK: - Model
struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let category: Category
    let images: [String]
    
    struct Category: Codable, Equatable {
        let name: String
        
        static func == (lhs: Category, rhs: Category) -> Bool {
            lhs.name == rhs.name
        }
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}
