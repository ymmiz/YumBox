//
//  RecipeTableViewCell.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func didTapCollectionViewCell(in tableViewCell: RecipeTableViewCell, indexPath: IndexPath, recipe: Recipe)
}
 
class RecipeTableViewCell: UITableViewCell, CollectionViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    var storyboard: UIStoryboard?
    weak var delegate: TableViewCellDelegate?
    var recipes: [Recipe] = []
 
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
}
 
extension RecipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recipeCVC", for: indexPath) as? RecipeCollectionViewCell {
            cell.configure(imageURL: recipes[indexPath.item].image, recipe: recipes[indexPath.item].name)
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapCollectionViewCell(in: self, indexPath: indexPath, recipe: recipes[indexPath.item])
    }
 
    func didTapCollectionViewCell(in cell: RecipeCollectionViewCell, recipe: Recipe) {
        if let indexPath = collectionView.indexPath(for: cell) {
            delegate?.didTapCollectionViewCell(in: self, indexPath: indexPath, recipe: recipes[indexPath.item])
        }
    }
}
