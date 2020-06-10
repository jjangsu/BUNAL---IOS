//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var POPLabel: UILabel!   // 강수확률
    @IBOutlet weak var TMNLabel: UILabel!   // 최저 기온
    @IBOutlet weak var TMXLabel: UILabel!   // 최고 기온
    @IBOutlet weak var REHLabel: UILabel!   // 습도
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var category = NSMutableString()
    var fcstValue = NSMutableString()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    let converter = LambertProjection()
    
    var currentDate : String = ""
    var skyCondition : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "Resource/back.png")
        weatherIcon.image = UIImage(named: "Resource/sun.png")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        currentDate = formatter.string(from: Date())
        
        let (x, y) = converter.convertGrid(lon: locationX.doubleValue, lat: locationY.doubleValue)
        beginXmlFileParsing(numOfRows: String(104), baseData: currentDate, baseTime: String("0200"), nx: String(x), ny: String(y))
    }
    // 13가지
    // 00 03 06 09 12 15 18 21
    // 104개의 rows 요청
    func beginXmlFileParsing(numOfRows: String, baseData: String, baseTime: String, nx: String, ny: String)
    {
        let path = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getVilageFcst?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&pageNo=1&"
        
        
        let quaryURL = path + "numOfRows=" + numOfRows + "&dataType=XML&base_date=" + baseData + "&base_time=" + baseTime + "&nx=" + nx + "&ny=" + ny
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string: quaryURL ))!)!
        
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("weather parsing success")

        } else {
            print("weather parse failure!")
        }
        
        for i in 0..<posts.count
        {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "POP") {  // 강수량
                POPLabel.text = "강수확률: \((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)%"
            }
            else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "TMN") {  // 최저 기온
                TMNLabel.text = "\((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)°C /"
            }
            else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "TMX") {  // 최고 기온
                TMXLabel.text = "\((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)°C"
            }
            else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "SKY") {  // 하늘
                if skyCondition == -1 {
                    skyCondition = Int((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)!
                }
            }
            else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "REH") {  // 최고 기온
                REHLabel.text = "습도: \((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)%"
            }
        }
        setSkyImage(condition: skyCondition)
        // listTableView!.reloadData()
    }
    
    func setSkyImage(condition: Int)
    {
        switch condition {
        case 1: // 맑음
            weatherIcon.image = UIImage(named: "Resource/sun.png")
            break
        case 3: // 구름 많음
            weatherIcon.image = UIImage(named: "Resource/cloud_sun.png")
            break
        case 4: // 흐림
            weatherIcon.image = UIImage(named: "Resource/cloud.png")
            break
        default:
            break
        }
    }

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        
        if (elementName as NSString ).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            category = NSMutableString()
            category = ""
            fcstValue = NSMutableString()
            fcstValue = ""
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        if element.isEqual(to: "category") {
            category.append(string)
            // print(string)
        }
        else if element.isEqual(to: "fcstValue") {
            fcstValue.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?)
    {
        if(elementName as NSString).isEqual(to: "item") {
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            if !fcstValue.isEqual(nil) {
                elements.setObject(fcstValue, forKey: "fcstValue" as NSCopying)
            }
        
            
            posts.add(elements)
        }
    }

}
