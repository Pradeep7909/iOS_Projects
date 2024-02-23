//
//  DashBoardViewController.swift
//  Arfof Demo
//
//  Created by Guest on 12/18/23.
//

import UIKit
import DGCharts

class DashBoardViewController: UIViewController{

    
    @IBOutlet weak var todayView: CustomView!
    @IBOutlet weak var weeklyView: CustomView!
    @IBOutlet weak var monthlyView: CustomView!
    @IBOutlet weak var yearlyView: CustomView!
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    @IBOutlet weak var monthlyLabel: UILabel!
    @IBOutlet weak var yearlyLabel: UILabel!
    
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestures()
        getChartData()
        barChartView.delegate = self
        
    }
    
    
    func addGestures(){
        let todayTap = UITapGestureRecognizer(target: self, action: #selector(todayTapped))
        todayView.addGestureRecognizer(todayTap)
        let weeklyTap = UITapGestureRecognizer(target: self, action: #selector(weeklyTapped))
        weeklyView.addGestureRecognizer(weeklyTap)
        let monthlyTap = UITapGestureRecognizer(target: self, action: #selector(monthlyTapped))
        monthlyView.addGestureRecognizer(monthlyTap)
        let yearlyTap = UITapGestureRecognizer(target: self, action: #selector(yearlyTapped))
        yearlyView.addGestureRecognizer(yearlyTap)
    }
    
    @objc func todayTapped(){
        clearColorOfView()
        setColorOfCurrentView(view: todayView, label: todayLabel)
    }
    @objc func weeklyTapped(){
        clearColorOfView()
        setColorOfCurrentView(view: weeklyView, label: weeklyLabel)
    }
    @objc func monthlyTapped(){
        clearColorOfView()
        setColorOfCurrentView(view: monthlyView, label: monthlyLabel)
    }
    @objc func yearlyTapped(){
        clearColorOfView()
        setColorOfCurrentView(view: yearlyView, label: yearlyLabel)
    }
    
    func clearColorOfView(){
        todayView.backgroundColor = UIColor.systemGray6
        weeklyView.backgroundColor = UIColor.systemGray6
        monthlyView.backgroundColor = UIColor.systemGray6
        yearlyView.backgroundColor = UIColor.systemGray6
        
        todayLabel.textColor = UIColor.black
        weeklyLabel.textColor = UIColor.black
        monthlyLabel.textColor = UIColor.black
        yearlyLabel.textColor = UIColor.black
    }
    func setColorOfCurrentView(view: UIView, label : UILabel){
        view.backgroundColor = K_PURPLE_COLOR
        label.textColor = UIColor.white
    }
    
    func getChartData() {
        //only for now
        setupBarChart()
        setupLineChart()
        
        
        let apiURL = URL(string: "http://3.140.254.146:1338/order-dashboard?start=1703183400000&end=1703183400000")!

        // Created URL request
        var request = URLRequest(url: apiURL)
        
        // token provided for authentication
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NjVhZTIxZTA2OGU5MDNkN2FlZmMxYyIsImVtYWlsIjoiZWRhQG1haWxpbmF0b3IuY29tIiwiaXNzdWVkIjoiMjAyMy0xMi0xOVQxMjo1MzoyOFoiLCJpYXQiOjE3MDI5OTA0MDh9.AXqIMmhKTAR-OJOcQ6qkP7gp5xvqrJsajPBhqcRcTqA"
        
        //authorization header
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        // Create a URLSession data task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check for a successful response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Not an HTTP response")
                return
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")

            // Check if there is data
            guard let data = data else {
                print("Error: No data received")
                return
            }

            // Convert data to a string (you might need to parse JSON here)
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response   : \(dataString)")
            } else {
                print("Error: Unable to convert data to string")
            }
        }

        // Start the data task
        task.resume()
    }
    func convertTimestampToDate(_ timestamp: Int, to format: String) -> String {
        var myVal = Int()
        let intValue:Int64 = 10000000000
        if(timestamp/Int(truncatingIfNeeded: intValue) == 0){
            myVal = timestamp
        }else {
            myVal = timestamp/1000
        }
        let date = Date(timeIntervalSince1970: TimeInterval(myVal))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

// for line chart....
extension DashBoardViewController: AxisValueFormatter, ChartViewDelegate{
    // for line chart data
    func setupLineChart() {
        // Add data entries
        let values: [ChartDataEntry] = [
            ChartDataEntry(x: 1.0, y: 2000),
            ChartDataEntry(x: 2.0, y: 5000),
            ChartDataEntry(x: 3.0, y: 6000),
            ChartDataEntry(x: 4.0, y: 8000),
            ChartDataEntry(x: 5.0, y: 5000),
            ChartDataEntry(x: 6.0, y: 4000),
            ChartDataEntry(x: 7.0, y: 2000),
            ChartDataEntry(x: 8.0, y: 8000),
            ChartDataEntry(x: 9.0, y: 5000),
            ChartDataEntry(x: 10.0, y: 4000),
            ChartDataEntry(x: 11.0, y: 2000),
            ChartDataEntry(x: 12.0, y: 5000),
            ChartDataEntry(x: 13.0, y: 4000),
            ChartDataEntry(x: 14.0, y: 2000),
            ChartDataEntry(x: 15.0, y: 8000),
            ChartDataEntry(x: 16.0, y: 5000),
            ChartDataEntry(x: 17.0, y: 4000),
            ChartDataEntry(x: 18.0, y: 2000),
            ChartDataEntry(x: 20.0, y: 5000),
            ChartDataEntry(x: 21.0, y: 4000),
            ChartDataEntry(x: 22.0, y: 2000),
          
            // Add more entries as needed
        ]

        // Create a LineChartDataSet
        let dataSet = LineChartDataSet(entries: values, label: "sales")
        
        // Customize line color
        dataSet.setColors(UIColor(hex: 0x713C75 ) , .blue)
        dataSet.isDrawLineWithGradientEnabled = true
        dataSet.gradientPositions = [0, 8000]
        
        
        dataSet.drawCirclesEnabled = false // Remove circles
        dataSet.mode = .cubicBezier // Make the line curve
        dataSet.lineWidth = 5
    
        dataSet.highlightColor = .clear
        dataSet.drawCircleHoleEnabled = true
        dataSet.drawValuesEnabled = false

        // Create a LineChartData object
        let data = LineChartData(dataSet: dataSet)

        // Set data to the chart
        lineChartView.data = data

        // Customize xAxis
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = true
        lineChartView.xAxis.valueFormatter = self
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.labelTextColor = .systemGray
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.granularityEnabled = true

        
        // for spaceing between graph and and all corner include left side label axis
        lineChartView.xAxis.spaceMin = 0.5
        lineChartView.xAxis.spaceMax = 0.5

        // Customize leftAxis (Y-axis)
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.leftAxis.valueFormatter = self
        lineChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.labelTextColor = .systemGray


        // Hide the rightAxis (optional)
        lineChartView.rightAxis.enabled = false
        
        // Hide the description label
        lineChartView.chartDescription.enabled = false
        
        // Disable pinch zoom gesture
        lineChartView.pinchZoomEnabled = false
        lineChartView.doubleTapToZoomEnabled = false
    
        // Hide color shown in bottomleft side of chart
        lineChartView.legend.enabled = false
        
        // spacing for chart
        lineChartView.setExtraOffsets(left: 10, top: 0, right: 10, bottom: 10)
        
        //other config
        lineChartView.scaleXEnabled = false
        lineChartView.scaleYEnabled = false
        
        // Set the maximum visible range to 7 bars
        lineChartView.setVisibleXRangeMaximum(8.0)
        
        // Refresh chart
        lineChartView.notifyDataSetChanged()
    }
    
    func setupBarChart(){
        // Set up the chart
        let entries = [BarChartDataEntry(x: 1.0, y: 76),
                       BarChartDataEntry(x: 2.0, y: 68),
                       BarChartDataEntry(x: 3.0, y: 110),
                       BarChartDataEntry(x: 4.0, y: 83),
                       BarChartDataEntry(x: 5.0, y: 118),
                       BarChartDataEntry(x: 6.0, y: 180),
                       BarChartDataEntry(x: 7.0, y: 115),
                       BarChartDataEntry(x: 8.0, y: 68),
                       BarChartDataEntry(x: 9.0, y: 110),
                       BarChartDataEntry(x: 10.0, y: 83),
                       BarChartDataEntry(x: 11.0, y: 118),
                       BarChartDataEntry(x: 12.0, y: 180),
                       BarChartDataEntry(x: 13.0, y: 115)
                    ]

        print("barGraphEntries: \(entries)")
        let dataSet = BarChartDataSet(entries: entries, label: "")
        dataSet.colors = [UIColor.systemGray6]
        // Set the color for the selected bar
        // Customize the appearance of the selected bar
        dataSet.highlightColor = UIColor(hex: 0x713C75) // Set the color for the selected bar
        dataSet.highlightAlpha = 1.0 //
        dataSet.valueFont = UIFont.systemFont(ofSize: 12)
        dataSet.valueTextColor = .black
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)

        //object created
        let data = BarChartData(dataSet: dataSet)
        
        barChartView.data = data
        
        
        //Animation bars (bar go up for value with 2 second time)
        barChartView.animate(xAxisDuration: 0.0, yAxisDuration: 2.0, easingOption: .easeInCubic)
        
        //xAxis
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawLabelsEnabled = true
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        barChartView.xAxis.drawAxisLineEnabled = false
        barChartView.xAxis.spaceMin = 0.5
        barChartView.xAxis.spaceMax = 0.5
        barChartView.xAxis.labelTextColor = .systemGray

        
        // more manage xAxis label when more data skip  some point according
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.valueFormatter = self
        
        
        
        // Enable scrolling and dragging
        barChartView.setScaleEnabled(true)
        barChartView.dragEnabled = true
        
        //eftAxis (Y-axis)
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.leftAxis.labelFont = UIFont.systemFont(ofSize: 12)
        barChartView.leftAxis.drawAxisLineEnabled = false
        
        // Hide color shown in bottomleft side of chart
        barChartView.legend.enabled = false
        
        // Hide the rightAxis.
        barChartView.rightAxis.enabled = false
        
        // Adjust the axis Minimum start from 0
        barChartView.leftAxis.axisMinimum = 0
        
        // Disable gesture
        barChartView.pinchZoomEnabled = false
        barChartView.doubleTapToZoomEnabled = false
        
        // spacing for chart
        barChartView.extraRightOffset = 10
        barChartView.extraBottomOffset = 10
        barChartView.extraLeftOffset = 10
        
        
        //to display inside bar
        barChartView.drawValueAboveBarEnabled = false
        
        // Set the maximum visible range to 7 bars
        barChartView.setVisibleXRangeMaximum(8.0)
    }
    
    func groupBars(fromX: Double, groupSpace: Double, barSpace: Double){

    }
    
    func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        if axis is XAxis {
            //X-axis labels as "Apr1," "Apr2"
            var day = "Apr " + String(Int(value))
            print(day)
            return day
           
        } else {
            //Y-axis labels as "2k", "4k"
            return String(Int(value/1000)) + "k"
        }
    }
    
    func drawDataSet(context: CGContext, dataSet: BarChartDataSet, index: Int){
        let bezirePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 30, height: 150), cornerRadius: 15)
        context.drawPath(using: .fill)
    }
}


