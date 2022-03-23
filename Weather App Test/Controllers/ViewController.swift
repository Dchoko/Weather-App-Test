//
//  ViewController.swift
//  Weather App Test
//
//  Created by Debashish Chakraborty on 22/03/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var offlineLabel: UILabel!
    
    // Base Location
    let baseLat: Float = 55.5
    let baseLon: Float = 37.5
    
    // todo: get different location co-ords
    
    /*
     Done:
     getting weather informations
     showing required data on list
     looping through counts
     saving data
     show offline data is net is not available
     */
//    var weatherData = WeatherModel_Base(dictionary: NSDictionary()) {
//        didSet {
//            self.weatherDataArray.append(weatherData!)
//            if self.weatherDataArray.count >= count {
//                // Saving data
//                let dat = ["ascadfa", "asdfa", "asdfa", "asdfa"]
//
//                let theData = NSKeyedArchiver.archivedData(withRootObject: self.weatherDataArray)
//                UserDefaults.standard.set(theData, forKey: "weatherData")
//                let result = UserDefaults.standard.value(forKey: "weatherData")
//                print(result!)
//                DispatchQueue.main.async {
//                    self.weatherTableView.reloadData()
//                }
//            }
//
//        }
//    }
    var weatherData: WeatherModel_Base? {
        didSet {
            self.weatherDataArray.append(weatherData!)
            if self.weatherDataArray.count >= count {
                // Saving data
//                let dat = ["ascadfa", "asdfa", "asdfa", "asdfa"]

                let theData = NSKeyedArchiver.archivedData(withRootObject: self.weatherDataArray)
                UserDefaults.standard.set(theData, forKey: "weatherData")
                let result = UserDefaults.standard.value(forKey: "weatherData")
                print(result!)
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
            }

        }
    }
    var weatherDataArray = [WeatherModel_Base]()
    
    let count = 15 // Number of nearby locations

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Reachability.isConnectedToNetwork() {
//            print("Internet available!")
            self.offlineLabel.isHidden = true
            self.weatherDataArray.removeAll()
            for index in 0...(count - 1) {
//                self.getWeatherServiceCall(lat: (self.baseLat - (Float(Int(self.count) / 2))) + Float(index / 10), lon: (self.baseLon - (Float(Int(self.count) / 2))) + Float(index / 10))
                self.getWeatherServiceCall(lat: (self.baseLat - Float(index / 10)), lon: (self.baseLon - Float(index / 10))) // getting co-ordinations of near-by places situated diagonally to wards North-West from the base location
            }
        }else{
//            print("Internet not available!")
            self.offlineLabel.isHidden = false
            if let result = UserDefaults.standard.value(forKey: "weatherData") {
                let arr = try! JSONDecoder().decode([WeatherModel_Base].self, from: result as! Data)

                print(arr)
                self.weatherDataArray = arr
                self.weatherTableView.reloadData()
            }
        }
        
    }

    func getWeatherServiceCall(lat: Float, lon: Float) {
        
        NetworkManager.sharedInstance.serviceCallGetRequest(lat: lat, lon: lon, url: "", viewController: self, completionHandler: { (data) in
//            self.weatherData = WeatherModel_Base(dictionary: dict)
            let decoder = JSONDecoder()
            do {
                let decoded = try decoder.decode(WeatherModel_Base.self, from: data)
//                let userDefaults = UserDefaults.standard
//                let encodedData = NSKeyedArchiver.archivedData(withRootObject: decoded)
//                userDefaults.set(encodedData, forKey: "sales")
//                
//                let newArray = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.value(forKey: "sales") as! Data) as! WeatherModel_Base
//
//
//                print(newArray)
//                self.weatherData = decoded
                self.weatherDataArray.append(decoded)
                if self.weatherDataArray.count >= self.count {
//                    // Saving data
//                    //                let dat = ["ascadfa", "asdfa", "asdfa", "asdfa"]
                let theData = try! JSONEncoder().encode(self.weatherDataArray)
//                    let theData = NSKeyedArchiver.archivedData(withRootObject: self.weatherDataArray)
                    UserDefaults.standard.set(theData, forKey: "weatherData")
                    
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadData()
                    }
                }
            } catch ( let error ) {
                print(error.localizedDescription)
            }
            
        })
    }

}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDataArray.count
//        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell") as! WeatherTableViewCell
        cell.locationNameLabel.text = "\(indexPath.row + 1): \(self.weatherDataArray[indexPath.row].name ?? "")"
        cell.minMaxTemparatureLabel.text = "Min: \(Int((self.weatherDataArray[indexPath.row].main?.temp_min ?? 0) - 273.15))ºC, Max: \(Int((self.weatherDataArray[indexPath.row].main?.temp_max ?? 0) - 273.15))ºC"
        //        cell.descriptionLabel.text = "Current temparature: \(), Feels like: \(), Humidity: \(), \()"
        cell.descriptionLabel.text = (self.weatherDataArray[indexPath.row].weather?.count ?? 0) > 0 ? (self.weatherDataArray[indexPath.row].weather?[0].description ?? "") : ""
        return cell
    }
    
    
}
