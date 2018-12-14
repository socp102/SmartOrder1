//
//  AdminBarChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/12/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts


class AdminBarChartViewController: UIViewController {
    

    var chartDataA: [String: Int] = [:]
    var chartDataB: [String: Int] = [:]   
    
    var type: [String] = []
    var timePart: String = ""
    
    @IBOutlet weak var chartViewA: BarChartView!
    @IBOutlet weak var chartViewB: BarChartView!
    
    
    
    
//    let months =
//        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//    let unitsSold =
//        [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("xxx \(commodityCountData)")
        
        setChart(dataPoints: chartDataA, chartView: chartViewA)
        setChart(dataPoints: chartDataB, chartView: chartViewB)
        
    }
    
    func setChart(dataPoints: [String: Int], chartView: BarChartView) {
        
        //若沒有資料，顯示的文字
        chartViewA.noDataText = "You need to provide data for the chart."

        //存放資料的陣列，型別是BarChartDataEntry.
        var dataEntries: [BarChartDataEntry] = []
        var tempName:[String] = []

//        //迴圈，來載入每筆資料內容
//        for i in 0..<dataPoints.count {
//            //設定X.Y座標分別顯示的東西
//            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
//            print("x: \(Double(i))\n y: \(values[i])")
//            //把個別的dataEntry的資料，儲存至dataEntries中
//            dataEntries.append(dataEntry)
//        }
        
        var count = 0
        for (k, v) in dataPoints {
            let dataEntry = BarChartDataEntry(x: Double(count), y: Double(v))
            print("x \(Double(v))  y \(Double(count))")
            tempName.append(k)
            dataEntries.append(dataEntry)
            count += 1
        }
        
        
        //顯示的資料之內容與名稱（左下角所顯示的）
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        //把dataSet轉換成可顯示的BarChartData
        let chartData = BarChartData(dataSet: chartDataSet)
        //指定剛剛連結的myView要顯示的資料為charData
        if chartViewA.data == nil {
            chartViewA.data = chartData

        } else {
            chartViewB.data = chartData
        }
//        print(chartViewA.data)
//        print(chartViewB.data)



        

        //改變chartDataSet的顏色，此為橘色
        //chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]

        // 柱寬0.7
//        chartData.barWidth = 0.7
        chartView.chartDescription?.text = timePart   //折線圖描述文字(右下文字
        chartView.chartDescription?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)    // color
        
        // x軸敘述
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: tempName)

        //改變chartDataSet為彩色
        chartDataSet.colors = ChartColorTemplates.colorful()

        //標籤換到下方
        chartView.xAxis.labelPosition = .bottom

        //改變barChartView的背景顏色
        chartView.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)

        //一個一個延遲顯現的特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

        //彈一下特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)

        //設立界線
//        let limit = ChartLimitLine(limit: 10.0, label: "Target")
//        myView.rightAxis.addLimitLine(limit)

        
    
        
        
    }
    
}
