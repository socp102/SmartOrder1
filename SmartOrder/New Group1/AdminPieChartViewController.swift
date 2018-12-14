//
//  AdminPieChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/12/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts

class AdminPieChartViewController: UIViewController {

    @IBOutlet weak var chartViewA: PieChartView!
    @IBOutlet weak var chartViewB: PieChartView!
    
    
    var chartDataA: [String: Int] = [:] // commodityCountData
    var chartDataB: [String: Int] = [:]
    
    var type: [String] = []
    var timePart: String = ""
    
    // 餅狀圖
//    var chartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("xxx \(timePart)")
        setChart(dataPoints: chartDataA, chartView: chartViewA)
        setChart(dataPoints: chartDataB, chartView: chartViewB)

    }
    
    func setChart (dataPoints: [String: Int], chartView: PieChartView) {
        
        var dataEntries: [PieChartDataEntry] = []

        
        // 前五排序 使用A資料
        
        if chartDataB.count == 0 {
            let result = chartDataA.sorted { (str1, str2) -> Bool in
                return str1.1 > str2.1
            }
            for (k, v) in result {
                if chartDataB.count < 5 {
                    chartDataB[k] = v
                }
            }
            print("xxx \(chartDataB)")
        }
        
        
        
        
        for (k, v) in dataPoints {
            //設定X.Y座標分別顯示的東西
            let dataEntry = PieChartDataEntry(value: Double(v), label: k)
            //把個別的dataEntry的資料，儲存至dataEntries中
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        // 設置顏色
        chartDataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
        
        
        chartView.chartDescription?.text = timePart   //折線圖描述文字(右下文字
        chartView.chartDescription?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)    // color
        // 折線第一段起始位置（越大離圓越遠
        chartDataSet.valueLinePart1OffsetPercentage = 0.8
        chartDataSet.valueLinePart1Length = 0.6 // 折線第一段長度比例
        chartDataSet.valueLinePart2Length = 0.3 // 折線第二段長度比例
        chartDataSet.xValuePosition = .outsideSlice // 標籤文字顯示在圓外
        chartDataSet.yValuePosition = .outsideSlice //數字顯示在圓外
        
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData.setValueTextColor(.black)// 文字黑色
        
        //一個一個延遲顯現的特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        //彈一下特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        
        if chartView == chartViewB {
        chartView.maxAngle = 270 //整个扇形占2/3圆
        chartView.rotationAngle = 135 //旋转角度让扇面左右对称
        }
        // 設置餅狀圖數據
        chartView.data = chartData
    }
    
    
}
