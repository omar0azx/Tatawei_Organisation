//
//  MapVC.swift
//  Tatawei Organisation
//
//  Created by omar alzhrani on 08/05/1446 AH.
//
//
import UIKit
//import CoreLocation
//import GoogleMaps
//import GooglePlaces

//protocol DataSelectionDelegate: AnyObject {
//    func didSelectData(_ data: String)
//}

//CLLocationManagerDelegate, GMSMapViewDelegate,

class MapVC: UIViewController {
//
//    var coordinator: MainCoordinator?
//    
//    weak var delegate: DataSelectionDelegate?
//    
//    mapView
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    @IBOutlet weak var searchBar: DesignableTextField!
//    
//    @IBOutlet weak var chooseBTN: DesignableButton!
//    
//    var placesClient: GMSPlacesClient!
//    let marker = GMSMarker()
//    
//    let locationManager = CLLocationManager()
//    var placeDescription: String?
//    
//    private var tableDataSource: GMSAutocompleteTableDataSource!
//    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
//        mapView.delegate = self
//        
//        // Do any additional setup after loading the view.
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        
//        tableDataSource = GMSAutocompleteTableDataSource()
//        tableDataSource.delegate = self
//        let filter = GMSAutocompleteFilter()
//        filter.type = .establishment
//        filter.countries = ["SA"]
//        tableDataSource.autocompleteFilter = filter
//        
//        tableView.delegate = tableDataSource
//        tableView.dataSource = tableDataSource
//        
//        // Initialize the Google Places API client
//        placesClient = GMSPlacesClient.shared()
                
    }
    
//    @IBAction func didPressedCancel(_ sender: UIButton) {
//        dismiss(animated: true)
//        
//    }
//    
//    @IBAction func chooseBTN(_ sender: UIButton) {
//        delegate?.didSelectData(placeDescription!)
//        dismiss(animated: true)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//            mapView.isMyLocationEnabled = true
//            mapView.settings.myLocationButton = true
//        }
//        
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
//            let geocoder = GMSGeocoder()
//            geocoder.reverseGeocodeCoordinate(location.coordinate) { response, error in
//                if let address = response?.firstResult() {
//                    // Access various properties of the address
//                    let lines = address.lines ?? []
//                    _ = lines.joined(separator: "\n")
//                }
//            }
//            locationManager.stopUpdatingLocation()
//        }
//    }
//   
//    func addMarkerByPlaceID(placeID: String, name: String) {
//            // Fetch place details using Google Places API
//        let autocompleteSessionToken = GMSAutocompleteSessionToken()
//        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: .coordinate, sessionToken: autocompleteSessionToken) { (place, error) in
//                if let error = error {
//                    print("Error fetching place details: \(error.localizedDescription)")
//                    return
//                }
//
//                // Add a marker to the map
//                if let coordinate = place?.coordinate {
//                    self.marker.position = coordinate
//                    self.marker.title = place?.name
//                    self.searchBar.text = name
//                    self.mapView.camera = GMSCameraPosition(target: coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
//                    self.marker.map = self.mapView
//                    UIView.animate(withDuration: 0.4) {
//                        self.chooseBTN.isHidden = false
//                        self.chooseBTN.alpha = 1
//                        self.loadViewIfNeeded()
//                    }
//                }
//            }
//        }
//
//
//extension MapVC: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        if textField.text == "" {
//            tableView.isHidden = true
//        } else {
//            tableView.isHidden = false
//        }
//        tableDataSource.sourceTextHasChanged(textField.text)
//    }
//}
//
//extension MapVC: GMSAutocompleteTableDataSourceDelegate {
//    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
//        // Turn the network activity indicator off.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        // Reload table data.
//        tableView.reloadData()
//    }
//    
//    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
//        // Turn the network activity indicator on.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        // Reload table data.
//        tableView.reloadData()
//    }
//    
//    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
//        // Do something with the selected place.
//        addMarkerByPlaceID(placeID: place.placeID!, name: place.name!)
//        placeDescription = place.formattedAddress
//    }
//    
//    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
//        // Handle the error.
//        print("Error: \(error.localizedDescription)")
//    }
//    
//    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didSelect prediction: GMSAutocompletePrediction) -> Bool {
//        tableView.isHidden = true
//        searchBar.resignFirstResponder()
//        return true
//    }
//    
//}
//
//extension MapVC {
//    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
//        // Custom logic here
//        marker.position = coordinate
//        marker.title = "I added this location"
//        marker.snippet = ""
//        marker.map = mapView
//        placeDescription = "location is (\(marker.position.latitude), \(marker.position.longitude))"
//        UIView.animate(withDuration: 0.4) {
//            self.chooseBTN.isHidden = false
//            self.chooseBTN.alpha = 1
//            self.loadViewIfNeeded()
//        }
//        print("Place description: \(marker.description)")
//    }
//}
//
//
