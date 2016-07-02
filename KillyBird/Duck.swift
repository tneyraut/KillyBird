//
//  Duck.swift
//  KillyBird
//
//  Created by Thomas Mac on 30/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class Duck: NSObject {
    
    private var timer = NSTimer()
    
    internal let imageView = UIImageView()
    
    private var direction = 1
    
    private var gameViewController = GameViewController()
    
    internal func initInstanceInViewController(gameViewController: GameViewController)
    {
        self.gameViewController = gameViewController
        
        self.setImageView()
        
        self.gameViewController.view.addSubview(self.imageView)
    }
    
    internal func setImageView()
    {
        self.setRandomDirection()
        
        self.imageView.frame = CGRectMake(self.getInitX(100.0), self.getRandomY(50.0), 100.0, 50.0)
        
        if (self.direction == 1)
        {
            self.imageView.image = UIImage(named:NSLocalizedString("DUCK_GAUCHE_DROITE", comment:""))
        }
        else
        {
            self.imageView.image = UIImage(named:NSLocalizedString("DUCK_DROITE_GAUCHE", comment:""))
        }
        self.imageView.hidden = false
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target:self, selector:#selector(self.move), userInfo:nil, repeats:true)
    }
    
    private func setRandomDirection()
    {
        self.direction = Int(arc4random_uniform(2))
        if (self.direction == 0)
        {
            self.direction = -1
        }
    }
    
    private func getInitX(width: CGFloat) -> CGFloat
    {
        if (self.direction == 1)
        {
            return -width
        }
        else
        {
            return self.gameViewController.view.frame.size.width
        }
    }
    
    private func getRandomY(height: CGFloat) -> CGFloat
    {
        return CGFloat(arc4random_uniform(UInt32(self.gameViewController.view.frame.size.height - height)))
    }
    
    @objc private func move()
    {
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x + CGFloat(self.direction), self.imageView.frame.origin.y, self.imageView.frame.size.width, self.imageView.frame.size.height)
        
        if ((self.direction == 1 && self.imageView.frame.origin.x > self.gameViewController.view.frame.size.width) || (self.direction == -1 && self.imageView.frame.origin.x + self.imageView.frame.size.width < 0))
        {
            self.stopMove()
            self.gameViewController.looseOneVie()
            if (!self.gameViewController.endOfGame())
            {
                self.setImageView()
            }
        }
    }
    
    internal func stopMove()
    {
        self.timer.invalidate()
        self.imageView.hidden = true
    }
    
}
