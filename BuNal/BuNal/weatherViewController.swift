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
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var category = NSMutableString()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    let converter = LambertProjection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.image = UIImage(named: "Resource/back.png")
        weatherIcon.image = UIImage(named: "Resource/sun.png")
        
        let (x, y) = converter.convertGrid(lon: locationX.doubleValue, lat: locationY.doubleValue)
        beginXmlFileParsing(numOfRows: String(10), baseData: String(20200611), baseTime: String("0200"), nx: String(x), ny: String(y))
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
        
        // listTableView!.reloadData()
    }

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        
        if (elementName as NSString ).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            category = NSMutableString()
            category = ""
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
        if element.isEqual(to: "category") {
            category.append(string)
            print(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?)
    {
        if(elementName as NSString).isEqual(to: "item") {
            if !category.isEqual(nil) {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            
            posts.add(elements)
        }
        
        
    }

}
