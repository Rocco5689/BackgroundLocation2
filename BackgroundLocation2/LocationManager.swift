import Foundation
import SwiftUI
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocation?
    private let locationManager = CLLocationManager()
    private var counter = 0

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location
            self.logLocation(location: location)
        }
    }

    private func logLocation(location: CLLocation) {
        // Save the location data or perform any background tasks with the updated location here.
        // For example, you could save the location data to a local database or send it to a server.
        print(location)
        
        if (counter > 59)
        {
            let locationData = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: locationData)
            
            guard let url = URL(string: "https://locationfunc56.azurewebsites.net/api/HttpTrigger1") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response: \(responseString)")
                    }
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }.resume()
            
            counter = 0
        }
        
        counter += 1
        
//        guard let url = URL(string: "https://locationfunc56.azurewebsites.net/api/HttpTrigger1") else { print("invalid"); return }
        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        var lat = location.coordinate.latitude
//
//        let coords = Text(String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude))
//
//        if let data = coords. .content.rawValue {
//            // Do something with the data
//            print("Data: \(data)")
//        }
//
//        request.httpBody = data
        
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                if let responseString = String(data: data, encoding: .utf8) {
//                    print("Response: \(responseString)")
//                }
//            } else if let error = error {
//                print("Error: \(error.localizedDescription)")
//            }
//        }.resume()
    }
    
    private func sendLocationInfo() {
        
        

    }
}
