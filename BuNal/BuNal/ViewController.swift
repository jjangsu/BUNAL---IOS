//
//  ViewController.swift
//  BuNal
//
//  Created by kpugame on 2020/06/03.
//  Copyright © 2020 minjoooo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //logo scene
    @IBOutlet weak var LogoImageView: UIImageView!
    @IBAction func logoTapped(sender: AnyObject) {
        guard let searchScene = self.storyboard?.instantiateViewController(withIdentifier: "SearchScene") else {
            return
        }
        searchScene.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.navigationController?.pushViewController(searchScene, animated: true)
    }
    
    //search scene
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LogoImageView.image = UIImage(named: "Resource/BunalLogoImage.png")
    }


}

