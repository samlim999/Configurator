//
//  PointPropertyViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/21/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit

class PointPropertyViewController: UIViewController
{
    @IBOutlet weak var textfieldForDescription: UITextField!
    @IBOutlet weak var viewForMainCategoryButtons: UIView!
    @IBOutlet weak var viewForSubCategoryButtons: UIView!
    @IBOutlet weak var scrollviewForCategory: UIScrollView!
    @IBOutlet weak var scrollviewForSubcategory: UIScrollView!
   
    public var mainViewController: MainViewController!
    public var object:Object!
    
    private var categoryNameList        = ["Zornesfalte", "Stirnregion", "Augenregion", "Nasenbereich", "Wangenregion", "Nasolabial Bereich", "Mundwinkelbereich", "Mund und Lippen", "Plissee und Lippenkontur", "Kinn / Doppelkinn", "Hals", "Dekolleté"]
    private var subCategoryNameList     = [["Augenbrauen (Brow lift)", "Augenfalten (Crow Fleet)", "Augenringe & Tränenringe", "Zonesfalten (Glabella)", "Augenbraun Lift", "Frischere Augen", "Krähenfüße"],
                                       ["frischere Stirn", "Stirnfalten", "Brauenlinie", "Open Eye", "Brauenlift"],
                                       ["Frischere Augen", "Krähenfüße", "Lachfältchen", "Augenringe", "Tränenrinne", "Tränensäcke", "Brauenlinie / Brauenlift", "Schlupflid", "Unterlid", "Augenschatten & colorit"],
                                       ["Nasenlinie bei Nasenhöcker", "Nasenspitze", "Nasenform", "“schiefe Nase”"],
                                       ["Knitterfalten", "hangende Wange", "Wangenlifting", "Jochbeinlinie"],
                                       ["nasolabiales Dreieck", "nasolabiale falte", "nasolabiale Ausläufer / Mundwinkel"],
                                       ["Mundwinkel", "Marionettenlinie", "Hebung Lippenwinkel", "Senkung (ptosis)"],
                                       ["Lippenkontur", "Lippensymmetrie", "Lippenvolumen", "periorale Falten / Plissee / Barcodes"],
                                       ["Plissee Fältchen / Barcodes", "Lippenkontur / Lippenform"],
                                       ["Kinnform & Silhouette", "Pflasterstein-Kinn", "Doppelkinn"],
                                       ["frischer Hals", "Halsfalten", "Venusringe (querfalten)", "Platysma (Stränge und vertikale Falten)", "schlaffe Haut", "Senkung Kinnlinie (ptosis lower chaw line)"],
                                       ["frisches Dekolleté", "Dekolleté Falten", "Dekolleté Hautbild"]
                                       ]
    private var selectedCategoryIndex   = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.textfieldForDescription.text   = object.description
        print(object.sub_category)
        print(object.title)
        setupViews()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews()
    {
        for index in 0 ... categoryNameList.count - 1
        {
            let categoryViw     = createCategoryView(index: index)
            self.scrollviewForCategory.addSubview(categoryViw)
        }
        
        let ratio                   = CGFloat(self.scrollviewForCategory.frame.size.height / 48)
        self.scrollviewForCategory.contentSize  = CGSize(width: 184 * CGFloat(categoryNameList.count) * ratio, height: 48 * ratio)
        
        let tag     = 12
        let count   = categoryNameList.count
        let button  = self.view.viewWithTag(tag) as? UIButton
        let image   = self.view.viewWithTag(count + tag) as? UIImageView
        let label   = self.view.viewWithTag(count * 2 + tag) as? UILabel
        let view    = self.view.viewWithTag(count * 3 + tag)
        
        label?.textColor            = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
        button?.backgroundColor     = ThemeUtil.getModeColor(type: C.MainMode.MAIN_POINT)
        view?.layer.borderWidth     = 0
        image?.image                = UIImage(named: "image_category_" + String(tag + 1 - count) + "_selected.png")
        
        loadSubCategory(categoryIndex: 0)
    }
    
    private func createCategoryView(index: Int) -> UIView
    {
        let imageName               = "image_category_" + String(index + 1) + ".png"
        let categoryName            = categoryNameList[index]
        let count                   = categoryNameList.count
        let ratio                   = CGFloat(self.scrollviewForCategory.frame.size.height / 48)
        let categoryView            = UIView(frame: CGRect(x: CGFloat(index) * 184 * ratio, y: 0, width: 176 * ratio, height: 48 * ratio))
        
        let categoryButton          = UIButton(frame: CGRect(x: 0, y: 0, width: 176 * ratio, height: 48 * ratio))
        categoryButton.addTarget(self, action: #selector(mainCategoryButtonsClicked(_:)), for: .touchUpInside)
        
        let categoryImage           = UIImage(named:imageName)
        let categoryImageView       = UIImageView(frame: CGRect(x: 17 * ratio, y: (48 - categoryImage!.size.height / 2) / 2 * ratio, width: categoryImage!.size.width / 2 * ratio, height: categoryImage!.size.height / 2 * ratio))
        categoryImageView.image     = categoryImage
        
        let categoryLabel           = UILabel(frame: CGRect(x: 50 * ratio, y: 0, width: 119 * ratio, height: 48 * ratio))
        categoryLabel.numberOfLines = 0
        categoryLabel.text          = categoryName
        categoryLabel.font          = UIFont(name: "SofiaProSemiBold", size: 15)
        categoryLabel.textColor     = ThemeUtil.getMainCategoryLabelColor()
        
        categoryButton.tag          = count + index
        categoryImageView.tag       = count * 2 + index
        categoryLabel.tag           = count * 3 + index
        categoryView.tag            = count * 4 + index

        categoryView.addSubview(categoryButton)
        categoryView.addSubview(categoryImageView)
        categoryView.addSubview(categoryLabel)
        
        categoryView.layer.borderWidth      = 2;
        categoryView.layer.borderColor      = ThemeUtil.getMainCategoryBorderColor().cgColor
        
        return categoryView
    }
    
    private func loadSubCategory(categoryIndex: Int)
    {
        for subview in self.scrollviewForSubcategory.subviews
        {
            subview.removeFromSuperview()
        }
        
        let subCategoryArray        = subCategoryNameList[categoryIndex]
        selectedCategoryIndex       = categoryIndex
        
        for index in 0 ... subCategoryArray.count - 1
        {
            let categoryViw         = createSubCategoryView(index: index)
            self.scrollviewForSubcategory.addSubview(categoryViw)
        }
        
        let ratio                   = CGFloat(self.scrollviewForSubcategory.frame.size.height / 262)
        self.scrollviewForSubcategory.contentSize  = CGSize(width: 752, height: 128 * CGFloat(Int(subCategoryArray.count / 4) + 1) * ratio)
    }
    
    private func createSubCategoryView(index: Int) -> UIView
    {
        let imageName               = "image_subcategory_" + String(selectedCategoryIndex + 1) + "_" + String(index + 1) + ".png"
        let subCategoryArray        = subCategoryNameList[selectedCategoryIndex]
        let categoryName            = subCategoryArray[index]

        let count                   = subCategoryArray.count
        let ratio                   = CGFloat(self.scrollviewForSubcategory.frame.size.height / 262)
        let view                    = UIView(frame: CGRect(x: mod(left: CGFloat(index), right: 4) * 188 * ratio, y: 128 * CGFloat(Int(index / 4)) * ratio, width: 180 * ratio, height: 120 * ratio))

        let button                  = UIButton(frame: CGRect(x: 0, y: 0, width: 180 * ratio, height: 120 * ratio))
        button.addTarget(self, action: #selector(subCategoryButtonsClicked(_:)), for: .touchUpInside)
        
        let image                   = UIImage(named:imageName)
        let imageView               = UIImageView(frame: CGRect(x: (180 - image!.size.width / 2) / 2 * ratio, y: (84 - image!.size.height / 2) / 2 * ratio, width: image!.size.width / 2 * ratio, height: image!.size.height / 2 * ratio))
        imageView.image             = image
        
        let categoryLabel           = UILabel(frame: CGRect(x: 0, y: 68 * ratio, width: 180 * ratio, height: 52 * ratio))
        categoryLabel.numberOfLines = 0
        categoryLabel.text          = categoryName
        categoryLabel.font          = UIFont(name: "SofiaProSemiBold", size: 15)
        categoryLabel.textColor     = ThemeUtil.getMainCategoryLabelColor()
        categoryLabel.textAlignment = .center
        
        button.tag                  = count + index + C.START_INDEX
        imageView.tag               = count * 2 + index + C.START_INDEX
        categoryLabel.tag           = count * 3 + index + C.START_INDEX
        view.tag                    = count * 4 + index + C.START_INDEX
        
        view.addSubview(button)
        view.addSubview(imageView)
        view.addSubview(categoryLabel)
        
        view.layer.borderWidth      = 2;
        view.layer.borderColor      = ThemeUtil.getSubCategoryBorderColor().cgColor
        
        return view
    }
    
    private func mod (left:CGFloat, right:CGFloat) -> CGFloat
    {
        return left.truncatingRemainder(dividingBy: right)
    }
    
    private func initMainCategoryButtons()
    {
        let count       = categoryNameList.count
        
        for tag in 0 ... count - 1
        {
            let button  = self.view.viewWithTag(count + tag) as? UIButton
            let image   = self.view.viewWithTag(count * 2 + tag) as? UIImageView
            let label   = self.view.viewWithTag(count * 3 + tag) as? UILabel
            let view    = self.view.viewWithTag(count * 4 + tag)
            
            label?.textColor        = ThemeUtil.getMainCategoryLabelColor()
            button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_INIT)
            view?.layer.borderWidth = 2;
            image?.image            = UIImage(named: "image_category_" + String(tag + 1) + ".png")
        }
    }
    
    private func initSubCategoryButtons()
    {
        let count       = subCategoryNameList[selectedCategoryIndex].count
        
        for tag in 0 ... count - 1
        {
            let button  = self.view.viewWithTag(count + tag + C.START_INDEX) as? UIButton
            let image   = self.view.viewWithTag(count * 2 + tag + C.START_INDEX) as? UIImageView
            let label   = self.view.viewWithTag(count * 3 + tag + C.START_INDEX) as? UILabel
            let view    = self.view.viewWithTag(count * 4 + tag + C.START_INDEX)
            
            label?.textColor        = ThemeUtil.getMainCategoryLabelColor()
            button?.backgroundColor = ThemeUtil.getModeColor(type: C.MainMode.MAIN_INIT)
            view?.layer.borderWidth = 2;
            image?.image            = UIImage(named: "image_subcategory_" + String(selectedCategoryIndex + 1) + "_" + String(tag + 1) + ".png")
        }
    }
    
    @IBAction func mainCategoryButtonsClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        let count       = categoryNameList.count

        initMainCategoryButtons()

        let button  = self.view.viewWithTag(tag) as? UIButton
        let image   = self.view.viewWithTag(count + tag) as? UIImageView
        let label   = self.view.viewWithTag(count * 2 + tag) as? UILabel
        let view    = self.view.viewWithTag(count * 3 + tag)
        
        label?.textColor            = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
        button?.backgroundColor     = ThemeUtil.getModeColor(type: C.MainMode.MAIN_POINT)
        view?.layer.borderWidth     = 0
        image?.image                = UIImage(named: "image_category_" + String(tag + 1 - count) + "_selected.png")
        
        loadSubCategory(categoryIndex: tag - count)
    }
    
    @IBAction func subCategoryButtonsClicked(_ sender: UIButton)
    {
        let tag     = sender.tag
        let count   = subCategoryNameList[selectedCategoryIndex].count
        
        initSubCategoryButtons()
        let button  = self.view.viewWithTag(tag) as? UIButton
        let image   = self.view.viewWithTag(count + tag) as? UIImageView
        let label   = self.view.viewWithTag(count * 2 + tag) as? UILabel
        let view    = self.view.viewWithTag(count * 3 + tag)
        
        label?.textColor            = ThemeUtil.getStateColor(type: C.ButtonState.SELECTED_STATE)
        button?.backgroundColor     = ThemeUtil.getModeColor(type: C.MainMode.MAIN_POINT)
        view?.layer.borderWidth     = 0
        image?.image                = UIImage(named: "image_subcategory_" + String(selectedCategoryIndex + 1) + "_" + String(tag + 1 - count - C.START_INDEX) + "_selected.png")
        object.sub_category         = "image_subcategory_" + String(selectedCategoryIndex + 1) + "_" + String(tag + 1 - count - C.START_INDEX)
        object.title                = subCategoryNameList[selectedCategoryIndex][tag - count - C.START_INDEX]
    }
    
    @IBAction func actionClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1:
            object.description  = self.textfieldForDescription.text!
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
