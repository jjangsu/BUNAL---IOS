//
//  BusInfoViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit



class BusInfoViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {

    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    
    var postsArriv = NSMutableArray()
    var elementsArriv = NSMutableDictionary()
    var elementArriv = NSString()
    
    var postsBusLocation = NSMutableArray()
    
    // 이번 씬에서 읽는 정보
    // category == 0
    var routeName = NSMutableString()
    var routeId = NSMutableString()
    var routeTypeName = NSMutableString()
    
    // category == 1
    var stationSeq = NSMutableString()
    var stationId = NSMutableString()
    
    
    var currentCategory : Int = 0
    
    var stationName = NSMutableString()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    // 전 씬에서 넘어오는 정보
    // category == 1
    var routeID = NSMutableString()
    var stationSeqPre = NSMutableString()
    var plateNo = NSMutableString()
    var plateType = NSMutableString()
    var remainSeatCnt = NSMutableString()
    var busStationList_stationName = NSMutableString()
    //  var stationId = NSMutableString() // category1 용
    // category == 2
    var stationIDPre = NSMutableString()
    var plateNo1 = NSMutableString()
    var plateNo2 = NSMutableString()
    var predictTime1 = NSMutableString()
    var predictTime2 = NSMutableString()
    var remainSeatCnt1 = NSMutableString()
    var remainSeatCnt2 = NSMutableString()
    var routeIdArriv = NSMutableString()
    var locationNo1 = NSMutableString()
    var locationNo2 = NSMutableString()
    var stationIdArrive = NSMutableString()
    
    @IBOutlet weak var busListTableview: UITableView!
    
    
    @IBAction func backwardViewController(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        busListTableview.estimatedRowHeight = 60
        busListTableview.rowHeight = 60
        
        // print(stationID)
        if currentCategory == 0 {
            beginXmlFileParsing(category: currentCategory, parameter: "stationId", value: stationIDPre)
        } else if currentCategory == 1 {
            beginXmlFileParsing(category: currentCategory, parameter: "routeId", value: routeID)
            //beginXmlFileParsing(category: 4, parameter: "stationId", value: stationID)
        }
        // Do any additional setup after loading the view.
    }
    
    func beginXmlFileParsing(category: Int, parameter: String, value: NSMutableString)
    {
        var path = ""
        if category == 0 {
            path = "http://openapi.gbis.go.kr/ws/rest/busstationservice/route?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
        } else if category == 1 {
            path = "http://openapi.gbis.go.kr/ws/rest/busrouteservice/station?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
        }
        
        let quaryURL = path + parameter + "=" + String(value)
        
        if category == 0 || category == 1 {
            posts = []
        } else {
            postsArriv = []
        }
        parser = XMLParser(contentsOf:(URL(string: quaryURL ))!)!
        
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("success")
            
        } else {
            print("parse failure!")
        }
        if category == 0 || category == 1 {
            busListTableview!.reloadData()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        // print("CurrentElementl: [\(elementName)]")
        element = elementName as NSString
        if ( elementName as NSString ).isEqual(to: "busRouteList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            routeName = NSMutableString()
            routeName = ""
            routeId = NSMutableString()
            routeId = ""
            routeTypeName = NSMutableString()
            routeTypeName = ""
        }
        else if (elementName as NSString ).isEqual(to: "busRouteStationList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            stationName = NSMutableString()
            stationName = ""
            stationSeq = NSMutableString()
            stationSeq = ""
            locationX = NSMutableString()
            locationX = ""
            locationY = NSMutableString()
            locationY = ""
            stationId = NSMutableString()
            stationId = ""
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if currentCategory == 0 {
            if element.isEqual(to: "routeName"){
                routeName.append(string)
            }
            else if element.isEqual(to: "routeTypeName") {
                routeTypeName.append(string)
            }
            else if element.isEqual(to: "routeId") {
                routeId.append(string)
            }
        }
        else if currentCategory == 1 {
            if element.isEqual(to: "stationName"){
                stationName.append(string)
            }
            else if element.isEqual(to: "stationSeq") {
                stationSeq.append(string)
            }
            else if element.isEqual(to: "x") {
                locationX.append(string)
            }
            else if element.isEqual(to: "y") {
                locationY.append(string)
            }
            else if element.isEqual(to: "stationId") {
                stationId.append(string)
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "busRouteList") {
            if !routeName.isEqual(nil) {
                elements.setObject(routeName, forKey: "routeName" as NSCopying)
            }
            if !routeId.isEqual(nil) {
                elements.setObject(routeId, forKey: "routeId" as NSCopying)
            }
            if !routeTypeName.isEqual(nil) {
                elements.setObject(routeTypeName, forKey: "routeTypeName" as NSCopying)
            }
            
            posts.add(elements)
        }
        else if (elementName as NSString).isEqual(to: "busRouteStationList") {
            if !stationName.isEqual(nil) {
                elements.setObject(stationName, forKey: "stationName" as NSCopying)
            }
            if !stationSeq.isEqual(nil) {
                elements.setObject(stationSeq, forKey: "stationSeq" as NSCopying)
            }
            if !locationX.isEqual(nil) {
                elements.setObject(locationX, forKey: "x" as NSCopying)
            }
            if !locationY.isEqual(nil) {
                elements.setObject(locationY, forKey: "y" as NSCopying)
            }
            if !stationId.isEqual(nil) {
                elements.setObject(stationId, forKey: "stationId" as NSCopying)
            }
            
            posts.add(elements)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BusInfoTableViewCell
        
        if currentCategory == 0 {
            cell.titleLabel.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeName") as! NSString as String
            
            // print(postsArriv.count)
            for i in 0..<postsArriv.count {
                if ( (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeId") as! NSString == (postsArriv[i] as AnyObject).value(forKey: "routeId") as! NSString as! NSMutableString ) {
                    let t = (postsArriv[i] as AnyObject).value(forKey: "locationNo1") as! NSString as! NSMutableString as String
                    cell.locationNo1.text = String("\(t)전")
                    let t2 = (postsArriv[i] as AnyObject).value(forKey: "locationNo2") as! NSString as! NSMutableString as String
                    cell.locationNo2.text = String("\(t2)전")
                    
                    let t3 = (postsArriv[i] as AnyObject).value(forKey: "predictTime1") as! NSString as! NSMutableString as String
                    cell.predictTime1.text = String("\(t3)분")
                    let t4 = (postsArriv[i] as AnyObject).value(forKey: "predictTime2") as! NSString as! NSMutableString as String
                    cell.predictTime2.text = String("\(t4)분")
                    
                    let t35 = (postsArriv[i] as AnyObject).value(forKey: "remainSeatCnt1") as! NSString as! NSMutableString as String
                    if t35 != "-1" {
                        cell.remainSeatCnt1.text = String("\(t35)석")
                    } else {
                        cell.remainSeatCnt1.text = String("X")
                    }
                    let t6 = (postsArriv[i] as AnyObject).value(forKey: "remainSeatCnt2") as! NSString as! NSMutableString as String
                    if t6 != "-1" {
                        cell.remainSeatCnt2.text = String("\(t6)석")
                    } else {
                        cell.remainSeatCnt2.text = String("X")
                    }
                }
                
            }
            
            cell.busImage.isHidden = true
            cell.remainSeatCnt.isHidden = true
            cell.plateNo.isHidden = true
            cell.defaultImage.isHidden = true
            
            
            cell.locationNo1.isHidden = false
            cell.locationNo2.isHidden = false
            cell.predictTime1.isHidden = false
            cell.predictTime2.isHidden = false
            cell.remainSeatCnt1.isHidden = false
            cell.remainSeatCnt2.isHidden = false
        }
        else if currentCategory == 1 {
            
            cell.remainSeatCnt.isHidden = false
            cell.plateNo.isHidden = false
            
            
            cell.locationNo1.isHidden = true
            cell.locationNo2.isHidden = true
            cell.predictTime1.isHidden = true
            cell.predictTime2.isHidden = true
            cell.remainSeatCnt1.isHidden = true
            cell.remainSeatCnt2.isHidden = true
            
            
            
            cell.defaultImage.isHidden = false
            cell.busImage.isHidden = true
            cell.defaultImage.image = UIImage(named: "Resource/road.png")
            cell.plateNo.text = String("")
            cell.remainSeatCnt.text = String("")
            
            
            for i in 0..<postsBusLocation.count {
                if ( (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationId") as! NSString == (postsBusLocation[i] as AnyObject).value(forKey: "stationId") as! NSString as! NSMutableString )
                {
                    cell.defaultImage.isHidden = true
                    cell.busImage.isHidden = false
                    cell.busImage.image = UIImage(named: "Resource/monster.png")
                    
                    UIView.animate(withDuration: 0.8, animations: {
                        // CGAffineTransFormMakeRotation()
                    
                        let rotation = CGAffineTransform(rotationAngle: CGFloat((Double.random(in: -0.5..<0.5)) * Double.pi))
                        let transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        
                        cell.busImage.transform = rotation.concatenating(transform)
            
                    }) { (_) in
                        UIView.animate(withDuration: 0.8, animations: {
                            cell.busImage.transform = CGAffineTransform.identity
                        })
                        
                    }
                    
                    let tmpPlateNo = (postsBusLocation[i] as AnyObject).value(forKey: "plateNo") as! NSString as! NSMutableString as String
                    cell.plateNo.text = String("\(tmpPlateNo)")
                    
                    let tmpRemainSeat = (postsBusLocation[i] as AnyObject).value(forKey: "remainSeatCnt") as! NSString as! NSMutableString as String
                    if String(tmpRemainSeat) != "-1" {
                        cell.remainSeatCnt.text = String("잔여석: \(tmpRemainSeat)석")
                    }
                    else
                    {
                        cell.remainSeatCnt.text = String("잔여석 제공 안함")
                    }

                }

            }
            // postsBusLocation
            
            cell.titleLabel.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationName") as! NSString as String
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // print(posts.count)
        return posts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? MapViewController else {
            guard let weatherViewController = segue.destination as? WeatherViewController else { return }
            
            if self.currentCategory == 0 {
                weatherViewController.locationX = self.locationX
                weatherViewController.locationY = self.locationY
            }
            return
        }
        
        let cell = sender as! UITableViewCell
        let indexPath = self.busListTableview.indexPath(for: cell)
        
        
        if currentCategory == 0 {
            secondViewController.locationX = self.locationX
            secondViewController.locationY = self.locationY
            
            secondViewController.stationName = self.busStationList_stationName
        }
        else if currentCategory == 1 {
            secondViewController.locationX = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "x") as! NSString as! NSMutableString
            secondViewController.locationY = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "y") as! NSString as! NSMutableString
            secondViewController.stationName = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "stationName") as! NSString as! NSMutableString
            // stationName
        }
    }
    
}

