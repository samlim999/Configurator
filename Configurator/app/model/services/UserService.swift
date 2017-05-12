//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireNetworkActivityIndicator

class UserService : Service
{
    static let GET_LOGIN_SERVICE_URL_SEGMENT:String         = "/login?username={username}&password={password}"
    static let POST_UPDATE_SERVICE_URL_SEGMENT:String       = "/updateUser"
    static let POST_SIGNUP_SERVICE_URL_SEGMENT:String       = "/users"

    static let COVER_PIC_SERVICE_URL_SEGMENT:String         = "/users/{user_id}/cover_pic"

    static let USER_PROFILE = "/users/{user_id}"

    static func loginUser(user:User)
    {
        showNetworkIndicator()
        
        let loginUrl    = C.URL_SERVER + GET_LOGIN_SERVICE_URL_SEGMENT.replacingOccurrences(of: "{username}", with: user.username).replacingOccurrences(of: "{password}", with: user.password)

        Alamofire.request(loginUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders(user: user))
        .responseString {
            response in

            hideNetworkIndicator()

            if (response.result.isSuccess)
            {
                if let JSON: String = response.result.value
                {
                    print("JSON: \(JSON)")

                    let backendUser:User = User.fromJson(json: JSON)

                    if backendUser.username != ""
                    {
                        backendUser.password = user.password
                        UserManager.setLoginUser(user: backendUser)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_LOGGED_IN), object: self)
                    }
                    else
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_NOT_LOGGED_IN), object: self)
                    }
                }
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_NOT_LOGGED_IN), object: self)
            }
        }
    }
    
    static func updateUser(user:User, image:UIImage, upload:Bool)
    {
        showNetworkIndicator()
        let uploadUrl   = C.URL_SERVER + POST_UPDATE_SERVICE_URL_SEGMENT
        print(uploadUrl)
        Alamofire.upload(multipartFormData:
            {
                multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.5)
                {
                    if (upload)
                    {
                        multipartFormData.append(imageData, withName: "photo", fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
                }
                
                let contentDict = user.toDictionary()! as! [String : String]
                
                for (key, value) in contentDict
                {
                    print("key = \(key) value = \(value)")
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
        }, to: uploadUrl, method: .post, headers: nil,
           encodingCompletion:
            {
                encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        print("response = \(response.result.value)")
                        do
                        {
                            let jsonData = try JSONSerialization.data(withJSONObject: response.result.value!, options: .prettyPrinted)
                            
                            if let JSON = String(data: jsonData, encoding: .utf8)
                            {
                                print("JSON: \(JSON)")
                                
                                let backendUser:User = User.fromJson(json: JSON)
                                
                                if backendUser.username != ""
                                {
                                    backendUser.password = user.password
                                    UserManager.setLoginUser(user: backendUser)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_UPDATED), object: self)
                                }
                                else
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_FAILED_UPDATED), object: self)
                                }
                            }
                            else
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_FAILED_UPDATED), object: self)
                            }
                        }
                        catch
                        {
                            print(error.localizedDescription)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_FAILED_UPDATED), object: self)
                        }
                        
                    }
                case .failure(let encodingError):
                    print("error:\(encodingError)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_FAILED_UPDATED), object: self)
                }
        })
    }
    
    static func signupUser(user:User)
    {
        showNetworkIndicator()
        Alamofire.request(C.URL_SERVER+POST_SIGNUP_SERVICE_URL_SEGMENT, method: .post,  parameters: [:], encoding: URLEncoding.default, headers: C.HEADERS)
            .responseString
        {
            response in
            hideNetworkIndicator()
            if (response.result.isSuccess)
            {
                if let JSON: String = response.result.value
                {
                    print("JSON: \(JSON)")
                    
                    let backendUser: User = User.fromJson(json: JSON)
                    
                    if backendUser.username != ""
                    {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_SIGNED_UP), object: self)
                    }
                }
            }
            else
            {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.USER_NOT_SIGNED_UP), object: self)
            }
        }
    }
}
