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
    
    var dataCount = [String]()
    
    var dataName = ["Cases", "Today Cases", "Deaths", "Today Deaths", "Recovered", "Active", "Critical", "Total Tests"]
    
    
    @IBOutlet weak var chartBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = .white
        self.navigationItem.titleView = navTitleWithImageAndText(titleText: " \(countryName)")
        tableView.layer.cornerRadius = 10
        chartBtn.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        dataCount = ["\(self.cases)", "\(self.todayCases)", "\(self.deaths)","\(todayDeaths)","\(recovered)","\(active)","\(critical)","\(casesPerOneMillion)"]
        tableView.reloadData()
        tableView.separatorColor = .white
        
    }
    
    func navTitleWithImageAndText(titleText: String) -> UIView {
        
        // Creates a new UIView
        let titleView = UIView()
        
        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        
        // Creates the image view
        let image = UIImageView()
        image.sd_setImage(with: URL(string: countryFlag), placeholderImage: UIImage(named: "loading"))
        
        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Adds both the label and image view to the titleView
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()
        
        return titleView
        
    }
    
    @IBAction func goCharts(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChartsData") as? ChartsData
        vc?.country = countryName
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension CountryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let singleCountry = tableView.dequeueReusableCell(withIdentifier: "SingleCountry", for: indexPath) as! singleCountryCell
        singleCountry.dataCount.text = dataCount[indexPath.row]
        singleCountry.dataName.text = dataName[indexPath.row]
        return singleCountry
    }

}
