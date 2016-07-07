//
//  SettingsViewController.swift
//  KillyBird
//
//  Created by Thomas Mac on 29/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    internal var backgroundImageNumber = 1
    
    internal var accueilTableViewController = AccueilTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Killy Bird : Settings"
        
        self.backgroundImageNumber = self.accueilTableViewController.backgroundImageNumber
        
        self.view.backgroundColor = UIColor(patternImage:UIImage(named:NSLocalizedString("BACKGROUND_IMAGE_" + String(self.backgroundImageNumber), comment:""))!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        self.navigationController?.toolbar.barTintColor = UIColor(red:0.439, green:0.776, blue:0.737, alpha:1)
        
        let shadow = NSShadow()
        
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let nextButton = UIBarButtonItem(title:"Next", style:.Plain, target:self, action:#selector(self.nextButtonActionListener))
        
        nextButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let previousButton = UIBarButtonItem(title:"Previous", style:.Plain, target:self, action:#selector(self.previousButtonActionListener))
        
        previousButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let validateButton = UIBarButtonItem(title:"OK", style:.Plain, target:self, action:#selector(self.validateButtonActionListener))
        
        validateButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([previousButton, flexibleSpace, validateButton, flexibleSpace, nextButton], animated:true)
        
        super.viewDidAppear(animated)
    }

    @objc private func nextButtonActionListener()
    {
        if (self.backgroundImageNumber == 6)
        {
            self.backgroundImageNumber = 1
        }
        else
        {
            self.backgroundImageNumber += 1
        }
        self.view.backgroundColor = UIColor(patternImage:UIImage(named:NSLocalizedString("BACKGROUND_IMAGE_" + String(self.backgroundImageNumber), comment:""))!)
    }
    
    @objc private func previousButtonActionListener()
    {
        if (self.backgroundImageNumber == 1)
        {
            self.backgroundImageNumber = 6
        }
        else
        {
            self.backgroundImageNumber -= 1
        }
        self.view.backgroundColor = UIColor(patternImage:UIImage(named:NSLocalizedString("BACKGROUND_IMAGE_" + String(self.backgroundImageNumber), comment:""))!)
    }
    
    @objc private func validateButtonActionListener()
    {
        self.accueilTableViewController.backgroundImageNumber = self.backgroundImageNumber
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
