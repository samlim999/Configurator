//
//  WorkspaceViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/12/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit
import ACEDrawingView
import SVGgh

class WorkspaceViewController: UIViewController, UIGestureRecognizerDelegate, ACEDrawingViewDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var viewForRightSideBar: UIView!
    @IBOutlet weak var viewForRightSideBarMask: UIView!
    @IBOutlet weak var viewForDrawBottomBar: UIView!
    @IBOutlet weak var viewForDefinedBottomBar: UIView!
    @IBOutlet weak var viewForEmotionBottomBar: UIView!
    @IBOutlet weak var viewForEmotionsShownBar: UIView!
    
    @IBOutlet weak var buttonForHelp: UIButton!
    @IBOutlet weak var buttonForTakePicture: UIButton!
    @IBOutlet weak var buttonForPositionEdit: UIButton!
    @IBOutlet weak var viewForEditPositionButtons: UIView!
    @IBOutlet weak var viewForSaveCancelButtons: UIView!
    @IBOutlet weak var viewForWorkArea: UIView!
    @IBOutlet weak var viewForFaceMask: UIView!
    @IBOutlet weak var imageForFaceMask: UIImageView!
    @IBOutlet weak var imageForBackground: UIImageView!
    
    @IBOutlet var tapGestureForWorkArea: UITapGestureRecognizer!
    @IBOutlet var pinchGestureForWorkArea: UIPinchGestureRecognizer!
    @IBOutlet var panGestureForWorkArea: UIPanGestureRecognizer!
    @IBOutlet var rotationGestureForWorkArea: UIRotationGestureRecognizer!
    
    @IBOutlet weak var viewForEditButtons: UIView!
    @IBOutlet weak var viewForDrawingArea: ACEDrawingView!
    @IBOutlet weak var imageForDrawingArea: UIImageView!
    @IBOutlet weak var viewForEditBackground: UIView!
    @IBOutlet weak var buttonForEditObject: UIButton!
    
    @IBOutlet weak var viewForSummaryPreview: UIView!
    @IBOutlet weak var imageForSummaryPreview: UIImageView!
    @IBOutlet weak var viewForSummary: UIView!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var labelForClientName: UILabel!
    @IBOutlet weak var labelForAge: UILabel!
    @IBOutlet weak var labelForGender: UILabel!
    @IBOutlet weak var tableviewForSummaryInfo: UITableView!
    
    public  var mainViewController: MainViewController!
    
    private var client:Client                   = Client()
    private var mode: Int                       = 1
    private var sub_mode: Int                   = 1
    private var emotionSelected                 = [false, false, false, false]
    private var changingBackground              = false
    private var prevBackgroundImage: UIImage?
    private var prevBackgroundFrame: CGRect?
    private var backgroundImageUrl: String      = ""
    
    private var arrayOfViews                    = [UIView]()
    private var arrayOfObjects                  = [Object]()
    private var arrayOfLayers                   = [CAShapeLayer]()
    private var selectedView:UIView?
    
    private var uniqueID:Int                    = 0
    
    private var deltaX: CGFloat                 = 0
    private var deltaY: CGFloat                 = 0
    
    private var summaryDeltaX: CGFloat          = 0
    private var targetSize: CGSize?
    private var justBackgroundChanged:Bool      = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: self.buttonForHelp)
        self.view.bringSubview(toFront: self.buttonForTakePicture)
        
        self.prevBackgroundImage                = self.imageForBackground.image
        self.prevBackgroundFrame                = self.imageForBackground.frame
        
        self.targetSize                         = self.viewForWorkArea.frame.size
        
        uniqueID = 0
        enterMode(mode: 1)
        setupWorkarea()
        loadPoints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateClientSuccess(_:)), name: NSNotification.Name(rawValue: C.CLIENT_UPDATED), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateClientWithImageSuccess(_:)), name: NSNotification.Name(rawValue: C.CLIENT_UPDATED_WITH_IMAGE), object: nil)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func updateClientSuccess(_ notification: NSNotification)
    {
        self.prevBackgroundImage                = self.imageForBackground.image
        self.prevBackgroundFrame                = self.imageForBackground.frame
        
        self.client                             = ClientManager.getClient(clientId: self.client.id)!
        self.justBackgroundChanged              = true
        setupBackground()

        self.backgroundImageUrl = C.BASE_URL + self.client.image
        checkShowEditPositionButton()
//        updatePoints()
    }

    func updateClientWithImageSuccess(_ notification: NSNotification)
    {
        self.prevBackgroundImage                = self.imageForBackground.image
        self.prevBackgroundFrame                = self.imageForBackground.frame
        
        self.client                             = ClientManager.getClient(clientId: self.client.id)!
        self.justBackgroundChanged              = true
        setupBackground()

        self.backgroundImageUrl = C.BASE_URL + self.client.image
        checkShowEditPositionButton()
//        updatePoints()
    }
    
    private func loadPoints()
    {
        let objects:Objects = self.client.objects!
        
        if (objects.objects.count > 0)
        {
            for object in objects.objects
            {
                if (object.id == 0)
                {
                    loadBackground(object: object)
                }
                
                switch object.mode
                {
                case 1:
                    loadPoint(object: object)
                    break
                case 2:
                    loadPath(object: object)
                    break
                case 3:
                    loadDefined(object: object)
                    break
                default:
                    break
                }
            }
        }
        else
        {
            setupBackground()
        }
    }

    private func setupBackground()
    {
        let backgroundUrl:URL   = URL(string:C.BASE_URL + self.client.image)!
        self.imageForBackground.af_setImage(
            withURL: backgroundUrl,
            completion: {
                response in
                self.backgroundImageUrl = C.BASE_URL + self.client.image
                self.checkShowEditPositionButton()
                let imageFrame          = self.imageForBackground.image!.size
                let scale               = UIScreen.main.scale
                print("imageFrame width =\(imageFrame.width) height = \(imageFrame.height)")
                if (self.viewForWorkArea.frame.size.height > imageFrame.height * scale)
                {
                    let width               = imageFrame.width * scale
                    let height              = imageFrame.height * scale
                    
                    let xPos                = (self.viewForWorkArea.frame.size.width  - imageFrame.width * scale) / 2
                    let yPos                = (self.viewForWorkArea.frame.size.height - imageFrame.height * scale) / 2
                    
                    self.imageForBackground.frame   = CGRect(x: xPos, y: yPos, width: width, height: height)
                }
                else
                {
                    let ratio               = self.viewForWorkArea.frame.size.height / imageFrame.height * scale
                    
                    let width               = imageFrame.width * scale * ratio
                    let height              = self.viewForWorkArea.frame.size.height
                    
                    let xPos                = (self.viewForWorkArea.frame.size.width  - width) / 2
                    let yPos                = 0

                    self.imageForBackground.frame   = CGRect(x: xPos, y: CGFloat(yPos), width: width, height: height)
                    print("new width = \(self.imageForBackground.image!.size.width) height = \(self.imageForBackground.image!.size.height)")
                }
                
                if (self.justBackgroundChanged)
                {
                    self.updatePoints()
                    self.justBackgroundChanged  = false
                }
                print("width = \(self.imageForBackground.frame.size.width) height = \(self.imageForBackground.frame.size.height)")
        })
    }
    
    private func loadBackground(object: Object)
    {
        let backgroundUrl:URL   = URL(string:object.src)!
        self.backgroundImageUrl = object.src
        checkShowEditPositionButton()

        self.imageForBackground.af_setImage(withURL: backgroundUrl)
        let xPos                = (self.imageForBackground.frame.size.width  - CGFloat(object.width)) / 2
        let yPos                = (self.imageForBackground.frame.size.height - CGFloat(object.height)) / 2
        self.imageForBackground.frame   = CGRect(x: xPos, y: yPos, width: CGFloat(object.width), height: CGFloat(object.height))
        print("width = \(self.imageForBackground.frame.size.width) height = \(self.imageForBackground.frame.size.height)")
        
        self.deltaX             = CGFloat(object.left)  - self.imageForBackground.frame.origin.x
        self.deltaY             = CGFloat(object.top)   - self.imageForBackground.frame.origin.y
    }
    
    private func loadPoint(object: Object)
    {
        addLoadedImage(imageName: "image_point.png", object: object)
    }
   
    private func loadPath(object: Object)
    {
        let offset: CGPoint     = CGPoint(x: CGFloat(object.pathOffset.x - object.width / 2), y: CGFloat(object.pathOffset.y - object.height / 2));
        var cgPath: CGPath?
        
        switch object.type
        {
        case "path":
            cgPath              = SVGPathGenerator.newCGPath(fromSVGPath:convertPathArrayToString(pathArray: object.path), whileApplying:  CGAffineTransform.identity)!
            cgPath              = getRelativePath(cgPath: cgPath!, offset: offset)
            print(cgPath!.asString())
            break
        case "circle":
            cgPath              = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * CGFloat(object.radius), height: 2.0 * CGFloat(object.radius))  , cornerRadius: CGFloat(object.radius)).cgPath
            break
        case "polygon":
            object.width        = 34
            object.height       = 31
            
            let path            = UIBezierPath()
            
            path.move(to: CGPoint(x: 17, y: 0))
            path.addLine(to: CGPoint(x:34, y:31))
            path.addLine(to: CGPoint(x:0, y:31))
            
            path.close()
            cgPath              = path.cgPath
            break
        default:
            break
        }

        let shapeView               = CAShapeLayer()
        
        shapeView.path              = cgPath
        shapeView.lineCap           = "round"
        shapeView.lineJoin          = "round"
        shapeView.fillColor         = UIColor(white: 1, alpha: 0).cgColor
        shapeView.strokeColor       = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DRAW).cgColor
        shapeView.lineWidth         = CGFloat(object.strokeWidth)
        shapeView.lineDashPattern   = object.strokeDashArray as [NSNumber]?
        
        let pointView               = UIView()
        pointView.layer.addSublayer(shapeView)
        pointView.frame             = CGRect(x: CGFloat(object.left - object.width / 2) - self.deltaX, y: CGFloat(object.top - object.height / 2) - self.deltaY, width: CGFloat(object.width), height: CGFloat(object.height))
        pointView.transform         = pointView.transform.scaledBy(x: CGFloat(object.scaleX), y: CGFloat(object.scaleY))

        addSubView(view: pointView, object: object, layer: shapeView, isLoading: true)
    }
    
    private func loadDefined(object: Object)
    {
        var imageName: String?
        
        switch object.sub_category
        {
        case "zones_eyes":      //eye
            imageName       = "image_eye_area"
            break
        case "zones_nose":      //nose
            imageName       = "image_nose_area"
            break
        case "zones_cheek":     //cheek
            imageName       = "image_cheek_area"
            break
        case "zones_forehead":  //forehead
            imageName       = "image_forehead_area"
            break
        case "zones_mouth":     //mouth
            imageName       = "image_mouth_area"
            break
        case "zones_chin":      //chin
            imageName       = "image_chin_area"
            break
        case "zones_neck":      //neck
            imageName       = "image_neck_area"
            break
        case "zones_teeth":     //teeth
            imageName       = "image_mouth_area"
            break
        case "zones_hair":      //hair
            imageName       = "image_hair_area"
            break
        default:
            return
        }
        
        addLoadedImage(imageName: imageName!, object: object)
    }
    
    private func addLoadedImage(imageName: String, object:Object)
    {
        let imageview           = UIImageView(image: UIImage(named: imageName)!)
        let containerView       = UIView()
        
        imageview.frame         = CGRect(x: 0, y: 0, width: CGFloat(object.width), height: CGFloat(object.height))
        containerView.addSubview(imageview)
        containerView.frame     = CGRect(x: CGFloat(object.left) - self.deltaX, y: CGFloat(object.top) - self.deltaY, width: CGFloat(object.width), height: CGFloat(object.height))
        containerView.transform = containerView.transform.scaledBy(x: CGFloat(object.scaleX), y: CGFloat(object.scaleY))
        containerView.frame     = CGRect(x: CGFloat(object.left) - self.deltaX, y: CGFloat(object.top) - self.deltaY, width: containerView.frame.size.width, height: containerView.frame.size.height)
        
        let layer:CAShapeLayer  = CAShapeLayer()
        
        addSubView(view: containerView, object: object, layer: layer, isLoading: true)
    }
    
    func setClient(client: Client)
    {
        self.client             = client
    }
    
    func backgroundImageChanged(_ notification: NSNotification)
    {
        if let image = notification.userInfo?["image"] as? UIImage
        {
//            self.imageForBackground.image           = image
            ClientService.updateClient(client: self.client, image:image.resizeImage(toSize: self.targetSize!), uploadImage: true)
            changingBackgroundMode()
        }
    }
    
    private func changingBackgroundMode()
    {
        self.imageForFaceMask.isHidden              = false
        self.viewForEditPositionButtons.isHidden    = false
        self.viewForSaveCancelButtons.isHidden      = false
        self.buttonForPositionEdit.isHidden         = false
        
        self.viewForDrawBottomBar.isHidden          = true
        self.viewForDefinedBottomBar.isHidden       = true
        self.viewForEmotionBottomBar.isHidden       = true
        self.viewForRightSideBarMask.isHidden       = false
        self.viewForDrawingArea.isHidden            = true
        self.viewForEditBackground.isHidden         = false
        
        self.mode                                   = 0
        self.changingBackground                     = true
        
        initRightSideBarMenu()
    }
    
    func removeSubViewFunc(_ notification: NSNotification)
    {
        removeSubView()
    }
    
    private func setupWorkarea()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundImageChanged(_:)), name: NSNotification.Name(rawValue: C.NEW_PHOTO_CHANGED_WORKSPACE), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeSubViewFunc(_:)), name: NSNotification.Name(rawValue: C.REMOVE_SUB_VIEW), object: nil)
        
        self.tapGestureForWorkArea.require(toFail: self.pinchGestureForWorkArea)
        self.tapGestureForWorkArea.require(toFail: self.panGestureForWorkArea)
        self.tapGestureForWorkArea.require(toFail: self.rotationGestureForWorkArea)
        
        self.viewForDrawingArea.delegate        = self
        self.viewForDrawingArea.lineColor       = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DRAW)
        self.viewForDrawingArea.drawTool        = ACEDrawingToolTypePen
        self.viewForDrawingArea.usingDashArray  = true
        self.viewForDrawingArea.lineWidth       = 1.6
        self.viewForDrawingArea.isHidden        = true
        self.viewForEditBackground.isHidden     = true
    }
    
    private func initRightSideBarMenu()
    {
        for tag in 1 ... 4
        {
            let button  = self.viewForRightSideBar.viewWithTag(tag) as? UIButton
            let label   = self.viewForRightSideBar.viewWithTag(4 + tag) as? UILabel
            let image   = self.viewForRightSideBar.viewWithTag(8 + tag) as? UIImageView
            
            label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.NORMAL_STATE)
            button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_INIT)

            switch tag
            {
            case 1:
                image?.image = UIImage(named: "button_emotion")
                break
            case 2:
                image?.image = UIImage(named: "button_point")
                break
            case 3:
                image?.image = UIImage(named: "button_draw")
                break
            case 4:
                image?.image = UIImage(named: "button_defined")
                break
            default: break
            }
        }
    }
    
    private func initEmotionBottomBarMenu()
    {
        var posX:CGFloat    = 0
        
        for tag in 1 ... 4
        {
            let item    = self.viewForEmotionsShownBar.viewWithTag(tag)
            let button  = self.viewForEmotionBottomBar.viewWithTag(tag) as? UIButton
            let label   = self.viewForEmotionBottomBar.viewWithTag(4 + tag) as? UILabel
            let image   = self.viewForEmotionBottomBar.viewWithTag(8 + tag) as? UIImageView
            
            let frame   = item?.frame
            
            if (self.emotionSelected[tag - 1])
            {
                item?.isHidden          = false
                item?.frame             = CGRect(x: posX, y: frame!.origin.y, width: frame!.size.width, height: frame!.size.height)
                posX                    += frame!.size.width
                label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
                button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_EMOTION)
                
                switch tag
                {
                case 1:
                    image?.image = UIImage(named: "image_emotion1_selected")
                    break
                case 2:
                    image?.image = UIImage(named: "image_emotion2_selected")
                    break
                case 3:
                    image?.image = UIImage(named: "image_emotion3_selected")
                    break
                case 4:
                    image?.image = UIImage(named: "image_emotion4_selected")
                    break
                default: break
                }
            }
            else
            {
                item?.isHidden          = true
                label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.NORMAL_STATE)
                button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_INIT)
                
                switch tag
                {
                case 1:
                    image?.image = UIImage(named: "image_emotion1")
                    break
                case 2:
                    image?.image = UIImage(named: "image_emotion2")
                    break
                case 3:
                    image?.image = UIImage(named: "image_emotion3")
                    break
                case 4:
                    image?.image = UIImage(named: "image_emotion4")
                    break
                default: break
                }
            }
        }
    }
    
    private func initDrawBottomBarMenu()
    {
        for tag in 1 ... 5
        {
            let button  = self.viewForDrawBottomBar.viewWithTag(tag) as? UIButton
            let label   = self.viewForDrawBottomBar.viewWithTag(5 + tag) as? UILabel
            let image   = self.viewForDrawBottomBar.viewWithTag(10 + tag) as? UIImageView
            
            label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.NORMAL_STATE)
            button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_INIT)
            
            switch tag
            {
            case 1:
                image?.image = UIImage(named: "image_contour1")
                break
            case 2:
                image?.image = UIImage(named: "image_contour2")
                break
            case 3:
                image?.image = UIImage(named: "image_shape1")
                break
            case 4:
                image?.image = UIImage(named: "image_shape2")
                break
            case 5:
                image?.image = UIImage(named: "image_drawnobject")
                break
            default: break
            }
        }
    }
    
    private func initDefinedBottomBarMenu()
    {
        for tag in 1 ... 9
        {
            let button  = self.viewForDefinedBottomBar.viewWithTag(tag) as? UIButton
            let label   = self.viewForDefinedBottomBar.viewWithTag(10 + tag) as? UILabel
            let image   = self.viewForDefinedBottomBar.viewWithTag(20 + tag) as? UIImageView
            
            label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.NORMAL_STATE)
            button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_INIT)
            
            switch tag
            {
            case 1:
                image?.image = UIImage(named: "image_eye")
                break
            case 2:
                image?.image = UIImage(named: "image_nose")
                break
            case 3:
                image?.image = UIImage(named: "image_cheek")
                break
            case 4:
                image?.image = UIImage(named: "image_forehead")
                break
            case 5:
                image?.image = UIImage(named: "image_mouth")
                break
            case 6:
                image?.image = UIImage(named: "image_chin")
                break
            case 7:
                image?.image = UIImage(named: "image_neck")
                break
            case 8:
                image?.image = UIImage(named: "image_teeth")
                break
            case 9:
                image?.image = UIImage(named: "image_hair")
                break
            default: break
            }
        }
    }
    
    private func checkShowEditPositionButton()
    {
        if (self.backgroundImageUrl.contains("/upload/model_"))
        {
            self.buttonForPositionEdit.isHidden     = true
        }
        else
        {
            self.buttonForPositionEdit.isHidden     = false
        }
    }
    
    private func enterMode (mode: Int)
    {
        self.mode   = mode
        
        self.viewForSaveCancelButtons.isHidden      = true
        self.viewForEditPositionButtons.isHidden    = true

        self.imageForFaceMask.isHidden              = true
       
        let button  = self.viewForRightSideBar.viewWithTag(mode) as? UIButton
        let label   = self.viewForRightSideBar.viewWithTag(4 + mode) as? UILabel
        let image   = self.viewForRightSideBar.viewWithTag(8 + mode) as? UIImageView
        
        self.view.bringSubview(toFront: self.viewForRightSideBar)
        label?.textColor = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
        
        self.viewForEmotionBottomBar.isHidden   = true
        self.viewForDrawBottomBar.isHidden      = true
        self.viewForDefinedBottomBar.isHidden   = true
        self.viewForDrawingArea.isHidden        = true
        
        switch mode
        {
        case 1:
            self.viewForEmotionBottomBar.isHidden   = false
            image?.image                            = UIImage(named: "button_emotion_selected")
            button?.backgroundColor                 = ThemeUtil.getModeColor(type: C.MainMode.MAIN_EMOTION)
            self.view.bringSubview(toFront: self.viewForEmotionBottomBar)
            break
        case 2:
            image?.image                            = UIImage(named: "button_point_selected")
            button?.backgroundColor                 = ThemeUtil.getModeColor(type: C.MainMode.MAIN_POINT)
            break
        case 3:
            self.viewForDrawBottomBar.isHidden      = false
            image?.image                            = UIImage(named: "button_draw_selected")
            button?.backgroundColor                 = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DRAW)
            self.view.bringSubview(toFront: self.viewForDrawBottomBar)
            enterDrawSubMode(tag: 0)
            break
        case 4:
            self.viewForDefinedBottomBar.isHidden   = false
            image?.image                            = UIImage(named: "button_defined_selected")
            button?.backgroundColor                 = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DEFINED)
            self.view.bringSubview(toFront: self.viewForDefinedBottomBar)
            enterDrawSubMode(tag: 0)
            break
        default: break
        }
        
        self.viewForEditButtons.isHidden    = true
    }
    
    private func enterDrawSubMode (tag: Int)
    {
        let button  = self.viewForDrawBottomBar.viewWithTag(tag) as? UIButton
        let label   = self.viewForDrawBottomBar.viewWithTag(5 + tag) as? UILabel
        let image   = self.viewForDrawBottomBar.viewWithTag(10 + tag) as? UIImageView
        
        label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
        button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DRAW)
        self.viewForDrawingArea.isHidden    = true
        
        switch tag
        {
        case 1:
            image?.image = UIImage(named: "image_contour1_selected")
            break
        case 2:
            image?.image = UIImage(named: "image_contour2_selected")
            break
        case 3:
            image?.image = UIImage(named: "image_shape1_selected")
            break
        case 4:
            image?.image = UIImage(named: "image_shape2_selected")
            break
        case 5:
            image?.image = UIImage(named: "image_drawnobject_selected")
            self.viewForDrawingArea.isHidden    = false
            break
        default: break
        }
        
        self.sub_mode   = tag
    }
    
    private func enterDefinedSubMode (tag: Int)
    {
        let button  = self.viewForDefinedBottomBar.viewWithTag(tag) as? UIButton
        let label   = self.viewForDefinedBottomBar.viewWithTag(10 + tag) as? UILabel
        let image   = self.viewForDefinedBottomBar.viewWithTag(20 + tag) as? UIImageView
        
        label?.textColor        = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
        button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DEFINED)
        
        switch tag
        {
        case 1:
            image?.image = UIImage(named: "image_eye_selected")
            break
        case 2:
            image?.image = UIImage(named: "image_nose_selected")
            break
        case 3:
            image?.image = UIImage(named: "image_cheek_selected")
            break
        case 4:
            image?.image = UIImage(named: "image_forehead_selected")
            break
        case 5:
            image?.image = UIImage(named: "image_mouth_selected")
            break
        case 6:
            image?.image = UIImage(named: "image_chin_selected")
            break
        case 7:
            image?.image = UIImage(named: "image_neck_selected")
            break
        case 8:
            image?.image = UIImage(named: "image_teeth_selected")
            break
        case 9:
            image?.image = UIImage(named: "image_hair_selected")
            break
        default: break
        }
        
        self.sub_mode   = tag
    }
    
    private func addPoint (point: CGPoint, tag: Int)
    {
        let posX            = self.viewForFaceMask.frame.origin.x + point.x - 48
        let posY            = self.viewForFaceMask.frame.origin.y + point.y - 48
        
        let pointView       = UIView(frame: CGRect(x: posX, y: posY, width: 96, height: 96))
        let pointImage      = UIImageView(image: UIImage(named: "image_point.png")!)
        pointImage.frame    = CGRect(x: 0, y: 0, width: 96, height: 96)
        
        pointView.addSubview(pointImage)
        
        let object:Object       = Object()
        
        object.type             = "image"
        object.mode             = 1
        object.originX          = "left"
        object.originY          = "top"
        object.src              = C.BASE_URL + "/img/zone_point.svg"
        object.patternColor     = "rgb(43, 176, 212)"
        object.hasBorders       = false
        object.hasControls      = false

        let layer:CAShapeLayer  = CAShapeLayer()
        
        mainViewController.setupPointPropertyView(object: object)
        addSubView(view: pointView, object: object, layer: layer, isLoading: false)
    }
    
    private func addShape (point: CGPoint)
    {
        var width: CGFloat      = 0
        var height: CGFloat     = 0
        let object:Object       = Object()
        
        var cgPath: CGPath?
        
        switch self.sub_mode
        {
        case 1:
            width           = 47.75
            height          = 29
            cgPath          = SVGPathGenerator.newCGPath(fromSVGPath: "M4 7.58007813 C4 7.58007813 24.7426758 25.6437988 51.7543945 6.03442383", whileApplying:  CGAffineTransform.identity)
            
            object.pathOffset.x = 27.87719725
            object.pathOffset.y = 10.568941575170406
            
            let offset: CGPoint     = CGPoint(x: CGFloat(object.pathOffset.x) - width / 2, y: CGFloat(object.pathOffset.y) - height / 2);
            cgPath          = getRelativePath(cgPath: cgPath!, offset: offset)
            break
        case 2:
            width           = 47.75
            height          = 29
            cgPath          = SVGPathGenerator.newCGPath(fromSVGPath: "M0 14.5 L47.75 14.5", whileApplying:  CGAffineTransform.identity)
            break
        case 3:
            width           = 33
            height          = 33
            let radius      = 15.5
            cgPath          = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2.0 * radius, height: 2.0 * radius)  , cornerRadius: CGFloat(radius)).cgPath
            break
        case 4:
            width           = 34
            height          = 31
            let path        = UIBezierPath()
            path.move(to: CGPoint(x: 17, y: 0))
            path.addLine(to: CGPoint(x:34, y:31))
            path.addLine(to: CGPoint(x:0, y:31))

            path.close()
            cgPath          = path.cgPath
            break
        default:
            return
        }
     
        let shapeView       = createShapeView(cgPath: cgPath!)
        print("shape path = \(cgPath!.asString())")
        
        let posX            = self.viewForFaceMask.frame.origin.x + point.x - width / 2
        let posY            = self.viewForFaceMask.frame.origin.y + point.y - height / 2
        
        let pointView       = UIView(frame: CGRect(x: posX, y: posY, width: width, height: height))

        pointView.layer.addSublayer(shapeView)
        
        object.mode                 = 2
        object.type                 = "path"
        object.originX              = "center"
        object.originY              = "center"
        object.fill                 = "rgba(255, 255, 255, 0)"
        object.stroke               = "#83D7A4"
        object.strokeWidth          = 1.6
        object.strokeDashArray      = [3, 4]
        object.strokeLineCap        = "round"
        object.strokeLineJoin       = "round"
        object.strokeMiterLimit     = 10
        object.patternColor         = "rgb(131, 215, 164)"
        object.path                 = cgPath!.asArray()

        object.hasBorders           = true
        object.hasControls          = true

        mainViewController.setupDrawPropertyView(object: object)
        addSubView(view: pointView, object: object, layer: shapeView, isLoading: false)
    }
    
    private func createShapeView(cgPath: CGPath) -> CAShapeLayer
    {
        let shapeView               = CAShapeLayer()
        
        shapeView.path              = cgPath
        shapeView.lineCap           = "round"
        shapeView.lineJoin          = "round"
        shapeView.fillColor         = UIColor(white: 1, alpha: 0).cgColor
        shapeView.strokeColor       = ThemeUtil.getModeColor(type: C.MainMode.MAIN_DRAW).cgColor
        shapeView.lineWidth         = 1.6
        shapeView.lineDashPattern   = [3, 4]
        
        return shapeView
    }
    
    private func convertPathArrayToString(pathArray: [[Any]])->String
    {
        var pathString      = ""

        for array:[Any] in pathArray
        {
            for item in array
            {
                if item is String
                {
                    pathString = pathString + String(describing: item)
                }
                
                if item is Float
                {
                    pathString = pathString + String(describing: item) + " "
                }
            }
        }
        
        return pathString
    }
    
    private func addDefined ()
    {
        var imageName: String?
        var imageUrl: String?
        var title: String?
        var frame: CGRect?
        
        switch self.sub_mode
        {
        case 1: //eye
            frame           = CGRect(x: 40, y: 250, width: 85, height: 44)
            imageName       = "image_eye_area"
            imageUrl        = "eyes"
            title           = "Augen"
            break
        case 2: //nose
            frame           = CGRect(x: 110, y: 250, width: 85, height: 135)
            imageName       = "image_nose_area"
            imageUrl        = "nose"
            title           = "Nase"
            break
        case 3: //cheek
            frame           = CGRect(x: 20, y: 280, width: 81, height: 103)
            imageName       = "image_cheek_area"
            imageUrl        = "cheek"
            title           = "Wange"
            break
        case 4: //forehead
            frame           = CGRect(x: 55, y: 130, width: 212, height: 91)
            imageName       = "image_forehead_area"
            imageUrl        = "forehead"
            title           = "Stirn"
            break
        case 5: //mouth
            frame           = CGRect(x: 100, y: 400, width: 120, height: 48)
            imageName       = "image_mouth_area"
            imageUrl        = "mouth"
            title           = "Mund & Lippen"
            break
        case 6: //chin
            frame           = CGRect(x: 120, y: 450, width: 84, height: 52)
            imageName       = "image_chin_area"
            imageUrl        = "chin"
            title           = "Kinn"
            break
        case 7: //neck
            frame           = CGRect(x: 85, y: 520, width: 148, height: 85)
            imageName       = "image_neck_area"
            imageUrl        = "neck"
            title           = "Hals"
            break
        case 8: //teeth
            frame           = CGRect(x: 100, y: 400, width: 120, height: 48)
            imageName       = "image_mouth_area"
            imageUrl        = "teeth"
            title           = "Zähne"
            break
        case 9: //hair
            frame           = CGRect(x: -10, y: 0, width: 347, height: 206)
            imageName       = "image_hair_area"
            imageUrl        = "hair"
            title           = "Haut & Haare"
            break
        default:
            return
        }
        
        let posX            = self.viewForFaceMask.frame.origin.x + frame!.origin.x
        let posY            = self.viewForFaceMask.frame.origin.y + frame!.origin.y
        
        let definedView     = UIView(frame: CGRect(x: posX, y: posY, width: frame!.size.width, height: frame!.size.height))
        let definedImage    = UIImageView(image: UIImage(named: imageName!)!)
        
        definedImage.frame  = CGRect(x: 0, y: 0, width: frame!.size.width, height: frame!.size.height)
        definedView.addSubview(definedImage)
        
        let object:Object   = Object()
        
        object.type             = "image"
        object.mode             = 3
        object.originX          = "left"
        object.originY          = "top"
        object.src              = C.BASE_URL + "/img/defined_" + imageUrl! + ".svg"
        object.patternColor     = "rgb(245, 175, 98)"
        object.hasBorders       = true
        object.hasControls      = true
        object.sub_category     = "zones_" + imageUrl!
        object.title            = title!
        
        let layer:CAShapeLayer  = CAShapeLayer()
        
        mainViewController.setupDefinedPropertyView(object: object)
        addSubView(view: definedView, object: object, layer: layer, isLoading: false)
    }
    
    private func addSubView (view: UIView, object: Object, layer:CAShapeLayer, isLoading:Bool)
    {
        let tapRecognizer               = UITapGestureRecognizer(target: self, action:#selector(handleTap(_:)))
        tapRecognizer.delegate          = self
        view.addGestureRecognizer(tapRecognizer)
        
        let panRecognizer               = UIPanGestureRecognizer(target: self, action:#selector(handlePan(_:)))
        panRecognizer.delegate          = self
        view.addGestureRecognizer(panRecognizer)

        if (object.mode != 1)
        {
            let resizeRecognizer        = UIPinchGestureRecognizer(target: self, action:#selector(handlePinch(_:)))
            resizeRecognizer.delegate   = self
            view.addGestureRecognizer(resizeRecognizer)
            
            let rotateRecognizer        = UIRotationGestureRecognizer(target: self, action:#selector(handleRotate(_:)))
            rotateRecognizer.delegate   = self
            view.addGestureRecognizer(rotateRecognizer)
        }
        
        view.tag                        = uniqueID
        object.createdWidth             = (Float)(view.frame.width)
        
        self.viewForWorkArea.addSubview(view)
//        self.viewForWorkArea.bringSubview(toFront: view)
        self.arrayOfViews.append(view)
        self.arrayOfObjects.append(object)
        self.arrayOfLayers.append(layer)
        
        self.viewForEditButtons.isHidden    = false
        self.selectedView                   = view
        changeEditButton()
        
        self.viewForEditButtons.center      = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 2)
        self.viewForWorkArea.bringSubview(toFront: self.viewForEditButtons)
        
        self.prevBackgroundImage            = self.imageForBackground.image
        self.prevBackgroundFrame            = self.imageForBackground.frame
        
        uniqueID    += 1
        
        if (!isLoading)
        {
            updatePoints()
        }
    }
    
    private func removeSubView ()
    {
        if (self.selectedView != nil)
        {
            let index:Int                       = findIndexInArray()
            
            if (index > -1)
            {
                self.viewForEditButtons.isHidden    = true
                
                self.selectedView?.removeFromSuperview()
                self.arrayOfViews.remove(at: index)
                self.arrayOfObjects.remove(at: index)
                self.arrayOfLayers.remove(at: index)
            }
        }
    }
    
    private func changeEditButton()
    {
        let object: Object  = self.arrayOfObjects[findIndexInArray()]
        
        switch object.mode
        {
        case 1:
            self.buttonForEditObject.setImage(UIImage(named:"button_edit_project_point.png"), for: UIControlState.normal)
            break
        case 2:
            self.buttonForEditObject.setImage(UIImage(named:"button_edit_project_draw.png"), for: UIControlState.normal)
            break
        case 3:
            self.buttonForEditObject.setImage(UIImage(named:"button_edit_project_defined.png"), for: UIControlState.normal)
            break
        default:
            break
        }
    }
    
    private func findIndexInArray() -> Int
    {
        var index:Int   = -1
        
        if (self.arrayOfViews.count > 0)
        {
            for i in 0...self.arrayOfViews.count - 1
            {
                if self.arrayOfViews[i].tag == self.selectedView?.tag
                {
                    index   = i;
                    break
                }
            }
        }
        
        return index
    }
    
    private func showPropertyModal()
    {
        let object: Object  = self.arrayOfObjects[findIndexInArray()]
        
        switch object.mode
        {
        case 1:
            mainViewController.setupPointPropertyView(object: object)
            break
        case 2:
            mainViewController.setupDrawPropertyView(object: object)
            break
        case 3:
            mainViewController.setupDefinedPropertyView(object: object)
            break
        default:
            break
        }
    }
    
    private func zoomoutBackgroundImage()
    {
        self.imageForBackground.transform   = self.imageForBackground.transform.scaledBy(x: 1.1, y: 1.1)
    }
    
    private func zoominBackgroundImage()
    {
        self.imageForBackground.transform   = self.imageForBackground.transform.scaledBy(x: 0.9, y: 0.9)
    }
    
    private func rotateBackgroundImage()
    {
        self.imageForBackground.transform   = self.imageForBackground.transform.rotated(by: CGFloat(M_PI_2))
    }
    
    private func scalingShape()
    {
        if findIndexInArray() > -1
        {
            let object: Object              = self.arrayOfObjects[findIndexInArray()]
            
            if (object.mode == 2)
            {
                let layer: CAShapeLayer     = self.arrayOfLayers[findIndexInArray()]
                let ratio                   = (CGFloat)(object.createdWidth) / (self.selectedView?.frame.width)!
                
                layer.lineWidth             = CGFloat(object.strokeWidth) * ratio
                layer.lineDashPattern       = [NSNumber(value:object.strokeDashArray[0] * Float(ratio)), NSNumber(value:object.strokeDashArray[1] * Float(ratio))]
            }
        }
    }
    
    private func getRelativePath(cgPath: CGPath, offset:CGPoint) -> CGPath
    {
        let relativePathString  = cgPath.asRelativePathString(offset: offset)
        let relativePath        = SVGPathGenerator.newCGPath(fromSVGPath: relativePathString, whileApplying:  CGAffineTransform.identity)
        
        return relativePath!
    }
    
    private func convertObjects()
    {
        
    }
    
    private func updatePoints()
    {
        if (self.arrayOfObjects.count == 0)
        {
            return
        }
        var arrayObject         = self.arrayOfObjects

        let imageFrame          = self.imageForBackground.image!.size
        let xPos                = (self.viewForWorkArea.frame.size.width  - imageFrame.width * UIScreen.main.scale)  / 2 + self.deltaX
        let yPos                = (self.viewForWorkArea.frame.size.height - imageFrame.height * UIScreen.main.scale) / 2 + self.deltaY
        
        let bgObject            = Object()
        let objects             = self.client.objects

        for index in 0 ... arrayObject.count - 1
        {
            arrayObject[index].width    = Float(self.arrayOfViews[index].frame.size.width)
            arrayObject[index].height   = Float(self.arrayOfViews[index].frame.size.height)
            arrayObject[index].left     = Float(self.arrayOfViews[index].frame.origin.x)
            arrayObject[index].top      = Float(self.arrayOfViews[index].frame.origin.y)
            
            if (arrayObject[index].type == "path")
            {
                arrayObject[index].strokeWidth      = Float(self.arrayOfLayers[index].lineWidth)
                arrayObject[index].strokeDashArray  = self.arrayOfLayers[index].lineDashPattern as! [Float]
//                
                arrayObject[index].pathOffset.x     = Float(arrayObject[index].width)  / 2
                arrayObject[index].pathOffset.y     = Float(arrayObject[index].height) / 2
                
                arrayObject[index].left             = arrayObject[index].left + Float(arrayObject[index].width) / 2//  + arrayObject[index].pathOffset.x
                arrayObject[index].top              = arrayObject[index].top  + Float(arrayObject[index].height)// / 2 //+ arrayObject[index].pathOffset.y
            }
            
            arrayObject[index].left     = arrayObject[index].left + Float(self.deltaX)
            arrayObject[index].top      = arrayObject[index].top  + Float(self.deltaY)
        }
        
        bgObject.type           = "image"
        bgObject.strokeWidth    = 0
        bgObject.selectable     = false
        bgObject.hasControls    = false
        bgObject.hasBorders     = false
        bgObject.id             = 0
        bgObject.left           = Float(xPos)
        bgObject.top            = Float(yPos)
        bgObject.width          = Float(imageFrame.width  * UIScreen.main.scale)
        bgObject.height         = Float(imageFrame.height * UIScreen.main.scale)
        bgObject.createdWidth   = Float(self.viewForWorkArea.frame.size.width)
        bgObject.src            = self.backgroundImageUrl
        
        arrayObject.insert(bgObject, at: 0)
        
        objects!.objects        = arrayObject
        objects!.height         = Int(self.viewForWorkArea.frame.size.height)

        var parameters          = Dictionary<String, String>()
        parameters              = ["clientid":self.client.id, "points":objects!.toNonPrettyJson(), "points_count":String(self.arrayOfObjects.count)]
        
        self.viewForEditButtons.isHidden    = true
        let image                           = UIImage(view: self.viewForWorkArea)
        self.viewForEditButtons.isHidden    = false
        let reduceSize                      = CGSize(width: 300, height: 300)
        ClientService.updatePoints(parameters: parameters, image: image.resizeImage(toSize: reduceSize))
    }
    
    private func setupSummaryView()
    {
        let arrayViews:Array                = self.arrayOfViews
        self.viewForSummary.isHidden        = false
        summaryDeltaX                       = (self.viewForSummaryPreview.frame.size.width - self.viewForWorkArea.frame.size.width) / 2
        let imageFrame                      = self.imageForBackground.image!.size
        let xPos                            = (self.viewForSummaryPreview.frame.size.width  - imageFrame.width * UIScreen.main.scale) / 2
        let yPos                            = (self.viewForSummaryPreview.frame.size.height - imageFrame.height * UIScreen.main.scale) / 2
        print("xPos = \(xPos) yPos = \(yPos)")
        self.imageForSummaryPreview.frame   = CGRect(x: xPos, y: yPos, width: imageFrame.width * UIScreen.main.scale, height: imageFrame.height * UIScreen.main.scale)
        self.imageForSummaryPreview.image   = self.imageForBackground.image
        self.labelForClientName.text        = self.client.clientname
        self.labelForAge.text               = self.client.age
        
//        let deltaX                          = /*self.imageForBackground.frame.origin.x - */self.imageForSummaryPreview.frame.origin.x
        var index                           = 0
        for view in arrayViews
        {
            index                           += 1
            
            view.frame                      = CGRect(x: view.frame.origin.x + summaryDeltaX, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
            self.viewForSummaryPreview.addSubview(view)
            
            let markFrame                   = CGRect(x: view.frame.origin.x + view.frame.size.width - 13, y: view.frame.origin.y + view.frame.size.height / 2 - 13, width: 27, height: 27)
            let imageBlackCircle            = UIImageView(frame: markFrame)
            imageBlackCircle.image          = UIImage(named:"button_black_circle.png")
            
            let labelMark                   = UILabel(frame: markFrame)
            labelMark.text                  = String(index)
            labelMark.font                  = UIFont(name: "SofiaProSemiBold", size: 16)
            labelMark.textAlignment         = .center
            labelMark.textColor             = UIColor.white
            
            self.viewForSummaryPreview.addSubview(imageBlackCircle)
            self.viewForSummaryPreview.addSubview(labelMark)
        }
        
        if (self.client.gender              == "0")
        {
            self.labelForGender.text        = "weiblich"
        }
        else
        {
            self.labelForGender.text        = "männlich"
        }
        
        self.tableviewForSummaryInfo.reloadData()
    }
    
    private func hideSummaryView()
    {
        self.viewForSummary.isHidden        = true
//        let deltaX                          = self.imageForSummaryPreview.frame.origin.x
        for subview in self.viewForSummaryPreview.subviews
        {
            subview.removeFromSuperview()
        }
        
        for view in self.arrayOfViews
        {
            view.frame                      = CGRect(x: view.frame.origin.x - summaryDeltaX, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height)
            self.viewForWorkArea.addSubview(view)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrayOfObjects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell                        = tableView.dequeueReusableCell(withIdentifier: "SummaryInfoCell", for: indexPath) as! SummaryInfoCell
        
        let object:Object               = self.arrayOfObjects[indexPath.row]
        cell.labelForOrder.text         = String(indexPath.row + 1)
        cell.labelForDescription.text   = object.description
        cell.imageForSubCategory.image  = UIImage(named: object.sub_category.replacingOccurrences(of: "zones_", with: "image_") + ".png")
        
        let attribute1                  = [ NSFontAttributeName: UIFont(name: "SofiaProSemiBold", size: 13.0)! ]
        let attribute2                  = [ NSFontAttributeName: UIFont(name: "SofiaProLight", size: 13.0)! ]
        
        let attrString                  = NSMutableAttributedString(string: object.title, attributes: attribute1)
        
        if (object.sub_title            != "")
        {
            let attrString1             = NSAttributedString(string: "(" + object.sub_title + ")", attributes: attribute2)
            attrString.append(attrString1)
        }
        
        cell.labelForSubCategory.attributedText     = attrString
        
        return cell
    }
    
    @IBAction func handleTap(_ recognizer : UITapGestureRecognizer)
    {
        self.viewForEditButtons.isHidden    = false
        
        if let view             = recognizer.view
        {
            self.viewForEditButtons.center  = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 2)
            self.selectedView   = view
            changeEditButton()
        }
    }
    
    @IBAction func handlePan(_ recognizer : UIPanGestureRecognizer)
    {
        let translation         = recognizer.translation(in: self.viewForWorkArea)
        if let view             = recognizer.view
        {
            view.center         = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
            self.viewForEditButtons.center  = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 2)
            self.selectedView   = view
            changeEditButton()
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.viewForWorkArea)
    }
    
    @IBAction func handlePinch(_ recognizer : UIPinchGestureRecognizer)
    {
        if let view             = recognizer.view
        {
            view.transform                  = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
          
            self.viewForEditButtons.center  = CGPoint(x: view.center.x, y: view.center.y + view.frame.size.height / 2)
            recognizer.scale                = 1
            self.selectedView               = view
            
            scalingShape()
            changeEditButton()
        }
    }
    
    @IBAction func handleRotate(_ recognizer : UIRotationGestureRecognizer)
    {
        if let view             = recognizer.view
        {
            view.transform      = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
            self.selectedView   = view
        }
    }
    
    @IBAction func handlePinchWorkArea(_ recognizer : UIPinchGestureRecognizer)
    {
        if (self.selectedView != nil)
        {
            let object: Object              = self.arrayOfObjects[findIndexInArray()]
            
            if (object.mode != 1)
            {
                self.selectedView?.transform    = (self.selectedView?.transform.scaledBy(x: recognizer.scale, y: recognizer.scale))!
                
                self.viewForEditButtons.center  = CGPoint(x: self.selectedView!.center.x, y: self.selectedView!.center.y + self.selectedView!.frame.size.height / 2)
                recognizer.scale    = 1
                
                scalingShape()
            }
        }
    }
    
    @IBAction func handleRotationWorkArea(_ recognizer: UIRotationGestureRecognizer)
    {
        if (self.selectedView != nil)
        {
            let object: Object              = self.arrayOfObjects[findIndexInArray()]
            
            if (object.mode != 1)
            {
                self.selectedView?.transform    = (self.selectedView?.transform.rotated(by: recognizer.rotation))!
                
                self.viewForEditButtons.center  = CGPoint(x: self.selectedView!.center.x, y: self.selectedView!.center.y + self.selectedView!.frame.size.height / 2)
                recognizer.rotation    = 0
                
                scalingShape()
            }
        }
    }
    
    @IBAction func handlePanBackgroundImage(_ sender: UIPanGestureRecognizer)
    {
        if (self.changingBackground)
        {
            let translation         = sender.translation(in: self.viewForWorkArea)
            
            self.imageForBackground.center         = CGPoint(x:self.imageForBackground.center.x + translation.x, y:self.imageForBackground.center.y + translation.y)
            
            sender.setTranslation(CGPoint.zero, in: self.viewForWorkArea)
        }
    }
    @IBAction func handleRotationBackgroundImage(_ recognizer: UIRotationGestureRecognizer)
    {
        if (self.changingBackground)
        {
            self.imageForBackground.transform      = self.imageForBackground.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @IBAction func handlePinchBackgroundImage(_ recognizer : UIPinchGestureRecognizer)
    {
        if (self.changingBackground)
        {
            self.imageForBackground.transform      = self.imageForBackground.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale                       = 1
        }
    }
    
    @IBAction func handleTapWorkArea(_ sender: UITapGestureRecognizer)
    {
        let touchLocation   = sender.location(in: self.viewForFaceMask)
        let frame           = self.viewForFaceMask.frame
        
        if (touchLocation.x > 0 && touchLocation.x < frame.width &&
            touchLocation.y > 0 && touchLocation.y < frame.height)
        {
            let hitView     = self.viewForFaceMask.hitTest(touchLocation, with: nil)
            if (hitView     != nil)
            {
                let tag         = hitView!.tag
                
                switch mode
                {
                case 1:
                    break
                case 2:
                    addPoint(point: touchLocation, tag: tag)
                    break
                case 3:
                    addShape(point: touchLocation)
                    break
                case 4:
                    addDefined()
                    break
                default: break
                }
            }
        }
    }
    
    public func drawingView(_ view: ACEDrawingView!, didEndDrawUsing tool: ACEDrawingTool!)
    {
        let imageView: UIImageView      = self.viewForDrawingArea.applyDraw(toImage: self.imageForDrawingArea)
        
        if (imageView.frame.size.width  == self.viewForDrawingArea.frame.size.width)
        {
            return
        }
        
        let penTool: ACEDrawingPenTool  =  self.viewForDrawingArea.getPenTool() as! ACEDrawingPenTool

        if let cgPath:CGPath = penTool.cgResultPath
        {
            self.viewForDrawingArea.clear()
            self.imageForDrawingArea.image = nil
            
            print("width = \(imageView.frame.size.width) height = \(imageView.frame.size.height) x = \(imageView.frame.origin.x) y = \(imageView.frame.origin.y)")
            
            let frame           = imageView.frame
            let offset          = frame.origin
            
            let drawingView     = UIView(frame: frame)
            let shapeView       = createShapeView(cgPath: getRelativePath(cgPath: cgPath, offset: offset))
            let object:Object   = Object()
            
            object.mode         = 2
            object.type                 = "path"
            object.originX              = "center"
            object.originY              = "center"
            object.fill                 = "rgba(255, 255, 255, 0)"
            object.stroke               = "#83D7A4"
            object.strokeWidth          = 1.6
            object.strokeDashArray      = [3, 4]
            object.strokeLineCap        = "round"
            object.strokeLineJoin       = "round"
            object.strokeMiterLimit     = 10
            object.patternColor         = "rgb(131, 215, 164)"
            object.path                 = getRelativePath(cgPath: cgPath, offset: offset).asArray()
            
            object.hasBorders           = true
            object.hasControls          = true
            
            object.pathOffset.x         = Float(frame.size.width)
            object.pathOffset.y         = Float(frame.size.height)
            
            mainViewController.setupDrawPropertyView(object: object)
            
            drawingView.layer.addSublayer(shapeView)
            addSubView(view: drawingView, object: object, layer:shapeView, isLoading: false)
        }
    }
    
    @IBAction func rightSideBarItemsClicked(_ sender: UIButton)
    {
        let tag = sender.tag
        
        initRightSideBarMenu()
        enterMode(mode: tag)
    }
    
    @IBAction func menuItemsClicked(_ sender: UIButton)
    {
        let tag     = sender.tag
        
        switch tag
        {
        case 201: // edit client
            mainViewController.setupEditClientView(client: self.client)
            break
        case 202: // save
            updatePoints()
            break
        case 203: // continue
            updatePoints()
            setupSummaryView()
            break
        case 204: // help
            break
        case 205: // upload picture
            mainViewController.setupTakePictureView(fromWorkspace: true)
            break
        case 206:
            changingBackgroundMode()
            break
        default: break
        }
    }
    
    @IBAction func emotionMenuItemsClicked(_ sender: UIButton)
    {
        let index                   = sender.tag - 1
        self.emotionSelected[index] = !self.emotionSelected[index]
        
        initEmotionBottomBarMenu()
    }
    
    @IBAction func drawMenuItemsClicked(_ sender: UIButton)
    {
        let tag = sender.tag
        
        initDrawBottomBarMenu()
        enterDrawSubMode(tag: tag)
    }
    
    @IBAction func definedMenuItemsClicked(_ sender: UIButton)
    {
        let tag = sender.tag

        initDefinedBottomBarMenu()
        enterDefinedSubMode(tag: tag)
    }
    
    @IBAction func editButtonsClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1: //edit
            showPropertyModal()
            break
        case 2: //remove
            removeSubView()
            break
        default:
            break
        }
    }
    
    @IBAction func saveCancelButtonsClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1:
            self.viewForSaveCancelButtons.isHidden  = true
            self.viewForRightSideBarMask.isHidden   = true
            self.changingBackground                 = false
            self.viewForEditBackground.isHidden     = true
            self.imageForFaceMask.isHidden          = true
            break
        case 2:
            self.imageForBackground.image           = self.prevBackgroundImage
            self.imageForBackground.frame           = self.prevBackgroundFrame!
            break
        default:
            break
        }
    }
    
    @IBAction func editPositionButtonsClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1: //move
            break
        case 2: //rotate
            rotateBackgroundImage()
            break
        case 3: //zoomout
            zoomoutBackgroundImage()
            break
        case 4: //zoomin
            zoominBackgroundImage()
            break
        default:
            break
        }
    }
    @IBAction func summaryButtonClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1: //back
            hideSummaryView()
            break
        case 2: //go to next - maybe sign modal
            mainViewController.setupDrawSignView(client: self.client, isCreating: false)
            break
        default:
            break
        }
    }
}
