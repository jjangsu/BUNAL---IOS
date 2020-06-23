//
//  SearchViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/04.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit
import Speech

class SearchViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var chooseCategoryControl: UISegmentedControl!
    
    var timer = Timer()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var stationName = NSMutableString()
    var SiName = NSMutableString()
    var stationId = NSMutableString()
    
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    
    var routeName = NSMutableString()
    var regionName = NSMutableString()
    var routeId = NSMutableString()
    
    var currentCategory : Int = 0
    
    let busStationPath = "http://openapi.gbis.go.kr/ws/rest/busstationservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
    let busListPath = "http://openapi.gbis.go.kr/ws/rest/busrouteservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
    
    @IBAction func categoryPressed(_ sender: UISegmentedControl) {
        switch chooseCategoryControl.selectedSegmentIndex {
        case 0:
            currentCategory = 0
            beginXmlFileParsing(path: busStationPath, parameter: "keyword", value: "강남")
        case 1:
            currentCategory = 1
            beginXmlFileParsing(path: busListPath, parameter: "keyword", value: "11")
            break
        default:
            break
        }
    }
    
    @IBAction func micButtonAction(_ sender: Any) {
            micButton.isEnabled = false
            try! startSession()
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.stopMic), userInfo: nil, repeats: false)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if currentCategory == 0 {
            beginXmlFileParsing(path: busStationPath, parameter: "keyword", value: String(searchTextField.text!))
        }
        else if currentCategory == 1 {
            beginXmlFileParsing(path: busListPath, parameter: "keyword", value: String(searchTextField.text!))
        }
        
    }
    
    @IBAction func backwardViewController (segue: UIStoryboardSegue) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeSR()
        currentCategory = 0
        beginXmlFileParsing(path: busStationPath, parameter: "keyword", value: "강남")
    }
    
    @objc func stopMic() {
        micButton.isEnabled = true
        audioEngine.stop()
        speechRecognitionRequest?.endAudio()
        timer.invalidate()
    }
    
    func startSession() throws {
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)

        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = speechRecognitionRequest else { fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed") }

        let inputNode = audioEngine.inputNode

        recognitionRequest.shouldReportPartialResults = true

        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in

            var finished = false

            if let result = result {
                self.searchTextField.text =
                result.bestTranscription.formattedString
                finished = result.isFinal
            }

            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil

                self.micButton.isSelected = false
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in

            self.speechRecognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func authorizeSR() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.micButton.isEnabled = true
                    
                case .denied:
                    self.micButton.isEnabled = false
                    self.micButton.setTitle("Speech recognition access denied by user", for: .disabled)

                case .restricted:
                        self.micButton.isEnabled = false
                        self.micButton.setTitle("Speech recognition restricted on device", for: .disabled)
                
                case .notDetermined:
                    self.micButton.isEnabled = false
                    self.micButton.setTitle("Speech recognition not authorizer", for: .disabled)
                }
            }
            
        }
    }
    
    func beginXmlFileParsing(path: String, parameter: String, value: String)
    {
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
        if ( elementName as NSString ).isEqual(to: "busRouteList")
        {
            elements = NSMutableDictionary()
            elements = [:]
            routeName = NSMutableString()
            routeName = ""
            regionName = NSMutableString()
            regionName = ""
            routeId = NSMutableString()
            routeId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if currentCategory == 0 {
            if element.isEqual(to: "stationName"){
                stationName.append(string)
            }
            else if element.isEqual(to: "regionName") {
                SiName.append(string)
            }
            else if element.isEqual(to: "stationId") {
                stationId.append(string)
                // print("S   \(element) - \(string)")
            }
            else if element.isEqual(to: "x") {
                locationX.append(string)
            }
            else if element.isEqual(to: "y") {
                locationY.append(string)
            }
        }
        else if currentCategory == 1 {
            if element.isEqual(to: "routeName") {
                routeName.append(string)
            }
            else if element.isEqual(to: "regionName") {
                regionName.append(string)
            }
            else if element.isEqual(to: "routeId") {
                routeId.append(string)
            }
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
        
        if(elementName as NSString).isEqual(to: "busRouteList") {
            if !routeName.isEqual( nil) {
                elements.setObject(routeName, forKey: "routeName" as NSCopying)
            }
            if !regionName.isEqual( nil) {
                elements.setObject(regionName, forKey: "regionName" as NSCopying)
            }
            if !routeId.isEqual( nil) {
                elements.setObject(routeId, forKey: "routeId" as NSCopying)
            }
            
            posts.add(elements)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if currentCategory == 0 {
            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationName") as! NSString as String
            cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "regionName") as! NSString as String
        }
        else if currentCategory == 1 {
            
                cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeName") as! NSString as String
                cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "regionName") as! NSString as String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // print(posts.count)
        return posts.count
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? LodingViewController else { return }
        
        let cell = sender as! UITableViewCell
        let indexPath = self.listTableView.indexPath(for: cell)
        
        secondViewController.currentCategory = self.currentCategory
        
        //print("pass - \((posts.object(at: indexPath!.row) as AnyObject).value(forKey: "stationId") as! NSString)")
        
        if currentCategory == 0 {
            secondViewController.locationX = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "x") as! NSString as! NSMutableString
            secondViewController.locationY = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "y") as! NSString as! NSMutableString
            
            secondViewController.stationID = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "stationId") as! NSString as! NSMutableString
            
        } else if currentCategory == 1 {
            secondViewController.routeID = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "routeId") as! NSString as! NSMutableString
        }
    }

}
