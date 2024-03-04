//
//  MapViewBackground.swift
//  iOS App
//
//  Created by Qualwebs on 29/01/24.
import UIKit
import MapKit

//MARK: Background View
extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    
    func closeBackgroungSearchView() {
        view.sendSubviewToBack(backSearchView)
    }
    
    func openBackgroungSearchView() {
        view.bringSubviewToFront(backSearchView)
        textFieldForAddress.becomeFirstResponder()
    }
    
    func closeBackgroungLocationView() {
        view.sendSubviewToBack(backgroundLocationDetailView)
    }
    
    func openBackgroungLocationView() {
        view.bringSubviewToFront(backgroundLocationDetailView)
        if(clusterAnnotationData.count != 0){
            backgroundSingleLocationView.isHidden = true
            backgroundLocationTableView.reloadData()
        }else{
            backgroundSingleLocationView.isHidden = false
        }
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
        if tableView == locationTableView{
            noDataLabel.isHidden = matches.count == 0 ? false : true
            return matches.count
        }else{
            backgroundTotalLocationsLabel.text = "\(clusterAnnotationData.count) locations "
            return clusterAnnotationData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == locationTableView{
            let location = matches[indexPath.row].placemark
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
            cell.locationName.text = location.name
            cell.locationDetail.text = location.title
            return cell
        }else{
            let location = clusterAnnotationData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDetailCell") as! LocationDetailCell
            cell.locationName.text = location.locationName
            cell.locationDetail.text = location.subtitle
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == locationTableView{
            let location = matches[indexPath.row].placemark
            print(location)
            closeBackgroungSearchView()
            destinationAddressCoordinate = location.coordinate
            staticSearchTextField.text = location.name
            directionButtonView.isHidden = false
            cancelOverlayView.isHidden = false
            self.destinationName = location.name!
            showLocation(name: location.name ?? "", circularRegion: location.region as! CLCircularRegion, locationSubtitle: location.subtitle ?? location.country ?? "World")
        }
    }
}

