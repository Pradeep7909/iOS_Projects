//
//  PlaygroundViewController.swift
//  iOS App
//
//  Created by Qualwebs on 29/01/24.
//

import UIKit
import Firebase

class PlaygroundViewController: UIViewController {
    
    let databaseRef = Database.database().reference().child("users").child("0io1aKH3gxM1KY0jZWyQG2KVJKE2")
    let U_BASE = "http://3.140.254.146:1338/"
    let U_GET_EXPLORE = "products/page="
    let url = "http://3.140.254.146:1338/products/page=1"
    let U_GET_PROMOTIONS = "promotions"
    var imagePath =  ""
    let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1NzE3NWNjMGZjNDRiMjQzODQ3MzlkNyIsImVtYWlsIjoiY2hhYXJ2aUBtYWlsaW5hdG9yLmNvbSIsImlzc3VlZCI6IjIwMjQtMDEtMzBUMDk6NTg6MzZaIiwiaWF0IjoxNzA2NjA4NzE2fQ.Z4KDNKw9H4nnPvY_eETgK2ESslYcBCSpRRYqCey1RZg"

    
    @IBOutlet weak var sampleImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func imageTappedAction(_ sender: Any) {
        showImagePickerOptions()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //1. SerialQueue
        //        exampleSerialQueue()
        //        gcdSerial()
        
        //2. concurrent Queue
        //        exampleConcurrentQueue()
        
        //3. Switch to main dispatch queue
        //        exampleBackToMain()
        
        //4. Operation Queue
        //        operationFramework()
        
        //5. Dispatch Group
        //        dispatchGroup()
        
        //url session
        //        downloadImage()
        //        getData()
                productData()
        
    }
}

//MARK: URL Session
extension PlaygroundViewController{
    func downloadImage(){
        if let url = URL(string: "https://placebear.com/g/200/200") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    // Handle the error
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    // Process the data
                    print("Data received: \(data)")
                    print(data.base64EncodedString())
                    DispatchQueue.main.async {
                        self.sampleImage.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        }
    }
    func getData(){
        print("getData called")
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error{
                print("error : \(error)")
            }
            if let data = data{
                print("Size of data : \(data)")
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(jsonData ?? "No data")
            }
        }
        task.resume()
    }
    
    func productData(){
        let apiURL = URL(string: "http://3.140.254.146:1338/products/page=1")!

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let param = [
            "category": "",
            "subcategory": nil,
            "filters": nil,
            "price": [
                0,
                20000
            ],
            "sort": 1,
            "trending": nil,
            "freeDelivery": nil,
            "isOnSale": true
            
        ] as? [String:Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("Request Body: \(jsonString ?? "")")
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Not an HTTP response")
                return
            }
            print("HTTP Status Code: \(httpResponse.statusCode)")
            guard let data = data else {
                print("Error: No data received")
                return
            }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonData ?? "No data")
        }
        task.resume()
    }
    
    
    
    func uploadImage(fileData: Data?){
        let apiURL = URL(string: "http://3.140.254.146:1338/file")!

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        let clrf = "\r\n"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)")
        body.append(clrf)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"")
        body.append(clrf)
        body.append("Content-Type: image/jpeg")
        body.append(clrf)
        body.append(clrf)
        body.append(fileData!)
        body.append(clrf)
        body.append("--\(boundary)--")
        body.append(clrf)

        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Not an HTTP response")
                return
            }
            print("HTTP Status Code: \(httpResponse.statusCode)")
            // Process the response data
            guard let data = data else {
                print("Error: No data received")
                return
            }
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print(jsonData ?? "No data")
            do {
                // Parse JSON data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let response = json["response"] as? [String: Any],
                   let url = response["url"] as? String {
                    print("Image URL: \(url)")
                    self.imagePath = url
                    self.updateProfile()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        // Start the URLSession task
        task.resume()
    }
    
    
    
    func updateProfile() {
        print("Profile is Updating..")
        let apiURL = URL(string: "http://3.140.254.146:1338/user-update")!

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")


        let param: [String: Any] = [
            "fullName": "Chaarvi Test",
            "gender": 2,
            "dob": "27 Apr 1996",
            "phone": "6266244709",
            "profile": self.imagePath,
            "token": "em2lmvuUH0D9u6XTWqD5Kf:APA91bGaNwEj_VwxB6wQAitCAQsKQK1BFlbNtMn5E7qWuMZOPHF5cwd7LNXV7xICUDDecSQnAKG4r2QaFFVhj72W6ZH0K1mxg4567nqmO7hCICN5M8S1gXOyBfqu_q41bqBwTWsBxPaI",
            "platform": 2
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print("Request Body: \(jsonString ?? "")")
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Handle the server response here
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Not an HTTP response")
                return
            }

            print("HTTP Status Code: \(httpResponse.statusCode)")

            // Process the response data if needed
            if let data = data {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                print(jsonData ?? "No data")
            }
        }
        task.resume()
    }

    
}



//MARK: Concurrency Types
extension PlaygroundViewController{
    // MARK: - Serial Queue
    func exampleSerialQueue() {
        let serialQueue = DispatchQueue(label: "com.kraken.serial")
        serialQueue.async {
            print("SerialQueue test 1")
        }
        serialQueue.async {
            sleep(5) // Sleep execution for 5 sec
            print("SerialQueue test 2")
        }
        serialQueue.sync {
            print("SerialQueue test 3")
        }
        serialQueue.sync {
            print("SerialQueue test 4")
        }
    }
    func gcdSerial(){
        let serialQueue = DispatchQueue(label: "SerialThread", attributes: .concurrent)
        serialQueue.sync {
            self.task1()
        }
        serialQueue.sync {
            self.task2()
        }
    }
    
    // MARK: - Concurrent Queue
    func exampleConcurrentQueue() {
        let concurrentQueue = DispatchQueue.global()
        concurrentQueue.async {
            print("ConcurrentQueue test 1")
        }
        concurrentQueue.async {
            sleep(2) // Sleep execution for 2 sec
            print("ConcurrentQueue test 2")
        }
        concurrentQueue.async {
            sleep(1) // Sleep execution for 1 sec
            print("ConcurrentQueue test 3")
        }
        concurrentQueue.async {
            print("ConcurrentQueue test 4")
        }
    }
    
    // MARK: - Example of Bakckground / Main Thread Switch
    func exampleBackToMain() {
        DispatchQueue.global(qos: .background).async {
            print("DispatchQueue.global Thread name: \(Thread.current.name ?? "none") IsMain: \(Thread.isMainThread) IsMultithread: \(Thread.isMultiThreaded())")
            DispatchQueue.main.async {
                print("DispatchQueue.main Thread name: \(Thread.current.name ?? "none") IsMain: \(Thread.isMainThread) IsMultithread: \(Thread.isMultiThreaded())")
            }
        }
    }
    
    //MARK: ExampleOfOperationQueue
    func operationFramework(){
        print("operation function started")
        print("Thread : \(Thread.current) , Main Thread: \(Thread.isMainThread)")
        let operationQueue = OperationQueue()
        let operation1 = BlockOperation {
            self.task1()
            print("Thread : \(Thread.current) , Main Thread: \(Thread.isMainThread)")
        }
        let operation2 = BlockOperation {
            self.task2()
            print("Thread : \(Thread.current) , Main Thread: \(Thread.isMainThread)")
        }
//        operation1.addDependency(operation2)         //for execution one by one
        operationQueue.addOperations([operation1, operation2], waitUntilFinished: true)
        print("operation function end")
    }
    
    //MARK: Dispatch Group
    func dispatchGroup() {
        let dispatchGroup = DispatchGroup()

        // Task 1
        dispatchGroup.enter()
        DispatchQueue.global().sync {
            self.task1()
            dispatchGroup.leave()
        }

        // Task 2 depends on the completion of Task 1
        dispatchGroup.enter()
        DispatchQueue.global().sync {
            self.task2()
            dispatchGroup.leave()
        }

        // Notify when both tasks are completed
        dispatchGroup.notify(queue: DispatchQueue.main) {
            print("Both tasks completed")
        }
    }
    
    func task1(){
        print("Task 1 has started")
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value else{
                print("error in fetching data")
                return
            }
            print("task 1 completed")
        }
        print("Task 1 has end")
    }
    
    func task2(){
        print("Task 2 has started")
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value else{
                print("error in fetching data")
                return
            }
            print("task 2 completed")
        }
        print("Task 2 has end")
    }
}
