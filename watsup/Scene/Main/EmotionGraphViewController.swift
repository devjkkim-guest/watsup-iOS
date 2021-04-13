//
//  EmotionGraphViewController.swift
//  watsup
//
//  Created by Jeongkyun Kim on 2021/04/14.
//

import UIKit
import Charts

class EmotionGraphViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lineChartView.noDataText = "No Emotion Data."
        
        var entries = [ChartDataEntry]()
        for i in 0..<10 {
            let yVal = Int.random(in: 0...100)
            let entry = ChartDataEntry(x: Double(i), y: Double(yVal), icon: EmotionType.getEmotion(rawValue: yVal).rawValue.image)
            entries.append(entry)
        }
        let dataSet = LineChartDataSet(entries: entries, label: "emotion data")
        lineChartView.data = LineChartData(dataSet: dataSet)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
