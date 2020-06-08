//
//  singleCountryCell.swift
//  Covid19Live
//
//  Created by Umut Can on 8.06.2020.
//  Copyright © 2020 Umut Can Alparslan. All rights reserved.
//

import UIKit

class singleCountryCell: UITableViewCell {

    @IBOutlet weak var dataName: UILabel!
    @IBOutlet weak var dataCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
