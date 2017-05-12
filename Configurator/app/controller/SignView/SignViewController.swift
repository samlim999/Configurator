//
//  SignViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 2/28/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit
import ACEDrawingView
import AlamofireImage

class SignViewController: UIViewController, ACEDrawingViewDelegate
{
    @IBOutlet weak var viewForDrawSign: UIView!
    @IBOutlet weak var viewForSignSuccess: UIView!
    @IBOutlet weak var viewForDrawingArea: ACEDrawingView!
    @IBOutlet weak var labelForClientName: UILabel!
    @IBOutlet weak var labelForDate: UILabel!
    @IBOutlet weak var labelForSuccessTitle: UILabel!
    @IBOutlet weak var imageForClient: UIImageView!
    
    public  var mainViewController: MainViewController!
    private var client:Client               = Client()
    private var isCreating:Bool             = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.labelForClientName.text            = self.client.clientname
        
        let date                                = Date()
        let formatter                           = DateFormatter()
        formatter.dateFormat                    = "d. MMMM yyyy"
        formatter.locale                        = NSLocale(localeIdentifier: "de_DE") as Locale!
        let result                              = formatter.string(from: date)
        self.labelForDate.text                  = result
        
        self.viewForDrawingArea.delegate        = self
        self.viewForDrawingArea.lineColor       = UIColor.black
        self.viewForDrawingArea.drawTool        = ACEDrawingToolTypePen
        self.viewForDrawingArea.usingDashArray  = false
        self.viewForDrawingArea.lineWidth       = 6
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setClient(client: Client, isCreating: Bool)
    {
        self.client             = client
        self.isCreating         = isCreating
    }
    
    private func goNext ()
    {
        if (self.isCreating)
        {
            mainViewController.setupWorkspaceView(client: self.client)
        }
        else
        {
            self.viewForDrawSign.isHidden       = true
            self.viewForSignSuccess.isHidden    = false
            
            self.labelForSuccessTitle.text      = "Vielen Dank für die Konfiguration, " + self.client.clientname
            let imageUrl:URL                    = URL(string:C.BASE_URL + self.client.image)!
            let size                            = CGSize(width: 300.0, height: 300.0)
            let imageFilter                     = AspectScaledToFillSizeCircleFilter(size: size)
            
            self.imageForClient.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: imageFilter, imageTransition: .crossDissolve(0.2))
        }
    }
    
    public func drawingView(_ view: ACEDrawingView!, didEndDrawUsing tool: ACEDrawingTool!)
    {

    }
    
    @IBAction func buttonClicked(_ sender: UIButton)
    {
        let tag     = sender.tag
        
        switch tag
        {
        case 1: // back
            mainViewController.removeModelView(viewController: self)
            break
        case 2: // next
            goNext()
            break
        case 3: // erase
            self.viewForDrawingArea.clear()
            break
        case 4: // success
            mainViewController.setupProjectPanelView()
            break
        default:
            break
        }
    }
}
