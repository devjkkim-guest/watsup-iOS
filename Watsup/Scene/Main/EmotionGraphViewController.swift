//
//  EmotionGraphViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/14.
//

import UIKit
import Charts

class EmotionGraphViewController: UIViewController {

    @IBOutlet weak var segmentedRange: UISegmentedControl!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChartView.noDataText = "No Emotion Data."
        
        var entries = [ChartDataEntry]()
        let numbs: [Int] = [40, 45, 10, 12, 16, 12, 22, 24, 40, 48, 25, 50, 60, 70, 80, 70, 50, 55, 57, 40, 32, 30, 20, 30, 20, 50, 40, 70, 20, 40, 50, 90, 70]
        for i in 0..<numbs.count {
            let entry = ChartDataEntry(x: Double(i), y: Double(numbs[i]), icon: nil)
            entries.append(entry)
        }
        let dataSet = LineChartDataSet(entries: entries, label: "emotion data")
        dataSet.mode = .cubicBezier
        dataSet.drawCirclesEnabled = false
        dataSet.drawHorizontalHighlightIndicatorEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.drawVerticalHighlightIndicatorEnabled = false
        dataSet.drawIconsEnabled = false
        dataSet.drawCircleHoleEnabled = false
        dataSet.lineWidth = 4
        dataSet.isDrawLineWithGradientEnabled = true
        dataSet.gradientPositions = EmotionType.allCases.compactMap { $0.getValue() }
        dataSet.colors = EmotionType.allCases.map { $0.getColors() }
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.data = LineChartData(dataSet: dataSet)
        lineChartView.leftAxis.valueFormatter = WUValueFormatter(type: .y)
        lineChartView.xAxis.valueFormatter = WUValueFormatter(type: .x)
        lineChartView.leftAxis.labelFont = .systemFont(ofSize: 14)
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.axisMinimum = -10
        lineChartView.leftAxis.axisMaximum = 110
        lineChartView.leftAxis.axisMinLabels = 5
        lineChartView.leftAxis.axisMaxLabels = 5
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawGridLinesBehindDataEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
    }

}

class WUValueFormatter: AxisValueFormatter {
    enum AxisType {
        case x
        case y
    }
    
    let type: AxisType
    
    init(type: AxisType) {
        self.type = type
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch type {
        case .x:
            switch value {
            case 0..<25:
                return "week 1"
            case 25..<50:
                return "week 2"
            case 50..<75:
                return "week 3"
            case 75..<100:
                return "week 4"
            default:
                return ""
            }
        case .y:
            return EmotionType.getEmotion(rawValue: Int(value)).rawValue
        }
    }
}
