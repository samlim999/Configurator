//
//  TakePictureViewController.swift
//  configurator(iPad)
//
//  Created by CloudStream on 1/23/17.
//  Copyright © 2017 CloudStream. All rights reserved.
//

import UIKit

class TakePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    public var mainViewController: MainViewController!
    public var callingFromWorkspace:Bool    = false
    
    override func viewDidLoad()
    {
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
    
    private func openCameraPicture()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate                = self
            imagePicker.sourceType              = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing           = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            noCamera()
        }
    }

    private func openPhotoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
        {
            let appDelegate                     = UIApplication.shared.delegate as! AppDelegate
            appDelegate.canSupportPortraitMode  = true
            
            let imagePicker                     = UIImagePickerController()
            imagePicker.delegate                = self
            imagePicker.sourceType              = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing           = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func noCamera()
    {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image:UIImage                   = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        let imageDataDict:[String: UIImage] = ["image": image]
        
        if (callingFromWorkspace)
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.NEW_PHOTO_CHANGED_WORKSPACE), object: nil, userInfo: imageDataDict)
        }
        else
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.NEW_PHOTO_CHANGED), object: nil, userInfo: imageDataDict)
        }

        
        self.dismiss(animated: true, completion: nil)
        mainViewController.removeModelView(viewController: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        let appDelegate                     = UIApplication.shared.delegate as! AppDelegate
        appDelegate.canSupportPortraitMode  = false
        self.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.landscape
    }
    
    @IBAction func buttonsClicked(_ sender: UIButton)
    {
        let tag         = sender.tag
        
        switch tag
        {
        case 1:
            openCameraPicture()
            break
        case 2:
            openPhotoLibrary()
            break
        case 3:
            mainViewController.removeModelView(viewController: self)
            break
        default:
            break
        }
    }
}
