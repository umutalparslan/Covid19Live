//
//  ChartsData.swift
//  Covid19Live
//
//  Created by Umut Can on 12.05.2020.
//  Copyright © 2020 Umut Can Alparslan. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit
import TinyConstraints

class ChartsData: UIViewController {
    
    @IBOutlet var chartView: UIView!

    var casesChart = [CGFloat]()
    var dayChart = [String]()

    var country: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\(country) Chart View"

        let historicalUrl = "https://disease.sh/v2/historical/\(country)?lastdays=7"

        AF.request(historicalUrl, method: .get, encoding: JSONEncoding.default, headers: [:]).responseJSON { historicalData in
            let status = historicalData.response?.statusCode
            if status == 200 {
                let date: Date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "M/d/yy"
                let dateFormatterTR = DateFormatter()
                dateFormatterTR.dateFormat = "dd/MM/yy"

                
                switch historicalData.result {
                case let .success(s):
                    let historicalJSON = JSON(s)

                    for n in -7 ... -1 {
                        let cases = historicalJSON["timeline"]["cases"]["\(dateFormatter.string(from: date.addingTimeInterval(TimeInterval(n * 24 * 60 * 60))))"].doubleValue
                        self.casesChart.append(CGFloat(cases))
                        self.dayChart.append("\(dateFormatterTR.string(from: date.addingTimeInterval(TimeInterval(n * 24 * 60 * 60))))")
                    }
                    let barChart = self.setBarChart()
                    self.chartView.addSubview(barChart)
                    self.chartView.width(to: self.chartView)
                    self.chartView.heightToWidth(of: self.chartView)
                    self.chartView.centerInSuperview()
                    self.chartView.transform = CGAffineTransform(rotationAngle: .pi / 2)

                case let .failure(er):
                    print(er)
                }
            }
        }
        
            }
    

    private func setBarChart() -> PNBarChart {
        let barChart = PNBarChart(frame: CGRect(x: 0, y: 0, width: 480, height: 250))
        barChart.backgroundColor = UIColor(red: 34 / 255, green: 40 / 255, blue: 49 / 255, alpha: 1)
        barChart.animationType = .Waterfall
        barChart.labelMarginTop = 5.0
        barChart.xLabels = dayChart
        barChart.yValues = casesChart
        barChart.strokeChart()
        return barChart
    }
}

extension Date {
    static func changeDaysBy(days: Int) -> Date {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: currentDate)!
    }
}
