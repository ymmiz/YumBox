//
//  RecipeCollectionViewCell.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit
import SDWebImage
 
protocol CollectionViewCellDelegate: AnyObject {
    func didTapCollectionViewCell(in cell: RecipeCollectionViewCell, recipe: Recipe)
}
 
class RecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    var recipe: Recipe?
    weak var delegate: CollectionViewCellDelegate?
 
    @IBAction func cellTapped(_ sender: UIButton) {
        delegate?.didTapCollectionViewCell(in: self, recipe: recipe!)
    }
    
    func configure(imageURL: String, recipe: String) {
        if let imageURL = URL(string: imageURL){
            img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            img.sd_imageIndicator?.startAnimatingIndicator()
            img.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "empty-image"), options: .continueInBackground, completed: nil)
            img.contentMode = .scaleToFill
            label.font = UIFont(name: "MondayFeelings", size: 20)
            label.text = recipe
        } else {
            print("Invalid URL")
            img.image = UIImage(named: "empty-image")
        }
    }
}
