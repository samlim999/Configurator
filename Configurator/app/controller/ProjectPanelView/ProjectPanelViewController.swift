//
//  ProjectPanelViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/13/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit

class ProjectPanelViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var panelProject: UIView!
    @IBOutlet weak var collectionViewForClients: UICollectionView!
    
    public  var mainViewController: MainViewController!
    private var hoverIndex: Int         = -1;
    private var clients: Array<Client>  = ClientManager.getClients()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.clientRemoved(_:)), name: NSNotification.Name(rawValue: C.CLIENT_REMOVED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.clientsDownloaded(_:)), name: NSNotification.Name(rawValue: C.CLIENTS_DOWNLOADED), object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func clientRemoved(_ notification: NSNotification)
    {
        self.clients    = ClientManager.getClients()
        
        self.collectionViewForClients.reloadData()
    }
    
    func reloadClients()
    {
        ClientService.getClients(user: UserManager.getLoggedInUser()!)
    }
    
    func clientsDownloaded(_ notification: NSNotification)
    {
        self.clients    = ClientManager.getClients()
        self.collectionViewForClients.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return clients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "project_cell", for: indexPath as IndexPath)
        
        if let cell = cell as? ProjectCollectionViewCell
        {
            if indexPath.row == hoverIndex
            {
                print("indexPath.row :", indexPath.row)
                cell.viewForHoverProject.isHidden = false
            }
            else
            {
                cell.viewForHoverProject.isHidden = true
            }
            
            cell.parentViewController = self
            cell.setupCell(client: clients[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        hoverIndex = indexPath.row
        collectionView.reloadData()
    }
    
    @IBAction func addClientClicked(_ sender: Any)
    {
        mainViewController.setupEditClientView(client: Client())
    }
}
