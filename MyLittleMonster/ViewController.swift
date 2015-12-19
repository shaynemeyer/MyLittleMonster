//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Shayne on 12/19/15.
//  Copyright © 2015 Maynesoft LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        var imgArray = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "idle\(x).png")
            imgArray.append(img!)
        }
        
        monsterImg.animationImages = imgArray
        monsterImg.animationDuration = 0.8
        monsterImg.animationRepeatCount = 0
        monsterImg.startAnimating()
    }

    

}

