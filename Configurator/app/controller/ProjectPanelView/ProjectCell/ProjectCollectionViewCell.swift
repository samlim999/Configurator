//
//  ProjectCollectionViewCell.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/13/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit

class ProjectCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var imageForProject: UIImageView!

    @IBOutlet weak var labelForClientname: UILabel!
    @IBOutlet weak var labelForPointsCount: UILabel!
    
    @IBOutlet weak var viewForHoverProject: UIView!
    
    public var parentViewController: ProjectPanelViewController!
    private var client:Client!
    
    public func setupCell(client:Client)
    {
        self.client                     = client
        client.setObjects()
        
        var clientImageUrl:URL?
        
        if (client.points_image != "")
        {
            clientImageUrl      = URL(string:C.BASE_URL + client.points_image)!
        }
        else
        {
            clientImageUrl      = URL(string:C.BASE_URL + client.image)!
        }
        
        self.imageForProject.af_setImage(withURL: clientImageUrl!)
        self.labelForClientname.text    = client.clientname
        self.labelForPointsCount.text   = client.points_count + " Konfigurationen"
    }
    
    @IBAction func editProjectClicked(_ sender: Any)
    {
    }
    
    @IBAction func emailProjectClicked(_ sender: Any)
    {
    }
    
    @IBAction func printProjectClicked(_ sender: Any)
    {
    }

    @IBAction func goWorkspaceClicked(_ sender: Any)
    {
        parentViewController.mainViewController.setupWorkspaceView(client: self.client)
    }
    
    @IBAction func deleteProjectClicked(_ sender: Any)
    {
        ClientService.removeClient(client: self.client)
    }
}
