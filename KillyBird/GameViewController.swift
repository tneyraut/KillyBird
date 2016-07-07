//
//  GameViewController.swift
//  KillyBird
//
//  Created by Thomas Mac on 29/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class GameViewController: UIViewController {
    
    internal var accueilTableViewController = AccueilTableViewController()
    
    private var score = 0
    
    private var vie = 5
    
    private var timerReload = NSTimer()
    
    private var reloadFinish = true
    
    private let vieImageView = ImageViewWithLabel()
    
    private let ducksArray = NSMutableArray()
    
    private var pallier = 5
    
    private let reticule = UIImageView()
    
    private let accelerometre = CMMotionManager()
    
    private let location = CLLocationManager()
    
    private var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage:UIImage(named:NSLocalizedString("BACKGROUND_IMAGE_" + String(self.accueilTableViewController.backgroundImageNumber), comment:""))!)
        
        self.location.delegate = nil
        self.location.headingFilter = kCLHeadingFilterNone
        self.location.distanceFilter = kCLHeadingFilterNone
        self.location.desiredAccuracy = kCLLocationAccuracyBest
        
        self.accelerometre.accelerometerUpdateInterval = 0.1
        
        self.vieImageView.frame = CGRectMake(self.view.frame.size.width - 50.0 - 10.0, 10.0, 50.0, 50.0)
        
        self.vieImageView.image = UIImage(named:NSLocalizedString("ICON_COEUR", comment:""))
        
        self.vieImageView.hidden = false
        
        self.vieImageView.label.text = "x" + String(self.vie)
        
        self.view.addSubview(self.vieImageView)
        
        self.reticule.frame = CGRectMake(self.view.frame.size.width / 2 - 25.0, self.view.frame.size.height / 2 - 25.0, 50.0, 50.0)
        
        self.reticule.image = UIImage(named:NSLocalizedString("ICON_RETICULE", comment:""))
        
        self.reticule.hidden = false
        
        self.view.addSubview(self.reticule)
        
        self.addDuck()
        
        self.accelerometre.startAccelerometerUpdates()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:#selector(self.moveReticule), userInfo:nil, repeats:true)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated:true)
        
        self.navigationController?.setToolbarHidden(true, animated:true)
        
        super.viewDidAppear(animated)
    }
    
    @objc private func moveReticule()
    {
        if (self.accelerometre.accelerometerData?.acceleration.y == nil || self.accelerometre.accelerometerData?.acceleration.x == nil)
        {
            return
        }
        
        let newX = self.reticule.frame.origin.x + CGFloat((self.accelerometre.accelerometerData?.acceleration.y)!) * 20
        
        var newY = self.reticule.frame.origin.y
        if (self.accelerometre.accelerometerData?.acceleration.z >= -0.5)
        {
            newY += (CGFloat((self.accelerometre.accelerometerData?.acceleration.z)!) + 0.5) * 20
            // vers le bas
        }
        else if (self.accelerometre.accelerometerData?.acceleration.z <= -0.7)
        {
            newY += CGFloat((self.accelerometre.accelerometerData?.acceleration.z)!) * 10
            // vers le haut
        }
        
        if (newX < 0 || newX + self.reticule.frame.size.width > self.view.frame.size.width || newY < 0 || newY + self.reticule.frame.size.height > self.view.frame.size.height)
        {
            return
        }
        
        self.reticule.frame = CGRectMake(newX, newY, self.reticule.frame.size.width, self.reticule.frame.size.height)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (!self.reloadFinish)
        {
            return
        }
        self.reloadFinish = false
        
        //let touch = touches.first
        //let currentPosition = touch?.locationInView(nil)
        let currentPosition = self.reticule.center
        
        var i = 0
        while (i < self.ducksArray.count)
        {
            let duck = self.ducksArray[i] as! Duck
            
            if (currentPosition.x >= duck.imageView.frame.origin.x && currentPosition.x <= duck.imageView.frame.origin.x + duck.imageView.frame.size.width && currentPosition.y >= duck.imageView.frame.origin.y && currentPosition.y <= duck.imageView.frame.origin.y + duck.imageView.frame.size.height)
            {
                duck.stopMove()
                duck.setImageView()
                self.duckKilled()
            }
            i += 1
        }
        self.timerReload = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:#selector(self.reload), userInfo:nil, repeats:true)
    }
    
    private func duckKilled()
    {
        self.score += 1
        if (self.score == self.pallier)
        {
            self.pallier *= 2
            self.vie += 1
            self.vieImageView.label.text = "x" + String(self.vie)
            
            self.addDuck()
        }
    }
    
    @objc private func reload()
    {
        self.timerReload.invalidate()
        self.reloadFinish = true
    }
    
    private func addDuck()
    {
        let duck = Duck()
        
        duck.initInstanceInViewController(self)
        
        self.ducksArray.addObject(duck)
    }
    
    internal func looseOneVie()
    {
        self.vie -= 1
        self.vieImageView.label.text = "x" + String(self.vie)
        if (self.vie < 0)
        {
            self.timerReload.invalidate()
            self.reloadFinish = false
            var i = 0
            while (i < self.ducksArray.count)
            {
                let duck = self.ducksArray[i] as! Duck
                
                duck.stopMove()
                
                i += 1
            }
            self.timer.invalidate()
            let alertController = UIAlertController(title:"Fin de la partie", message:"Vous avez épuisé toutes vos vies. Vous avez marqué " + String(self.score) + " points .", preferredStyle:.Alert)
            
            let alertAction = UIAlertAction(title:"OK", style:.Default) { (_) in
                if (self.score > 0)
                {
                    self.accueilTableViewController.gameFinish(self.score)
                }
                self.navigationController?.popViewControllerAnimated(true)
            }
            alertController.addAction(alertAction)
            
            self.presentViewController(alertController, animated:true, completion:nil)
        }
    }

    internal func endOfGame() -> Bool
    {
        return self.vie < 0
    }
    
}
