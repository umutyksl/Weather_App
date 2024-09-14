//
//  ViewController.swift
//  ProfileProject
//
//  Created by Umut Yüksel on 16.08.2024.
//

import UIKit

class DetailsPage: UIViewController {
    
    var name = String()
    
    
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var labelCelc: UILabel!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var imageViewBG: UIImageView!
    
    
    @IBOutlet weak var windFast: UILabel!
    @IBOutlet weak var weatherOpen: UILabel!
    @IBOutlet weak var weatherNem: UILabel!
    
    
    @IBOutlet weak var imageWeather: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImage()
        
        textFieldCity.layer.cornerRadius = 25.0
        textFieldCity.layer.masksToBounds = true
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(gestureRecognizer)
        
        
        textFieldCity.attributedPlaceholder = NSAttributedString(
            string: "Şehir Veya İlçe Giriniz...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])

}
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func buttonSearch(_ sender: UIButton) {
        
        labelCityName.text = name
        getTodayResult(cityName: name)
    }
    
    
    
    func getTodayResult(cityName : String) {
            
        if let url = URL(string: "http://api.weatherstack.com/current?access_key=09a75895970b2f8574bab6266dc7f67e&query=\(self.textFieldCity.text)") {
                
                let request = URLRequest(url: url)
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if error == nil {
                        
                        if let incomingData = data {
                            
                            do {
                                
                                let json = try JSONSerialization.jsonObject(with: incomingData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                print(json)
                                
                                if let current = json["current"] as? NSDictionary {
                                    
                                    if let temperature = current["temperature"] as? Int {
                                       
                                    
                                        DispatchQueue.main.async {
                                            self.labelCelc.text = "\(temperature)°c"
                                        }
                                                                                
                                    }
                                    
                                    
                                    if let humidity = current["humidity"] as? Int {
                                        
                                        DispatchQueue.main.async {
                                            self.weatherNem.text = "\(humidity)%"
                                        }
                                    }
                                    
                                    
                                    if let wind = current["wind_speed"] as? Int {
                                        
                                        DispatchQueue.main.async {
                                            self.windFast.text = "\(wind) km/h"
                                        }
                                    }
                                    
                                    
                                    if let feelsLike = current["feelslike"] as? Int {
                                        
                                        DispatchQueue.main.async {
                                            self.weatherOpen.text = "\(feelsLike)°c"
                                        }
                                    }
                                    
                                    if let weatherDesc = current["weather_descriptions"] as? [String] {
                                        print(weatherDesc) // Gelen veriyi görmek için
                                        
                                        var iconName = ""
                                        
                                        // Weather descriptions içindeki anahtar kelimelere göre ikon belirleme
                                        if weatherDesc.contains(where: { $0.contains("Clear") }) {
                                            iconName = "sun"
                                        }
                                        else if weatherDesc.contains(where: { $0.contains("Sunny") }) {
                                            iconName = "sun"
                                        }
                                        else if weatherDesc.contains(where: { $0.contains("Rain") }) {
                                            iconName = "raining"
                                        } else if weatherDesc.contains(where: { $0.contains("Cloud") }) {
                                            iconName = "cloudly"
                                        } else if weatherDesc.contains(where: { $0.contains("Partly cloudy") }) {
                                            iconName = "cloudly2"
                                        }
                                        else if weatherDesc.contains(where: { $0.contains("Partly Cloudy") }) {
                                            iconName = "cloudly2"
                                        }
                                        else {
                                            iconName = "default_weather" // Herhangi bir tanım bulunamadığında varsayılan ikon
                                        }
                                        
                                        DispatchQueue.main.async {
                                            self.imageWeather.image = UIImage(named: iconName)
                                        }
                                    }
                                    
                                 /*  if let weatherIcons = current["weather_icons"] as? [String], let firstIcon = weatherIcons.first {
                                        DispatchQueue.main.async {
                                            if let url = URL(string: firstIcon), let data = try? Data(contentsOf: url) {
                                                self.imageWeather.image = UIImage(data: data)
                                            }
                                        }
                                    } */
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                               if let location = json["location"] as? NSDictionary {
                                    
                                    if let name = location["name"] as? String {
                                        
                                        DispatchQueue.main.async {
                                            self.labelCityName.text = name
                                        }
                                    }
                                }
                                
                                
                                
                            }catch{
                                print("bir hata oluştu.")
                            }
                            
                        }
                        
                    }
                    
                }
                task.resume()
                
            }
            
            
        }
    
    
    
    
    func bgImage(){
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
            UIColor(red: 154/255, green: 235/255, blue: 163/255, alpha: 1).cgColor,
            UIColor(red: 69/255, green: 196/255, blue: 176/255, alpha: 1).cgColor,
            UIColor(red: 107/255, green: 113/255, blue: 242/255, alpha: 1).cgColor
        ]
        

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            if let sublayers = view.layer.sublayers, let gradientLayer = sublayers.first as? CAGradientLayer {
                gradientLayer.frame = view.bounds
            }
        }
        
    }
        
    }

