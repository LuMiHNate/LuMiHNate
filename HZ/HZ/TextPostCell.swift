//
//  TextPostCell.swift
//  HZ
//
//  Created by Matthew Soto on 5/23/21.
//

import UIKit

class TextPostCell: UITableViewCell {

    @IBOutlet weak var textFieldTextPostLabel: UILabel!
    @IBOutlet weak var usernameTextPostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
