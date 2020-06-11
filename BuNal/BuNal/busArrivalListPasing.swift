//
//  busArrivalListPasing.swift
//  BuNal
//
//  Created by kpugame on 2020/06/11.
//  Copyright © 2020 minjoooo. All rights reserved.
//
import UIKit
import Foundation

class BusArrival : XMLParserDelegate
{
    var parser = XMLParser()
    var postsArriv = NSMutableArray()
    var elementsArriv = NSMutableDictionary()
    var elementArriv = NSString()
    
    var plateNo1 = NSMutableString()
    var plateNo2 = NSMutableString()
    var predictTime1 = NSMutableString()
    var predictTime2 = NSMutableString()
    var remainSeatCnt1 = NSMutableString()
    var remainSeatCnt2 = NSMutableString()
    var routeIdArriv = NSMutableString()
    
    func beginXmlFileParsing(parameter: String, value: NSMutableString)
       {
           let path = "http://openapi.gbis.go.kr/ws/rest/busarrivalservice/station?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
           let quaryURL = path + parameter + "=" + String(value)

            postsArriv = []

           parser = XMLParser(contentsOf:(URL(string: quaryURL ))!)!

           parser.delegate = self

           let success:Bool = parser.parse()
           if success {
               print("success")

           } else {
               print("parse failure!")
           }
           //if category == 0 || category == 1 {
           // busListTableview!.reloadData()
           //}
       }
}
