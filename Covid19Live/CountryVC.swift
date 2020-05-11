//
//  CountryVC.swift
//  Covid19Live
//
//  Created by Umut Can on 4.04.2020.
//  Copyright © 2020 Umut Can Alparslan. All rights reserved.
//

import UIKit
import SDWebImage

class CountryVC: UIViewController {
    
    var countryName:String = ""
    var countryFlag:String = ""
    var cases:String = ""
    var todayCases:String = ""
    var deaths:String = ""
    var todayDeaths:String = ""
    var recovered:String = ""
    var active:String = ""
    var critical:String = ""
    var casesPerOneMillion:String = ""
    var deathsPerOneMillion:String = ""
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var todayCasesLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var todayDeathsLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var casesPerLabel: UILabel!
    @IBOutlet weak var deathsPerLabel: UILabel!
    
    @IBOutlet weak var countryView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        countryView.layer.cornerRadius = 10
        countryFlagImage.sd_setImage(with: URL(string: countryFlag), placeholderImage: UIImage(named: "loading"))
        countryNameLabel.text = countryName
        casesLabel.text = "Cases: \(cases)"
        todayCasesLabel.text = "Today Cases: \(todayCases)"
        deathsLabel.text = "Deaths: \(deaths)"
        todayDeathsLabel.text = "Today Deaths: \(todayDeaths)"
        recoveredLabel.text = "Recovered: \(recovered)"
        activeLabel.text = "Active: \(active)"
        criticalLabel.text = "Critical: \(critical)"
        casesPerLabel.text = "Cases Per One Million: \(casesPerOneMillion)"
        deathsPerLabel.text = "Deaths Per One Million: \(deathsPerOneMillion)"
    }
    
    

}
