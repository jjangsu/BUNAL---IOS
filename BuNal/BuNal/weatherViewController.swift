//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController, XMLParserDelegate {
    
    @IBSegueAction func weatherChartAction(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: LineChartView(data: [10,23,20,32,12,34,7,23,43], title: "일주일 기온", legend: ":)")
        .environment(\.colorScheme, .light))
    }
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var POPLabel: UILabel!   // 강수확률
    @IBOutlet weak var TMNLabel: UILabel!   // 최저 기온
    @IBOutlet weak var TMXLabel: UILabel!   // 최고 기온
    @IBOutlet weak var REHLabel: UILabel!   // 습도
    @IBOutlet weak var VECLabel: UILabel!   // 풍향
    @IBOutlet weak var WSDLabel: UILabel!   // 풍속
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var category = NSMutableString()
    var fcstValue = NSMutableString()
    var fcstDate = NSMutableString()
    var fcstTime = NSMutableString()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    let converter = LambertProjection()
    
    var currentDate : String = ""
    var currentTime : String = ""
    
    var skyCondition : Int = -1
    var vecValue : Int = -1
    var wsdValue : Double = -1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "Resource/back.png")
        weatherIcon.image = UIImage(named: "Resource/sun.png")
        
        
        
        var tempTime = ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        currentDate = formatter.string(from: Date())
        
        formatter.dateFormat = "HHmm"
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        tempTime = formatter.string(from: Date())
        
        currentTime = getBaseTime(time: Int(tempTime)!)
        
        let (x, y) = converter.convertGrid(lon: locationX.doubleValue, lat: locationY.doubleValue)
        print("x: \(x), y: \(y)")
        beginXmlFileParsing(numOfRows: String(104), baseData: currentDate, baseTime: currentTime, nx: String(x), ny: String(y))
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
        
        let dataDate = (posts[0] as AnyObject).value(forKey: "fcstDate") as! NSString as! NSMutableString as String
        
        for i in 0..<posts.count
        {
            let tmpDate = (posts[i] as AnyObject).value(forKey: "fcstDate") as! NSString as! NSMutableString as String
            
            if (dataDate == tmpDate)
            {
                if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "TMN") {  // 최저 기온
                    TMNLabel.text = "\((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)°C /"
                }
                else if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "TMX") {  // 최고 기온
                    TMXLabel.text = "\((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)°C"
                }
            }
        }
        
        for i in 0..<posts.count
        {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "POP") {  // 강수량
                POPLabel.text = "강수확률: \((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)%"
                break
            }
        }
        
        for i in 0..<posts.count
        {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "SKY") {  // 하늘
                if skyCondition == -1 {
                    skyCondition = Int((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)!
                    break
                }
            }
        }
        
        for i in 0..<posts.count
        {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "REH") {  // 습도
                REHLabel.text = "습도: \((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString as String)%"
                break
            }
        }
          
        for i in 0..<posts.count
        {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "VEC") {  // 풍향
                if vecValue == -1
                {
                    vecValue = Int(((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString).integerValue)
                    break
                }
            }
        }
        
        for i in 0..<posts.count
        {
            if ((posts[i] as AnyObject).value(forKey: "category") as! NSString as! NSMutableString == "WSD") {  // 풍속
                if wsdValue == -1.0 {
                    wsdValue = Double(((posts[i] as AnyObject).value(forKey: "fcstValue") as! NSString as! NSMutableString).doubleValue)
                    break
                }
            }
        }
        
        setSkyImage(condition: skyCondition)
        setVec(vec: vecValue)
        setWSD(wsd: wsdValue)
        // listTableView!.reloadData()
    }
    
    func getBaseTime(time: Int) -> String
    {
        if 0 < time && time < 0210
        {
            return "0000"   // 전날로 수정할 수 있도록 해야 함
        }
        else if 0210 <= time && time < 0510
        {
            return "0200"
        }
        else if 0510 <= time && time < 0810
        {
            return "0500"
        }
        else if 0810 <= time && time < 1110
        {
            return "0800"
        }
        else if 1110 <= time && time < 1410
        {
            return "1100"
        }
        else if 1410 <= time && time < 1710
        {
            return "1400"
        }
        else if 1710 <= time && time < 2010
        {
            return "1700"
        }
        else if 2010 <= time && time < 2310
        {
            return "2000"
        }
        else if 2310 <= time
        {
            return "2300"
        }
        
        return ""
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
    
    func setVec(vec: Int)
    {
        var dir : String = ""
        
        if 0 <= vec && vec < 45 {
            dir = "N-NE"
        } else if 45 <= vec && vec < 90 {
            dir = "NE-E"
        } else if 90 <= vec && vec < 135 {
            dir = "E-SE"
        } else if 135 <= vec && vec < 180 {
            dir = "SE-S"
        } else if 180 <= vec && vec < 225 {
            dir = "S-SW"
        } else if 225 <= vec && vec < 270 {
            dir = "SW-W"
        } else if 270 <= vec && vec < 315 {
            dir = "W-NW"
        } else if 315 <= vec && vec < 360 {
            dir = "NE-N"
        }
        
        VECLabel.text = "풍향: \(dir) - \(vec)m/s"
    }
    
    func setWSD(wsd: Double)
    {
        var desc = ""
        if wsd < 4.0 {
            desc = "바람이 약하다"
        } else if 4.0 <= wsd && wsd < 9.0 {
            desc = "바람이 약간 강하다"
        } else if 9.0 <= wsd && wsd < 14.0 {
            desc = "바람이 강하다"
        } else if 14.0 <= wsd {
            desc = "바람이 매우 강하다"
        }
        
        WSDLabel.text = "풍속: \(wsd)m/s - \(desc)"
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
            fcstDate = NSMutableString()
            fcstDate = ""
            fcstTime = NSMutableString()
            fcstTime = ""
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
        else if element.isEqual(to: "fcstDate") {
            fcstDate.append(string)
        }
        else if element.isEqual(to: "fcstTime") {
            fcstTime.append(string)
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
            if !fcstDate.isEqual(nil) {
                elements.setObject(fcstDate, forKey: "fcstDate" as NSCopying)
            }
            if !fcstTime.isEqual(nil) {
                elements.setObject(fcstTime, forKey: "fcstTime" as NSCopying)
            }
            
            
            posts.add(elements)
        }
    }
    
}
