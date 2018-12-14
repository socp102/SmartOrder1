//
//  AdminChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/11/26.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts

class AdminChartViewController: UIViewController {

    // 折線圖
    var chartView = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 折線圖組件對象
        chartView.frame = CGRect(x: 20, y: 80, width: self.view.bounds.width - 30, height: self.view.bounds.height / 2)
        
        self.view.addSubview(chartView)
        
        
        chartView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)          // 背景色
        chartView.noDataText = "暫無數據"        // 無數據時提示字串
        chartView.chartDescription?.text = "考試成績"   //折線圖描述文字
        chartView.chartDescription?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)    // color
        
        chartView.scaleYEnabled = false     // 取消y軸縮放
        
        
        
        
        // 隨機產生20個數字
        var dataEntries = [ChartDataEntry]()
        for i in 0 ..< 20 {
            let y = arc4random() % 100
            let entry = ChartDataEntry.init(x: Double(i),y: Double(y))
            dataEntries.append(entry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "圖表 one")
        // 折線圖 一條線
        let chartData = LineChartData(dataSets: [chartDataSet])
        chartDataSet.colors = [#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)] // 線條
        chartDataSet.lineWidth = 2 // 線條寬(預設1
        
        
        // 設置折線圖數據
        chartView.data = chartData
    }
    

}
