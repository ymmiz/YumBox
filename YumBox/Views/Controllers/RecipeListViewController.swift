//
//  RecipeListViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit
import SDWebImage
 
class RecipeListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var recipes: [Recipe] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}
 
extension RecipeListViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? TableViewCell {
            cell.configure(imageLink: recipes[indexPath.row].image, name: recipes[indexPath.row].name)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "recipeVC") as? RecipeViewController {
            vc.recipe = recipes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
