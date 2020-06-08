//
//  covidVC.swift
//  Covid19Live
//
//  Created by Umut Can on 2.04.2020.
//  Copyright © 2020 Umut Can Alparslan. All rights reserved.
//

import Alamofire
import SDWebImage
import SwiftyJSON
import GoogleMobileAds
import UIKit

struct CovidStruct {
    let cases: Int
    let deaths: Int
    let recovered: Int
    let active: Int
    let updated: Int
    let test: Int
    let affectedCountries: Int

    init(json: [String: Any]) {
        cases = json["cases"] as? Int ?? -1
        deaths = json["deaths"] as? Int ?? -1
        recovered = json["recovered"] as? Int ?? -1
        active = json["active"] as? Int ?? -1
        updated = json["updated"] as? Int ?? -1
        test = json["tests"] as? Int ?? -1
        affectedCountries = json["affectedCountries"] as? Int ?? -1
    }
}

class covidVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GADInterstitialDelegate {
    @IBOutlet var totalCases: UILabel!
    @IBOutlet var totalDeaths: UILabel!
    @IBOutlet var totalRecovered: UILabel!
    @IBOutlet var totalActive: UILabel!
    @IBOutlet var affectedCountries: UILabel!
    @IBOutlet var totalTest: UILabel!
    @IBOutlet var live: UILabel!

    @IBOutlet var tableView: UITableView!
    @IBOutlet var globalView: UIView!

    var countryName = [String]()
    var countryFlag = [String]()
    var countryCases = [String]()
    var countryTodayCases = [String]()
    var countryDeaths = [String]()
    var countryTodayDeaths = [String]()
    var countryRecovered = [String]()
    var countryActive = [String]()
    var countryCritical = [String]()
    var countryTest = [String]()

    var toolBar = UIToolbar()
    let picker: UIPickerView = UIPickerView()

    let pickerData = ["Cases", "Alpahabetical"]

    var countryUrl = "https://disease.sh/v2/countries?sort=cases&allowNull=false"
    var timer = Timer()
    
    var interstitial: GADInterstitial!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        getAll()
        getCountry()
        scheduledTimerWithTimeInterval()
        live.alpha = 1.0
        picker.delegate = self as UIPickerViewDelegate
        picker.dataSource = self as UIPickerViewDataSource
        interstitial = createAndLoadInterstitial()
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2463606159232961/1215513865")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      interstitial = createAndLoadInterstitial()
    }

    @objc func liveLabel() {
        if live.alpha == 0.0 {
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
        let jsonUrlString = "https://corona.lmao.ninja/v2/all"
        guard let url = URL(string: jsonUrlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                let covid = CovidStruct(json: json)
                let largeCases = covid.cases
                let largeDeaths = covid.deaths
                let largeRecovered = covid.recovered
                let largeActive = covid.active
                let largeAffected = covid.affectedCountries
                let largeTest = covid.test

                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

                let formattedCases = numberFormatter.string(from: NSNumber(value: largeCases))
                let formattedDeaths = numberFormatter.string(from: NSNumber(value: largeDeaths))
                let formattedRecovered = numberFormatter.string(from: NSNumber(value: largeRecovered))
                let formattedActive = numberFormatter.string(from: NSNumber(value: largeActive))
                let formattedTest = numberFormatter.string(from: NSNumber(value: largeTest))
                let formattedAffected = numberFormatter.string(from: NSNumber(value: largeAffected))

                DispatchQueue.main.async {
                    self.totalCases.text = "Total Cases: ".localized() + "\(formattedCases ?? "")"
                    self.totalDeaths.text = "Total Deaths: ".localized() + "\(formattedDeaths ?? "")"
                    self.totalRecovered.text = "Total Recovered: ".localized() + "\(formattedRecovered ?? "")"
                    self.totalActive.text = "Total Active: ".localized() + "\(formattedActive ?? "")"
                    self.totalTest.text = "Total Test: ".localized() + "\(formattedTest ?? "")"
                    self.affectedCountries.text = "Affected Countries: ".localized() + "\(formattedAffected ?? "")"
                }
            } catch let jsonErr {
                print(jsonErr)
            }

        }.resume()
    }

    func getCountry() {
        countryName.removeAll(keepingCapacity: false)
        countryFlag.removeAll(keepingCapacity: false)
        countryCases.removeAll(keepingCapacity: false)
        countryTodayCases.removeAll(keepingCapacity: false)
        countryDeaths.removeAll(keepingCapacity: false)
        countryTodayDeaths.removeAll(keepingCapacity: false)
        countryRecovered.removeAll(keepingCapacity: false)
        countryActive.removeAll(keepingCapacity: false)
        countryCritical.removeAll(keepingCapacity: false)
        countryTest.removeAll(keepingCapacity: false)
        AF.request(countryUrl, method: .get, encoding: JSONEncoding.default, headers: [:]).responseJSON { countryRes in
            let status = countryRes.response?.statusCode
            if status == 200 {
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
                        let casesPerOneMillion = country["tests"].intValue

                        let largeCases = cases
                        let largeTodayCases = todayCases
                        let largeDeaths = deaths
                        let largeTodayDeaths = todayDeaths
                        let largeRecovered = recovered
                        let largeActive = active
                        let largeCritical = critical
                        let largeCasesPerOneMillion = casesPerOneMillion

                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal

                        let formattedCases: String = numberFormatter.string(from: NSNumber(value: largeCases))!
                        let formattedTodayCases: String = numberFormatter.string(from: NSNumber(value: largeTodayCases))!
                        let formattedDeaths: String = numberFormatter.string(from: NSNumber(value: largeDeaths))!
                        let formattedTodayDeaths: String = numberFormatter.string(from: NSNumber(value: largeTodayDeaths))!
                        let formattedRecovered: String = numberFormatter.string(from: NSNumber(value: largeRecovered))!
                        let formattedActive: String = numberFormatter.string(from: NSNumber(value: largeActive))!
                        let formattedCritical: String = numberFormatter.string(from: NSNumber(value: largeCritical))!
                        let formattedCasesPerOneMillion: String = numberFormatter.string(from: NSNumber(value: largeCasesPerOneMillion))!

                        let worldFlag = "https://raw.githubusercontent.com/NovelCOVID/API/master/assets/flags/unknow.png"
                        if name != "World" && flag != worldFlag {
                            self.countryName.append(name)
                            self.countryFlag.append(flag)
                            self.countryCases.append(formattedCases)
                            self.countryTodayCases.append(formattedTodayCases)
                            self.countryDeaths.append(formattedDeaths)
                            self.countryTodayDeaths.append(formattedTodayDeaths)
                            self.countryRecovered.append(formattedRecovered)
                            self.countryActive.append(formattedActive)
                            self.countryCritical.append(formattedCritical)
                            self.countryTest.append(formattedCasesPerOneMillion)
                            self.tableView.reloadData()
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }

    @IBAction func sort(_ sender: Any) {
        picker.backgroundColor = UIColor.init(red: 57/255, green: 62/255, blue: 70/255, alpha: 1)
        picker.setValue(UIColor.white, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        view.addSubview(picker)
        toolBar = UIToolbar(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 35))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        toolBar.items = [UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        view.addSubview(toolBar)
    }

    @objc func onDoneButtonTapped() {
        getCountry()
        view.endEditing(true)
        picker.resignFirstResponder()
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let row = pickerData[row]
       return row
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerData[row] == "Cases" {
            countryUrl = "https://disease.sh/v2/countries?sort=cases&allowNull=false"
        } else {
            countryUrl = "https://disease.sh/v2/countries?allowNull=false"
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
        
        if count == 1 || count == 6 || count == 11 {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
        }
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
        vc?.casesPerOneMillion = countryTest[indexPath.row]
        navigationController?.pushViewController(vc!, animated: true)
        count += 1
    }
}

extension String {
    func localized(with comment: String = "") -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}
