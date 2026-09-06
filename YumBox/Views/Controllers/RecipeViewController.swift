//
//  RecipeViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit
import SDWebImage

class RecipeViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ingredients: UILabel!
    @IBOutlet weak var instructions: UILabel!
    @IBOutlet weak var video: UIButton!
    var recipe: Recipe?
    var favourites: [Recipe] = []
    var viewModel = RecipeViewModel()
    var isFavourite: Bool = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let favButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favouriteClicked))
        navigationItem.rightBarButtonItem = favButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.systemRed
        if let recipe {
            img.image = UIImage(named: recipe.image)
            img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            img.sd_imageIndicator?.startAnimatingIndicator()
            img.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(named: "empty-image"), options: .continueInBackground, completed: nil)
            img.contentMode = .scaleToFill
            name.text = recipe.name
            ingredients.text = recipe.ingredients.joined(separator: "\n")
            instructions.text = recipe.instructions.joined(separator: "\n")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let result = viewModel.loadFavourites(forKey: "favourites") {
            favourites = result
        }
        if let recipe {
            if favourites.contains(where: {$0.name == recipe.name}) {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                isFavourite = true
            } else {
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
        }
    }
    
    @objc func favouriteClicked() {
        isFavourite.toggle()
        if let recipe {
            if isFavourite {
                if !favourites.contains(where: {$0.name == recipe.name}) {
                    favourites.append(recipe)
                    viewModel.saveFavourites(favourites, forKey: "favourites")
                }
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            } else {
                if favourites.contains(where: {$0.name == recipe.name}) {
                    favourites.removeAll(where: {$0.name == recipe.name})
                    viewModel.saveFavourites(favourites, forKey: "favourites")
                }
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
        }
    }
    
    @IBAction func videoClicked(_ sender: UIButton){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "youtube") as? YouTubeViewController {
            vc.videoID = recipe?.videoID ?? ""
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
