//
//  RecipeViewModel.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import Foundation
import Alamofire
import UIKit
 
class RecipeViewModel {
    func fetchRecipes(completion: @escaping (Result<([String], [String], [String: [Recipe]]), Error>) -> Void) {
        let url = "https://freaks.dev/recipes.json"
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let recipeResponses = try JSONDecoder().decode([RecipeResponse].self, from: data)
                    let categories = recipeResponses.map { $0.category }
                    let images = recipeResponses.map { $0.image }
                    var recipesDict: [String: [Recipe]] = [:]
                    for recipeResponse in recipeResponses {
                        recipesDict[recipeResponse.category] = recipeResponse.recipes
                    }
                    completion(.success((categories, images, recipesDict)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadFavourites(forKey key: String) -> [Recipe]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let decoder = JSONDecoder()
                let favourites = try decoder.decode([Recipe].self, from: data)
                return favourites
            } catch {
                print("Failed to load favourites: \(error)")
            }
        }
        return nil
    }
    
    func saveFavourites(_ favourites: [Recipe], forKey key: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favourites)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save favourites: \(error)")
        }
    }
    
    func uploadToWebsite(title: String, fileExtension: String, imageData: Data) {
        let url = "https://recipes.freaks.dev/api/recipes"
        let parameters: [String: String] = [
            "title": title
        ]
        AF.upload(multipartFormData: { multipartFormData in
            let mimeType = fileExtension == "png" ? "image/png" : "image/jpeg"
            let fileName = "image.\(fileExtension)"
            multipartFormData.append(imageData, withName: "image", fileName: fileName, mimeType: mimeType)
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
        }, to: url).response { response in
            if let error = response.error {
                print("Error uploading image: \(error)")
                return
            }
            if let error = response.error {
                print("Error uploading image: \(error)")
                return
            }
        }
    }
}
