//
//  PicturePostCell.swift
//  HZ
//
//  Created by Matthew Soto on 5/23/21.
//

import UIKit

class PicturePostCell: UITableViewCell {

    @IBOutlet weak var imagePostView: UIImageView!
    @IBOutlet weak var usernameImagePostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
