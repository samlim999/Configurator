//
//  PanelViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/13/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit
import AlamofireImage

class PanelViewController: UIViewController
{
    @IBOutlet weak var imageForUserInPanel: UIImageView!
    public  var mainViewController: MainViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let user:User                               = UserManager.getLoggedInUser()!
        let userImageUrl: URL                       = URL(string:C.BASE_URL + user.avatar)!
        
        let size                                    = CGSize(width: 300.0, height: 300.0)
        let imageFilter                             = AspectScaledToFillSizeCircleFilter(size: size)
        
        
        self.imageForUserInPanel.af_setImage(withURL: userImageUrl, placeholderImage: nil, filter: imageFilter, imageTransition: .crossDissolve(0.2))
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addClientClicked(_ sender: UIButton)
    {
        mainViewController.setupEditClientView(client: Client())
    }
}
