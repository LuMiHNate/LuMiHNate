//
//  SongCell.swift
//  HZ
//
//  Created by Matthew Soto on 5/19/21.
//

import UIKit

class SongCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artists: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var musicPic: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
