//
//  DrawPropertyViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/22/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit

class DrawPropertyViewController: UIViewController
{
    @IBOutlet weak var textviewForDescription: UITextView!
    
    public var mainViewController: MainViewController!
    public var object:Object!
    
    override func viewDidLoad()
    {
        self.textviewForDescription.text    = object.description
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func actionClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1:
            object.description  = self.textviewForDescription.text
            break
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.REMOVE_SUB_VIEW), object: nil, userInfo: nil)
            break
        default:
            break
        }
        
        mainViewController.removeModelView(viewController: self)
    }
}
