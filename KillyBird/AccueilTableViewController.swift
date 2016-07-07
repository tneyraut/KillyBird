//
//  AccueilTableViewController.swift
//  KillyBird
//
//  Created by Thomas Mac on 29/06/2016.
//  Copyright © 2016 ThomasNeyraut. All rights reserved.
//

import UIKit

class AccueilTableViewController: UITableViewController {

    private let sauvegarde = NSUserDefaults()
    
    internal var backgroundImageNumber = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerClass(TableViewCellWithImage.classForCoder(), forCellReuseIdentifier:"cell")
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier:"cell1")
        
        self.title = "Killy Bird : Menu Principal"
        
        self.backgroundImageNumber = self.sauvegarde.integerForKey("BackgroundImageNumber")
        if (self.backgroundImageNumber == 0)
        {
            self.backgroundImageNumber = 1
            self.sauvegarde.setInteger(1, forKey:"BackgroundImageNumber")
        }
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let buttonPrevious = UIBarButtonItem(title:"Retour", style:UIBarButtonItemStyle.Done, target:nil, action:nil)
        buttonPrevious.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.backBarButtonItem = buttonPrevious
        
        let settingsButton = UIBarButtonItem(title:"Settings", style:UIBarButtonItemStyle.Done, target:self, action:#selector(self.settingsButtonActionListener))
        settingsButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        self.navigationItem.rightBarButtonItem = settingsButton
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.sauvegarde.setInteger(self.backgroundImageNumber, forKey:"BackgroundImageNumber")
        self.sauvegarde.synchronize()
        
        self.navigationController?.setNavigationBarHidden(false, animated:true)
        
        self.navigationController?.setToolbarHidden(false, animated:true)
        
        self.navigationController?.toolbar.barTintColor = UIColor(red:0.439, green:0.776, blue:0.737, alpha:1)
        
        let shadow = NSShadow()
        
        shadow.shadowColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        
        shadow.shadowOffset = CGSizeMake(0, 1)
        
        let playButton = UIBarButtonItem(title:"Play", style:.Plain, target:self, action:#selector(self.playButtonActionListener))
        
        playButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red:245.0/255.0, green:245.0/255.0, blue:245.0/255.0, alpha:1.0), NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name:"HelveticaNeue-CondensedBlack", size:21.0)!], forState:UIControlState.Normal)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:nil, action:nil)
        
        self.navigationController?.toolbar.setItems([flexibleSpace, playButton, flexibleSpace], animated:true)
        
        super.viewDidAppear(animated)
    }
    
    @objc private func settingsButtonActionListener()
    {
        let settingsViewController = SettingsViewController()
        
        settingsViewController.accueilTableViewController = self
        
        self.navigationController?.pushViewController(settingsViewController, animated:true)
    }
    
    @objc private func playButtonActionListener()
    {
        let gameViewController = GameViewController()
        
        gameViewController.accueilTableViewController = self
        
        self.navigationController?.pushViewController(gameViewController, animated:true)
    }
    
    private func getNumberOfItems() -> Int
    {
        return self.sauvegarde.integerForKey("NumberOfScores")
    }
    
    internal func gameFinish(score: Int)
    {
        if (score == 0)
        {
            return
        }
        self.sauvegarde.setInteger(self.sauvegarde.integerForKey("NumberOfScores") + 1, forKey:"NumberOfScores")
        if (self.getNumberOfItems() == 1)
        {
            self.sauvegarde.setInteger(score, forKey:"Score0")
        }
        else
        {
            var i = 0
            while (i < self.getNumberOfItems())
            {
                if (self.sauvegarde.integerForKey("Score" + String(i)) < score)
                {
                    self.sauvegarde.setInteger(self.sauvegarde.integerForKey("Score" + String(self.getNumberOfItems() - 2)), forKey:"Score" + String(self.getNumberOfItems() - 1))
                    var j = self.getNumberOfItems() - 2
                    while (j > i)
                    {
                        self.sauvegarde.setInteger(self.sauvegarde.integerForKey("Score" + String(j - 1)), forKey:"Score" + String(j))
                        j -= 1
                    }
                    self.sauvegarde.setInteger(score, forKey:"Score" + String(i))
                    break
                }
                i += 1
            }
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.getNumberOfItems() == 0)
        {
            return 1
        }
        return self.getNumberOfItems()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (self.getNumberOfItems() == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            
            cell.textLabel?.text = "Aucun score enregistré"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCellWithImage

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.textLabel?.numberOfLines = 0
        
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        
        cell.textLabel?.text = "Score N°" + String(indexPath.row + 1) + " : " + String(self.sauvegarde.integerForKey("Score" + String(indexPath.row)))
        
        cell.imageView?.image = UIImage(named:NSLocalizedString("ICON_SCORE", comment:""))

        return cell
    }

}
