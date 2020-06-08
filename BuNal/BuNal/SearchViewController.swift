//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, XMLParserDelegate {
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var chooseCategoryControl: UISegmentedControl!
    
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var name = NSMutableString()
    
    
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
        posts = []
        parser = XMLParser(contentsOf:(URL(string:"https://openapi.gg.go.kr/BusStation?ServiceKey=b84002c9970245a8b2e12f849ed7f049"))!)!
        
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("success")

        } else {
            print("parse failure!")
        }
        
        listTableView!.reloadData()
    }
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf:(URL(string:"http://apis.data.go.kr/9710000/NationalAssemblyInfoService/getMemberCurrStateList?ServiceKey=sea100UMmw23Xycs33F1EQnumONR%2F9ElxBLzkilU9Yr1oT4TrCot8Y2p0jyuJP72x9rG9D8CN5yuEs6AS2sAiw%3D%3D"))!)!

        parser.delegate = self
        parser.parse()
        listTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        
        // print("CurrentElementl: [\(elementName)]")
        
        if ( elementName as NSString ).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            name = NSMutableString()
            name = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "STATION_NM_INFO"){
            name.append(string)
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?)
    {
        if(elementName as NSString).isEqual(to: "row") {
            if !name.isEqual( nil) {
                elements.setObject(name, forKey: "STATION_NM_INFO" as NSCopying)
            }
            
            posts.add(elements)
        }
    }

}
