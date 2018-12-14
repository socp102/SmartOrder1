//
//  AdminChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/11/26.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts

class AdminLineChartViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var chartViewA: LineChartView!
    @IBOutlet weak var chartViewB: LineChartView!
    
    
    // 折線圖
    var chartView = LineChartView()
    // 所有節點顏色 All point color
    var circleColors: [UIColor] = []
    
    
    var chartDataA: [String: Int] = [:]
    var chartDataB: [String: Int] = [:]
    
    var type:[String] = []
    var timePart:String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("time : \(timePart)")
        setChart(dataPoints: chartDataA, chartView: chartViewA)
        setChart(dataPoints: chartDataB, chartView: chartViewB)
        
    }
    
    func setChart (dataPoints: [String: Int],chartView: LineChartView) {
        
        var dataEntries: [ChartDataEntry] = []
        var tempName:[String] = []
        
        //若沒有資料，顯示的文字
        //        LineChartViewA.noDataText = "You need to provide data for the chart."
        
        var count = 0
        for (k, v) in dataPoints {
            let dataEntry = ChartDataEntry(x: Double(count), y: Double(v))
            print("x \(Double(v))  y \(Double(count))")
            tempName.append(k)
            dataEntries.append(dataEntry)
            count += 1
            circleColors.append(.cyan)
        }
        
        
        
        
        //        // 隨機產生20個數字  產生第一條則折線數據
        //        var dataEntries = [ChartDataEntry]()
        //        for i in 0 ..< 8 {
        //            let y = arc4random() % 100
        //            let entry = ChartDataEntry.init(x: Double(i),y: Double(y))
        //            dataEntries.append(entry)
        //            // 節點預設藍(青
        //            circleColors.append(.cyan)
        //        }
        
        
        // 資料封裝 圖表走勢 左下圖表名
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        
        chartView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)          // 背景色
        chartView.noDataText = "暫無數據"        // 無數據時提示字串
        chartView.chartDescription?.text = timePart   //折線圖描述文字(右下文字
        chartView.chartDescription?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)    // color
        
        chartView.scaleYEnabled = false     // 取消y軸縮放
        chartView.legend.textColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)     // 左下圖表名顏色
        //x轴、y轴方向动画一起播放，持续时间都是1秒
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1)
        // 折線圖 一條線
        let chartData = LineChartData(dataSets: [chartDataSet])
        chartDataSet.colors = [#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)] // 線條顏色 多個顏色會交替使用
        chartDataSet.lineWidth = 3 // 線條寬(預設1
        //设置折点颜色
        chartDataSet.circleColors = circleColors
        
        chartView.xAxis.labelPosition = .bottom // x軸文字置底
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: tempName)
        
        
        // 設置折線圖數據
        if chartViewA.data == nil {
            chartViewA.data = chartData
            
        } else {
            chartViewB.data = chartData
        }
    }
    
    //折线上的点选中回调
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry,
                            highlight: Highlight) {
        print("选中了一个数据")
        
        //将选中的数据点的颜色改成黄色
        var chartDataSet = LineChartDataSet()
        chartDataSet = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        let values = chartDataSet.values
        let index = values.index(where: {$0.x == highlight.x})  //获取索引
        chartDataSet.circleColors = circleColors //还原
        chartDataSet.circleColors[index!] = .orange
        
        //重新渲染表格
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    //折线上的点取消选中回调
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("取消选中的数据")
        
        //还原所有点的颜色
        var chartDataSet = LineChartDataSet()
        chartDataSet = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        chartDataSet.circleColors = circleColors
        
        //重新渲染表格
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
}
