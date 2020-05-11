//
//  CountryCell.swift
//  Covid19Live
//
//  Created by Umut Can on 3.04.2020.
//  Copyright © 2020 Umut Can Alparslan. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
