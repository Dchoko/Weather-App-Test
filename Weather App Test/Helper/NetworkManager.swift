//
//  NetworkManager.swift
//  Weather App Test
//
//  Created by Debashish Chakraborty on 22/03/22.
//

import Foundation
import UIKit

class NetworkManager: NSObject {
    static let sharedInstance = NetworkManager()

    func serviceCallGetRequest(lat: Float, lon: Float, url: String, viewController: UIViewController, completionHandler: @escaping (Data) -> ())
    {
        // "https://api.openweathermap.org/data/2.5/weather?lat=55.5&lon=37.5&appid=db8d5a8a249bd905a37434f9ef67389a"
        let url = URL(string: GET_WEATHER_BASE_URL + "lat=\(lat)" + "&" + "lon=\(lon)" + "&appid=" + API_KEY)!
        print("ACTUAL URL: \(url)")
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                let alert = UIAlertController(title: "Alert", message: "Something went wrong! Try again.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                completionHandler(Data())
                return
            }
            print("RAW : ",String(data: data, encoding: .utf8)!)
            print("==============")
            let responseDict = (self.getDictionary(data: data) ?? Dictionary()) as Dictionary<String, AnyObject>
            
            completionHandler(data as Data)
            
        }
        task.resume()
    }
    func getDictionary(data: Data) -> Dictionary<String, AnyObject>? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String, AnyObject>
            return json
        } catch {
            print("Something went wrong")
        }
        return nil
    }
}
