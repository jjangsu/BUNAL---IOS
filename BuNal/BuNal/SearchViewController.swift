//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chooseCategoryControl: UISegmentedControl!
    
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var stationName = NSMutableString()
    var SiName = NSMutableString()
    var stationId = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    
    @IBAction func micButtonAction(_ sender: Any) {
    }
    @IBAction func searchButtonAction(_ sender: Any) {
        beginXmlFileParsing(parameter: "keyword", value: String(searchTextField.text!))
        // beginParsing()
    }
    @IBAction func chooseCategoryAction(_ sender: Any) {
        let index = chooseCategoryControl.selectedSegmentIndex
        switch index {
        case 0: // 정류장
           
            break
        case 1:// 버스
            
            break
        default:
            break
        }
        
    }
    @IBAction func backwardViewController (segue: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        beginXmlFileParsing(parameter: "keyword", value: "강남")
    }
    
    func beginXmlFileParsing(parameter: String, value: String)
    {
        let path = "http://openapi.gbis.go.kr/ws/rest/busstationservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
        let valueEncoding = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!    // urlQueryAllowed
        let quaryURL = path + parameter + "=" + valueEncoding
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string: quaryURL ))!)!
        
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
            stationId = NSMutableString()
            stationId = ""
            locationX = NSMutableString()
            locationX = ""
            locationY = NSMutableString()
            locationY = ""
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
        else if element.isEqual(to: "stationId") {
            stationId.append(string)
        }
        else if element.isEqual(to: "x") {
            locationX.append(string)
        }
        else if element.isEqual(to: "y") {
            locationY.append(string)
        }
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
            if !stationId.isEqual( nil) {
                elements.setObject(stationId, forKey: "stationId" as NSCopying)
            }
            if !locationX.isEqual(nil) {
                elements.setObject(locationX, forKey: "x" as NSCopying)
            }
            if !locationY.isEqual(nil) {
                elements.setObject(locationY, forKey: "y" as NSCopying)
            }
            
            posts.add(elements)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? BusInfoViewController else { return }
        
        let cell = sender as! UITableViewCell
        let indexPath = self.listTableView.indexPath(for: cell)
        
       // secondViewController.stationID = ""
        secondViewController.stationID = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "stationId") as! NSString as! NSMutableString
        secondViewController.locationX = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "x") as! NSString as! NSMutableString
        secondViewController.locationY = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "y") as! NSString as! NSMutableString
    }

}
