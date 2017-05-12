//
//  MainViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/13/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit
import AlamofireImage

class MainViewController: UIViewController
{
    @IBOutlet weak var labelForUsernameInHeader: UILabel!
    @IBOutlet weak var imageForUserInHeader: UIImageView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewForWorkView: UIView!
    @IBOutlet weak var viewForProfileMenu: UIView!
    @IBOutlet weak var imageForUserInProfileMenu: UIImageView!
    @IBOutlet weak var labelForUsernameInProfileMenu: UILabel!
    @IBOutlet weak var labelForEmailInProfileMenu: UILabel!

    private var overlayView: UIView!
    private var prevOverViewController: UIViewController!
    
    private var modalView: UIView!
    private var prevModalViewController: UIViewController!
    
    private var isShownProfileMenu: Bool = false
    private var isAnimationingProfileMenu: Bool = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupHeader()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userUpdated(_:)), name: NSNotification.Name(rawValue: C.USER_UPDATED), object: nil)
//        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.hidePopupMenu (_:)))
//        self.view.addGestureRecognizer(gesture)
//        setupPanelView()
//        setupEditClientView()
//        setupTakePictureView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        if (self.prevOverViewController != nil)
        {
            removeOverlayView(viewController: self.prevOverViewController)
        }
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func userUpdated(_ notification: NSNotification)
    {
        setupHeader()
    }
    
    private func setupHeader ()
    {
        let user:User                               = UserManager.getLoggedInUser()!
        
        self.labelForUsernameInHeader.text          = user.fullname
        self.labelForUsernameInProfileMenu.text     = user.fullname
        self.labelForEmailInProfileMenu.text        = user.username
        
        let userImageUrl: URL                       = URL(string:C.BASE_URL + user.avatar)!
        
        let size                                    = CGSize(width: 90.0, height: 90.0)
        let imageFilter                             = AspectScaledToFillSizeCircleFilter(size: size)
        
        self.imageForUserInHeader.af_setImage(withURL: userImageUrl, placeholderImage: nil, filter: imageFilter, imageTransition: .crossDissolve(0.2))
        self.imageForUserInProfileMenu.af_setImage(withURL: userImageUrl, placeholderImage: nil, filter: imageFilter, imageTransition: .crossDissolve(0.2))
    }
    
    public func setupPanelView()
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"panelViewController") as! PanelViewController
        
        viewController.mainViewController = self
        addOverlayView(viewController: viewController)
    }
    
    public func setupProjectPanelView()
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"projectPanelViewController") as! ProjectPanelViewController
        
        viewController.reloadClients()
        viewController.mainViewController = self
        
        addOverlayView(viewController: viewController)
    }
    
    public func setupWorkspaceView(client:Client)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"workspaceViewController") as! WorkspaceViewController
        
        viewController.setClient(client: client)
        viewController.mainViewController = self
        addOverlayView(viewController: viewController)
    }
    
    public func setupEditAccountView()
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"editAccountViewController") as! EditAccountViewController
        
        viewController.mainViewController = self
        addOverlayView(viewController: viewController)
    }
    
    public func setupEditClientView(client: Client)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"editClientViewController") as! EditClientViewController

        viewController.setClient(client: client)
        viewController.mainViewController = self
        addModalView(viewController: viewController)
    }
    
    public func setupDrawSignView(client: Client, isCreating:Bool)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"signViewController") as! SignViewController
        
        viewController.setClient(client: client, isCreating: isCreating)
        viewController.mainViewController = self
        addModalView(viewController: viewController)
    }
    
    public func setupPointPropertyView(object: Object)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"pointPropertyViewController") as! PointPropertyViewController
        
        viewController.mainViewController   = self
        viewController.object               = object
        
        addModalView(viewController: viewController)
    }
    
    public func setupDrawPropertyView(object: Object)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"drawPropertyViewController") as! DrawPropertyViewController
        
        viewController.mainViewController   = self
        viewController.object               = object
        
        addModalView(viewController: viewController)
    }

    public func setupDefinedPropertyView(object: Object)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"definedPropertyViewController") as! DefinedPropertyViewController
        
        viewController.mainViewController   = self
        viewController.object               = object
        
        addModalView(viewController: viewController)
    }

    public func setupTakePictureView(fromWorkspace: Bool)
    {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let viewController  = storyboard.instantiateViewController(withIdentifier :"takePictureViewController") as! TakePictureViewController
        
        viewController.callingFromWorkspace = fromWorkspace
        viewController.mainViewController   = self
        addModalView(viewController: viewController)
    }
    
    private func addOverlayView(viewController: UIViewController)
    {
        let appDelegate                     = UIApplication.shared.delegate as! AppDelegate
        appDelegate.canSupportPortraitMode  = false
        
        if (isShownProfileMenu)
        {
            hideProfileMenu()
        }
        
        if (self.prevOverViewController != nil)
        {
            removeOverlayView(viewController: self.prevOverViewController)
        }
        
        self.overlayView                = viewController.view
        self.addChildViewController(viewController)
        self.viewForWorkView.addSubview(self.overlayView)
        self.view.bringSubview(toFront: viewForHeader)
        viewController.didMove(toParentViewController: self)
        self.prevOverViewController     = viewController
    }

    public func removeOverlayView(viewController: UIViewController)
    {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        
        if (self.prevModalViewController != nil)
        {
            removeModelView(viewController: self.prevModalViewController)
        }
    }
    
    private func addModalView(viewController: UIViewController)
    {
        let appDelegate                     = UIApplication.shared.delegate as! AppDelegate
        appDelegate.canSupportPortraitMode  = false
        
        if (isShownProfileMenu)
        {
            hideProfileMenu()
        }
        
        self.modalView                  = viewController.view
        self.addChildViewController(viewController)
        self.viewForWorkView.addSubview(self.modalView)
        self.view.bringSubview(toFront: viewForHeader)
        viewController.didMove(toParentViewController: self)
        self.prevModalViewController    = viewController
    }
    
    public func removeModelView(viewController: UIViewController)
    {
        let appDelegate                     = UIApplication.shared.delegate as! AppDelegate
        appDelegate.canSupportPortraitMode  = false
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
        self.modalView                      = nil
        self.prevModalViewController        = nil
    }
    
    private func hideProfileMenu()
    {
        viewForProfileMenu.isHidden = false
        let frame = viewForProfileMenu.frame
        isAnimationingProfileMenu = true
        UIView.animate(withDuration: 0.7, animations:
        {
            self.viewForProfileMenu.frame   = CGRect(x: frame.origin.x, y: frame.origin.y - frame.size.height, width: frame.size.width, height: frame.size.height)
        }, completion: { (finished: Bool) in
            self.isShownProfileMenu         = false
            self.isAnimationingProfileMenu  = false
        })
    }
    
    private func showProfileMenu()
    {
        viewForProfileMenu.isHidden = false
        let frame = viewForProfileMenu.frame
        isAnimationingProfileMenu = true
        
        UIView.animate(withDuration: 0.7, animations:
            {
                self.viewForProfileMenu.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.size.height, width: frame.size.width, height: frame.size.height)
        }, completion: { (finished: Bool) in
            self.isShownProfileMenu = true
            self.isAnimationingProfileMenu = false
        })
    }
    
    func hidePopupMenu(_ sender:UITapGestureRecognizer)
    {
        if (isShownProfileMenu)
        {
            hideProfileMenu()
        }
    }
    
    @IBAction func dashboardMenuClicked(_ sender: Any)
    {
        if (isAnimationingProfileMenu)
        {
            return
        }
        
        if (isShownProfileMenu)
        {
            hideProfileMenu()
        }
        else
        {
            showProfileMenu()
        }
    }
    
    @IBAction func workspaceClicked(_ sender: Any)
    {
        setupProjectPanelView()
    }
    
    @IBAction func editAccountClicked(_ sender: UIButton)
    {
        setupEditAccountView()
    }
    
    @IBAction func logoutClicked(_ sender: UIButton)
    {
//        let _ = self.navigationController?.popViewController(animated: true);
        if (self.prevOverViewController != nil)
        {
            removeOverlayView(viewController: self.prevOverViewController)
        }
        dismiss(animated: true, completion: nil)
    }
}
