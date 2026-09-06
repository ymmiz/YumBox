//
//  TableViewCell.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 23/09/2024.
//

import UIKit
import SDWebImage
 
class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(imageLink: String, name: String) {
        if let imageURL = URL(string: imageLink){
            img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            img.sd_imageIndicator?.startAnimatingIndicator()
            img.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "empty-image"), options: .continueInBackground, completed: nil)
            img.contentMode = .scaleToFill
            label.font = UIFont(name: "MondayFeelings", size: 18)
            label.text = name
        } else {
            print("Invalid URL")
            img.image = UIImage(named: "empty-image")
        }
    }
}
