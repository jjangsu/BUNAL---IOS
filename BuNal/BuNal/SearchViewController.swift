//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, XMLParserDelegate, UITableViewDataSource {
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var chooseCategoryControl: UISegmentedControl!
    
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var stationName = NSMutableString()
    var SiName = NSMutableString()
    
    @IBAction func micButtonAction(_ sender: Any) {
    }
    @IBAction func searchButtonAction(_ sender: Any) {
        // beginParsing()
    }
    @IBAction func chooseCategoryAction(_ sender: Any) {
    }
    @IBAction func backwardViewController (segue: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        beginXmlFileParsing()
        // beginParsing()
        // Do any additional setup after loading the view.
    }
    
    func beginXmlFileParsing()
    {
        // 경기도꺼
        // let path = "https://openapi.gg.go.kr/BusStation?ServiceKey=b84002c9970245a8b2e12f849ed7f049&SIGUN_NM="
        let path = "http://openapi.gbis.go.kr/ws/rest/busstationservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&keyword="
        let name = "강남"
        
        // let fullPath = path + name
        let quaryPath = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!    // urlQueryAllowed
        print(quaryPath)
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string: path + quaryPath  ))!)!
        
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("success")

        } else {
            print("parse failure!")
        }
        
        listTableView!.reloadData()
    }

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        
        // print("CurrentElementl: [\(elementName)]")
        
        if ( elementName as NSString ).isEqual(to: "busStationList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            stationName = NSMutableString()
            stationName = ""
            SiName = NSMutableString()
            SiName = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "stationName"){
            stationName.append(string)
        }
        else if element.isEqual(to: "regionName") {
            SiName.append(string)
        }
        print(string)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?)
    {
        if(elementName as NSString).isEqual(to: "busStationList") {
            if !stationName.isEqual( nil) {
                elements.setObject(stationName, forKey: "stationName" as NSCopying)
            }
            if !SiName.isEqual( nil) {
                elements.setObject(SiName, forKey: "regionName" as NSCopying)
            }
            
            posts.add(elements)
            print(posts)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationName") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "regionName") as! NSString as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // print(posts.count)
        return posts.count
    }

}
