//
//  FavouriteViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = RecipeViewModel()
    var favourites: [Recipe] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let result = viewModel.loadFavourites(forKey: "favourites") {
            favourites = result
            tableView.reloadData()
        }
    }
}
 
extension FavouriteViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as? TableViewCell {
            cell.configure(imageLink: favourites[indexPath.row].image, name: favourites[indexPath.row].name)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "recipeVC") as? RecipeViewController {
            vc.recipe = favourites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            //present(vc, animated: true)
        }
    }
}
