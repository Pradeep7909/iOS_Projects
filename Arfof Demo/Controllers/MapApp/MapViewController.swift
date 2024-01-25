//
//  MapViewController.swift
//  Arfof Demo
//
//  Created by Qualwebs on 19/01/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    
    //MARK: Variables
    let locationManager = CLLocationManager()
    var matches: [MKMapItem] = []
    var searchTimer: Timer?
    var destinationAddressCoordinate: CLLocationCoordinate2D?
    var lastDrawnTimer: Timer?
    var previousUserLocation : CLLocationCoordinate2D?
    var destinationName: String = ""
    let minSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    let maxSpan = MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0)
    
    
    
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var textFieldForAddress: UITextField!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var backSearchView: UIView!
    @IBOutlet weak var directionButtonView : UIView!
    @IBOutlet weak var staticSearchTextField: UITextField!
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cancelOverlayView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMap()
        
    }
    
    //MARK: IBOutlet Actions
    @IBAction func myLocationButon(_ sender: Any) {
        if let userLocation = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1100, longitudinalMeters: 1100)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func searchStaticViewTapped(_ sender: Any) {
        openBackgroungSearchView()
    }
    
    
    @IBAction func searchButton(_ sender: Any) {
        //        searchLocations()
    }
    
    @IBAction func textFieldChanges(_ sender: Any) {
        searchTimer?.invalidate()
        //searchLocations() after a delay
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(searchLocations), userInfo: nil, repeats: false)
    }
    
    @IBAction func searchViewBGClose(_ sender: Any) {
        closeBackgroungSearchView()
    }
    
    @IBAction func directionPolylinebutton(_ send: Any){
        self.mapView.removeOverlays(self.mapView.overlays)
        removeAllOverlays {
            self.mapThis(destinationCord: self.destinationAddressCoordinate!, makeEntirePolylineVisible: true)
            self.staticSearchTextField.text = self.destinationName
            self.cancelOverlayView.isHidden = false
            self.lastDrawnTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateRoute), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func cancelOverlaysButton(_ sender: Any) {
        removeAllOverlays{}
    }
    
    @IBAction func zoomInButton(_ sender: Any) {
        zoomMap(byFactor: 0.5)
    }
    
    
    
    @IBAction func zoomOutButtonAction(_ sender: Any) {
        zoomMap(byFactor: 2)
    }
    
    
    //MARK: Functions
    func setUpMap(){
//        showUserLocation()
        
        setCustomAnnotation()
        
        
        hideKeyboardOnTap(view: mapView)
        hideKeyboardOnTap(view: backSearchView)
        directionButtonView.isHidden = true
        cancelOverlayView.isHidden = true
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.isRotateEnabled = true
        mapView.mapType = .hybrid
        mapView.isUserInteractionEnabled = true
        // Make a new compass
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20).isActive = true
        compassButton.topAnchor.constraint(equalTo: staticSearchTextField.bottomAnchor, constant: 10).isActive = true
        
        // for selecting location on map by tap
        if #available(iOS 16.0, *) {
            mapView.selectableMapFeatures = [.pointsOfInterest]
        } else {
            //mapView.pointOfInterestFilter = .includingAll
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            mapView.addGestureRecognizer(tapGesture)
        }
        
        //mapytype control
        mapTypeSegmentedControl.addTarget(self, action: #selector(mapTypeSegmentedControlValueChanged), for: .valueChanged)
        
        //for making cluster of annotation
        mapView.register(UserAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(UserClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
    }
    func showUserLocation(){
        //locationManager.delegate = self
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
        
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    
    func showLocation(name : String, circularRegion: CLCircularRegion){
//        mapView.removeAnnotations(mapView.annotations)
        
        // Create a new annotation pin..
        let centerCoordinate = circularRegion.center
        createAnnotationPin(coordinate: centerCoordinate, locationName: name)
        
        // Calculate the dynamic span based on the radius of the circular region
        let dynamicSpan = MKCoordinateSpan(
            latitudeDelta: circularRegion.radius / 111000.0,
            longitudeDelta: circularRegion.radius / (111000.0 * cos(centerCoordinate.latitude * .pi / 180.0))
        )
        
        let region = MKCoordinateRegion(center: centerCoordinate, span: dynamicSpan)
        mapView.setRegion(region, animated: true)
        
    }
    func removeAllOverlays(completion: @escaping () -> Void) {
//        lastDrawnTimer?.invalidate()
//        lastDrawnTimer = nil
//       
//        // Delay the completion to allow the removal of overlays to finish
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.mapView.removeAnnotations(self.mapView.annotations)
//            self.mapView.removeOverlays(self.mapView.overlays)
//            self.directionButtonView.isHidden = true
//            self.cancelOverlayView.isHidden = true
//            self.staticSearchTextField.text = ""
//            self.textFieldForAddress.text = ""
//            self.previousUserLocation = nil
//            completion()
//        }
    }
    func createAnnotationPin(coordinate : CLLocationCoordinate2D, locationName: String){
        let landmarkAnnotation = MKPointAnnotation()
        landmarkAnnotation.title = locationName
        landmarkAnnotation.coordinate = coordinate
        self.mapView.addAnnotation(landmarkAnnotation)
    }
    // Function to create an MKPointAnnotation
    func createAnnotation(coordinate: CLLocationCoordinate2D, title: String?) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        return annotation
    }
    func setCustomAnnotation(){
        let annotations: [MKPointAnnotation] = [
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.4345, longitude: 75.4959), title: "Indore"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.73, longitude: 75.79), title: "Rau"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.63, longitude: 75.89), title: "Dewas"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.83, longitude: 75.75), title: "Ujjain"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 23.1516, longitude: 77.2410), title: "Bhopal"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 21.0846, longitude: 79.055), title: "Nagpur"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 18.0046, longitude: 79.055), title: "Hyderabad"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 19.0046, longitude: 74.055), title: "Pune"),
            createAnnotation(coordinate: CLLocationCoordinate2D(latitude: 19.3046, longitude: 73.055), title: "Mumbai"),
            // Add more annotations...
        ]
        
        mapView.addAnnotations(annotations)
    }
    
    func mapThis(destinationCord : CLLocationCoordinate2D, makeEntirePolylineVisible : Bool){
        let sourceCordinate = (locationManager.location?.coordinate)!
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        let destinationPlaceMArk = MKPlacemark(coordinate: destinationCord)
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let destItem = MKMapItem(placemark: destinationPlaceMArk)
        
        let destinationRequest = MKDirections.Request()
        
        destinationRequest.source = sourceItem
        destinationRequest.destination = destItem
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error)")
                return
            }
            guard let response = response else {
                print("No response received.")
                return
            }
            let route = response.routes[0]
            print("total routes : \(response.routes.count)")
            let routeRect = route.polyline.boundingMapRect
            if makeEntirePolylineVisible{
                let edgePadding = UIEdgeInsets(top: 150, left: 50, bottom: 50, right: 50)
                self.mapView.setVisibleMapRect(routeRect, edgePadding: edgePadding, animated: true)
            }
            // Remove existing overlays before adding the new one
            self.mapView.removeOverlays(self.mapView.overlays)
            self.createAnnotationPin(coordinate: destinationCord, locationName: self.destinationName)
            self.mapView.addOverlay(route.polyline)
            self.previousUserLocation = sourceCordinate
        }
    }
    func zoomMap(byFactor factor: Double) {
           var region = mapView.region

           // Adjust the span based on the factor
           region.span.latitudeDelta *= factor
           region.span.longitudeDelta *= factor

           // Ensure that the span stays within the specified limits
           region.span.latitudeDelta = max(minSpan.latitudeDelta, min(maxSpan.latitudeDelta, region.span.latitudeDelta))
           region.span.longitudeDelta = max(minSpan.longitudeDelta, min(maxSpan.longitudeDelta, region.span.longitudeDelta))

           mapView.setRegion(region, animated: true)
       }
    
    func hideKeyboardOnTap(view : UIView){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func updateRoute() {
        guard let currentLocation = locationManager.location?.coordinate else {
            return
        }
        let currentCLLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        // Compare with the previous location and check if it's beyond a certain threshold
        if let previousLocation = previousUserLocation{
            let previousCLLocation = CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude)
            if currentCLLocation.distance(from: previousCLLocation) > 1 {
                mapThis(destinationCord: destinationAddressCoordinate!, makeEntirePolylineVisible: false)
            }
        }
    }
    
    @objc func mapTypeSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        // Change the map type based on the selected segment
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    //tap for lower versions than 16
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        getLocationName(at: coordinate) { locationName in
            if let locationName = locationName {
                print("Tapped on location: \(locationName)")
                self.destinationName = locationName
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.createAnnotationPin(coordinate: coordinate, locationName: locationName)
                
            }
        }
    }
    
    func getLocationName(at coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let placemark = placemarks?.first {
                let locationName = placemark.name ?? placemark.locality ?? placemark.subLocality ?? "Unknown Location"
                completion(locationName)
            } else {
                completion(nil)
            }
        }
    }
}

//MARK: MapView Delegate
extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            return renderer
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let cluster = annotation as? MKClusterAnnotation else{
            if annotation is MKUserLocation{
                let imageSize = CGSize(width: 40, height: 50) // Specify your desired size
                if let image = UIImage(named: "userLocation")?.resize(targetSize: imageSize) {
                    let annotationView = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
                    annotationView.image = image
                    return annotationView
                }
            }else{
                destinationAddressCoordinate = annotation.coordinate
                directionButtonView.isHidden = false
                staticSearchTextField.text = annotation.title!
                cancelOverlayView.isHidden = false
                self.destinationName = (annotation.title ?? "")!
                
            }
            return nil
        }
        // If it's a cluster, use a marker annotation view for the cluster
        let clusterView = MKMarkerAnnotationView(annotation: cluster, reuseIdentifier: "cluster")
        clusterView.titleVisibility = .visible
        clusterView.subtitleVisibility = .hidden
        clusterView.markerTintColor = UIColor.blue
        return clusterView
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        print("cluster modifying")
        // Create a custom cluster annotation with the specified individual annotations
        let clusterAnnotation = MKClusterAnnotation(memberAnnotations: memberAnnotations)
        
        // Customize the title and subtitle for the group of annotations
        clusterAnnotation.title = "\(memberAnnotations.count) locations"
        return clusterAnnotation
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // Handle the selection of the annotation here
    }
}

//MARK: CoreLocation Delegate
extension MapViewController: CLLocationManagerDelegate {
    //these function is called on every sec which cause system hang...
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
}


//MARK: Back Search View
extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    
    func closeBackgroungSearchView() {
        view.sendSubviewToBack(backSearchView)
    }
    
    func openBackgroungSearchView() {
        view.bringSubviewToFront(backSearchView)
        textFieldForAddress.becomeFirstResponder()
    }
    
    @objc func searchLocations(){
        guard let address = textFieldForAddress.text else{
            print("address is nil")
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = address
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else{
                print("No response")
                self.matches.removeAll()
                self.locationTableView.reloadData()
                return
            }
            self.matches = response.mapItems
            self.locationTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noDataLabel.isHidden = matches.count == 0 ? false : true
        return matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = matches[indexPath.row].placemark
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.locationName.text = location.name
        cell.locationDetail.text = location.title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = matches[indexPath.row].placemark
        closeBackgroungSearchView()
        destinationAddressCoordinate = location.coordinate
        staticSearchTextField.text = location.name
        directionButtonView.isHidden = false
        cancelOverlayView.isHidden = false
        self.destinationName = location.name!
        showLocation(name: location.name ?? "", circularRegion: location.region as! CLCircularRegion)
    }
}


//MARK: Location Cell

class LocationCell : UITableViewCell{
    
    @IBOutlet weak var locationName : UILabel!
    @IBOutlet weak var locationDetail : UILabel!
    
}



