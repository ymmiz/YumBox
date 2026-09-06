//
//  Recipe.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import Foundation
import UIKit

struct Recipe: Codable {
    let name: String
    let image: String
    let ingredients: [String]
    let instructions: [String]
    let videoID: String
}
 
struct RecipeResponse: Codable {
    let category: String
    let image: String
    let recipes: [Recipe]
}

struct SavedRecipe: Codable {
    let name: String
    let imageData: Data
    
    init(name: String, image: UIImage) {
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 0.8) ?? Data()
    }
    
    var image: UIImage? {
        return UIImage(data: imageData)
    }
}

