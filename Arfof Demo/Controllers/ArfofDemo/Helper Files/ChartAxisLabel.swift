//
//  chartAxisLabel.swift
//  Arfof Demo
//
//  Created by Guest on 12/25/23.
//

import Foundation


import DGCharts

class BarChartFormatter: NSObject, AxisValueFormatter {
    var values: [String] = []

    init(values: [String]) {
        super.init()
        self.values = values
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if index >= 0, index < values.count {
            return values[index]
        }
        return ""
    }
}
