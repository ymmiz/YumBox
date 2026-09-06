//
//  CategoryViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 24/09/2024.
//
import UIKit
import Alamofire
import SDWebImage
 
class CategoryViewController: UIViewController, UITableViewDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var tableView : UITableView!
    typealias Recipes = [String: [Recipe]]
    var recipes: Recipes = [:]
    var categories: [String] = []
    var imageLinks: [String] = []
    var viewModel = RecipeViewModel()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    
        viewModel.fetchRecipes { result in
            switch result {
            case .success(let (categories, images, recipes)):
                self.categories = categories
                self.imageLinks = images
                self.recipes = recipes
                self.tableView.reloadData()
            case .failure(let error):
                print("Error fetching recipes:", error)
            }
        }
    }
}
 
extension CategoryViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTVC", for: indexPath) as? RecipeTableViewCell {
            cell.recipes = recipes[categories[indexPath.row]] ?? []
            cell.label.text = categories[indexPath.row]
            cell.label.font = UIFont(name: "MondayFeelings", size: 20)
            cell.storyboard = self.storyboard
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "recipeListVC") as? RecipeListViewController {
            vc.recipes = recipes[categories[indexPath.row]] ?? []
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapCollectionViewCell(in tableViewCell: RecipeTableViewCell, indexPath: IndexPath, recipe: Recipe) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "recipeVC") as! RecipeViewController
        newViewController.recipe = recipe
        navigationController?.pushViewController(newViewController, animated: true)
    }
}
