//
//  covidVC.swift
//  Covid19Live
//
//  Created by Umut Can on 2.04.2020.
//  Copyright © 2020 Umut Can Alparslan. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SDWebImage
import UIKit

struct CovidStruct {
    let cases: Int
    let deaths: Int
    let recovered: Int
    let active: Int
    let updated: Int
    let affectedCountries: Int

    init(json: [String: Any]) {
        cases = json["cases"] as? Int ?? -1
        deaths = json["deaths"] as? Int ?? -1
        recovered = json["recovered"] as? Int ?? -1
        active = json["active"] as? Int ?? -1
        updated = json["updated"] as? Int ?? -1
        affectedCountries = json["affectedCountries"] as? Int ?? -1
    }
}

class covidVC: UIViewController {
    @IBOutlet var totalCases: UILabel!
    @IBOutlet var totalDeaths: UILabel!
    @IBOutlet var totalRecovered: UILabel!
    @IBOutlet var totalActive: UILabel!
    @IBOutlet var affectedCountries: UILabel!
    @IBOutlet weak var live: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var globalView: UIView!
    
    var countryName = [String]()
    var countryFlag = [String]()
    var countryCases = [String]()
    var countryTodayCases = [String]()
    var countryDeaths = [String]()
    var countryTodayDeaths = [String]()
    var countryRecovered = [String]()
    var countryActive = [String]()
    var countryCritical = [String]()
    var countryCasesPerOneMillion = [String]()
    var countryDeathsPerOneMillion = [String]()
    
    
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        globalView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        getAll()
        getCountry()
        scheduledTimerWithTimeInterval()
        self.live.alpha = 1.0
    }
    
    @objc func liveLabel() {
        if self.live.alpha == 0.0 {
            UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseIn, animations: {
                self.live.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 1.5, delay: 0.5, options: .curveEaseOut, animations: {
                self.live.alpha = 0.0
            })
        }
    }

    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(covidVC.getAll), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(covidVC.liveLabel), userInfo: nil, repeats: true)
    }

    @objc func getAll() {
        print("Data Updated")
        let jsonUrlString = "https://corona.lmao.ninja/v2/all"
        guard let url = URL(string: jsonUrlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                let covid = CovidStruct(json: json)
                let largeCases = covid.cases
                let largeDeaths = covid.deaths
                let largeRecovered = covid.recovered
                let largeActive = covid.active
                let largeAffected = covid.affectedCountries

                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

                let formattedCases = numberFormatter.string(from: NSNumber(value: largeCases))
                let formattedDeaths = numberFormatter.string(from: NSNumber(value: largeDeaths))
                let formattedRecovered = numberFormatter.string(from: NSNumber(value: largeRecovered))
                let formattedActive = numberFormatter.string(from: NSNumber(value: largeActive))
                let formattedAffected = numberFormatter.string(from: NSNumber(value: largeAffected))

                DispatchQueue.main.async {
                    self.totalCases.text = "Total Cases: ".localized() + "\(formattedCases ?? "")"
                    self.totalDeaths.text = "Total Deaths: ".localized() + "\(formattedDeaths ?? "")"
                    self.totalRecovered.text = "Total Recovered: ".localized() + "\(formattedRecovered ?? "")"
                    self.totalActive.text = "Total Active: ".localized() + "\(formattedActive ?? "")"
                    self.affectedCountries.text = "Affected Countries: ".localized() + "\(formattedAffected ?? "")"
                    
                }
            } catch let jsonErr {
                print(jsonErr)
            }

        }.resume()
    }

    func getCountry() {
        
        let countryUrl = "https://corona.lmao.ninja/v2/countries"
        
        AF.request(countryUrl, method: .get, encoding: JSONEncoding.default, headers: [:]).responseJSON { (countryRes) in
            let status = countryRes.response?.statusCode
            if (status == 200) {
                switch countryRes.result {
                case let .success(value):
                    let countryJSON = JSON(value)
                    for country in countryJSON.array! {
                        
                        let name = country["country"].stringValue
                        let flag = country["countryInfo"]["flag"].stringValue
                        let cases = country["cases"].intValue
                        let todayCases = country["todayCases"].intValue
                        let deaths = country["deaths"].intValue
                        let todayDeaths = country["todayDeaths"].intValue
                        let recovered = country["recovered"].intValue
                        let active = country["active"].intValue
                        let critical = country["critical"].intValue
                        let casesPerOneMillion = country["casesPerOneMillion"].intValue
                        let deathsPerOneMillion = country["deathsPerOneMillion"].intValue
                        
                        let largeCases = cases
                        let largeTodayCases = todayCases
                        let largeDeaths = deaths
                        let largeTodayDeaths = todayDeaths
                        let largeRecovered = recovered
                        let largeActive = active
                        let largeCritical = critical
                        let largeCasesPerOneMillion = casesPerOneMillion
                        let largeDeathsPerOneMillion = deathsPerOneMillion

                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal

                        let formattedCases:String = numberFormatter.string(from: NSNumber(value: largeCases))!
                        let formattedTodayCases:String = numberFormatter.string(from: NSNumber(value: largeTodayCases))!
                        let formattedDeaths:String = numberFormatter.string(from: NSNumber(value: largeDeaths))!
                        let formattedTodayDeaths:String = numberFormatter.string(from: NSNumber(value: largeTodayDeaths))!
                        let formattedRecovered:String = numberFormatter.string(from: NSNumber(value: largeRecovered))!
                        let formattedActive:String = numberFormatter.string(from: NSNumber(value: largeActive))!
                        let formattedCritical:String = numberFormatter.string(from: NSNumber(value: largeCritical))!
                        let formattedCasesPerOneMillion:String = numberFormatter.string(from: NSNumber(value: largeCasesPerOneMillion))!
                        let formattedDeathsPerOneMillion:String = numberFormatter.string(from: NSNumber(value: largeDeathsPerOneMillion))!
                        
                        let worldFlag = "https://raw.githubusercontent.com/NovelCOVID/API/master/assets/flags/unknow.png"
                        if (name != "World" && flag != worldFlag){
                            self.countryName.append(name)
                            self.countryFlag.append(flag)
                            self.countryCases.append(formattedCases)
                            self.countryTodayCases.append(formattedTodayCases)
                            self.countryDeaths.append(formattedDeaths)
                            self.countryTodayDeaths.append(formattedTodayDeaths)
                            self.countryRecovered.append(formattedRecovered)
                            self.countryActive.append(formattedActive)
                            self.countryCritical.append(formattedCritical)
                            self.countryCasesPerOneMillion.append(formattedCasesPerOneMillion)
                            self.countryDeathsPerOneMillion.append(formattedDeathsPerOneMillion)
                        self.tableView.reloadData()
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}

extension covidVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let countryCell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        countryCell.countryFlag.sd_setImage(with: URL(string: countryFlag[indexPath.row]), placeholderImage: UIImage(named: "loading"))
        countryCell.countryName.text = countryName[indexPath.row]
        countryCell.countryName.textColor = .white
        countryCell.accessoryView?.backgroundColor = .white
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CountryVC") as? CountryVC
        vc?.countryName = countryName[indexPath.row]
        vc?.countryFlag = countryFlag[indexPath.row]
        vc?.cases = countryCases[indexPath.row]
        vc?.todayCases = countryTodayCases[indexPath.row]
        vc?.deaths = countryDeaths[indexPath.row]
        vc?.todayDeaths = countryTodayDeaths[indexPath.row]
        vc?.recovered = countryRecovered[indexPath.row]
        vc?.active = countryActive[indexPath.row]
        vc?.critical = countryCritical[indexPath.row]
        vc?.casesPerOneMillion = countryCasesPerOneMillion[indexPath.row]
        vc?.deathsPerOneMillion = countryDeathsPerOneMillion[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension String {
    func localized(with comment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}

