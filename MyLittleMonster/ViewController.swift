//
//  ViewController.swift
//  MyLittleMonster
//
//  Created by Shayne on 12/19/15.
//  Copyright © 2015 Maynesoft LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    
    @IBOutlet weak var penaltyImg1: UIImageView!
    @IBOutlet weak var penaltyImg2: UIImageView!
    @IBOutlet weak var penaltyImg3: UIImageView!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        foodImg.dropTarget  = monsterImg
        heartImg.dropTarget = monsterImg
        
        penaltyImg1.alpha = DIM_ALPHA
        penaltyImg2.alpha = DIM_ALPHA
        penaltyImg3.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL:
                NSURL(fileURLWithPath:
                    NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL:
                NSURL(fileURLWithPath:
                    NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL:
                NSURL(fileURLWithPath:
                    NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL:
                NSURL(fileURLWithPath:
                    NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL:
                NSURL(fileURLWithPath:
                    NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxBite.play()
            
            sfxHeart.prepareToPlay()
            sfxHeart.play()
            
            sfxDeath.prepareToPlay()
            sfxDeath.play()
            
            sfxSkull.prepareToPlay()
            sfxSkull.play()
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            // heart
            sfxHeart.play()
        } else {
            // food 
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penaltyImg1.alpha = OPAQUE
                penaltyImg2.alpha = DIM_ALPHA
                penaltyImg3.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penaltyImg2.alpha = OPAQUE
                penaltyImg3.alpha = DIM_ALPHA
            } else {
                penaltyImg1.alpha = DIM_ALPHA
                penaltyImg2.alpha = DIM_ALPHA
                penaltyImg3.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                timer.invalidate()
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }

}

