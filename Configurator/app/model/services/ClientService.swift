//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import Alamofire


class ClientService : Service
{
    static let GET_CLIENTS_SERVICE_URL_SEGMENT:String           = "/clients?userid="
    static let CREATE_CLIENT_SERVICE_URL_SEGMENT:String         = "/createClient"
    static let UPDATE_CLIENT_SERVICE_URL_SEGMENT:String         = "/updateClient"
    static let UPDATE_POINTS_INFO_SERVICE_URL_SEGMENT:String    = "/updatePointsInfo"
    static let REMOVE_CLIENT_SERVICE_URL_SEGMENT:String         = "/removeClient"
    static let UPDATE_POINTS_SERVICE_URL_SEGMENT:String         = "/updateClientPoints"
    static let UPLOAD_IMAGE_SERVICE_URL_SEGMENT:String          = "/memberphoto"

    static func getClients(user:User)
    {
        showNetworkIndicator()
        let clientsUrl  = C.URL_SERVER + GET_CLIENTS_SERVICE_URL_SEGMENT + user.id

        Alamofire.request(clientsUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: buildHeaders(user: user))
            .responseString {
                response in
                hideNetworkIndicator()
                
                if (response.result.isSuccess)
                {
                    if let JSON: String = response.result.value
                    {
                        print("JSON: \(JSON)")
                        var clients: Array<Client>?
                        do
                        {
                            clients = try Client.fromJsonToList(json: JSON)

                            if (clients!.count > 0)
                            {
                                ClientManager.setClients(clients:clients!)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENTS_DOWNLOADED), object: self)
                            }
                            else
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENTS_EMPTY_DOWNLOADED), object: self)
                            }
                        }
                        catch _
                        {
                            clients = nil
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENTS_FAILED_DOWNLOADED), object: self)
                        }
                    }
                }
        }
    }
    
    static func createClient(client:Client, image:UIImage, upload:Bool)
    {
        showNetworkIndicator()
        let uploadUrl   = C.URL_SERVER + CREATE_CLIENT_SERVICE_URL_SEGMENT
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
                
                let contentDict = client.toDictionary()! as! [String : String]

                for (key, value) in contentDict
                {
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
                                    
                                    let newClient:Client = Client.fromJson(json: JSON)
                                    
                                    if newClient.clientname != ""
                                    {
                                        ClientManager.addNewClient(client: newClient)
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_CREATED), object: self)
                                    }
                                    else
                                    {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_CREATED), object: self)
                                    }
                                }
                                else
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_CREATED), object: self)
                                }
                            }
                            catch
                            {
                                print(error.localizedDescription)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_CREATED), object: self)
                            }

                        }
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_CREATED), object: self)
                    }
        })
    }

    static func updateClient(client:Client, image:UIImage, uploadImage:Bool)
    {
        showNetworkIndicator()
        let uploadUrl   = C.URL_SERVER + UPDATE_CLIENT_SERVICE_URL_SEGMENT
        print(uploadUrl)
        Alamofire.upload(multipartFormData:
            {
                multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.5)
                {
                    if (uploadImage)
                    {
                        multipartFormData.append(imageData, withName: "photo", fileName: "file.jpeg", mimeType: "image/jpeg")
                    }
                }
                
                let contentDict = client.toDictionary()! as! [String : String]
                
                for (key, value) in contentDict
                {
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
                                
                                let newClient:Client = Client.fromJson(json: JSON)
                                
                                if newClient.clientname != ""
                                {
//                                    ClientManager.addNewClient(client: newClient)
                                    ClientManager.updateClient(client: newClient)
                                    if (uploadImage)
                                    {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_UPDATED_WITH_IMAGE), object: self)
                                    }
                                    else
                                    {
                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_UPDATED), object: self)
                                    }
                                    
                                }
                                else
                                {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_UPDATED), object: self)
                                }
                            }
                            else
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_UPDATED), object: self)
                            }
                        }
                        catch
                        {
                            print(error.localizedDescription)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_UPDATED), object: self)
                        }
                        
                    }
                case .failure(let encodingError):
                    print("error:\(encodingError)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_UPDATED), object: self)
                }
        })
    }

    static func removeClient(client:Client)
    {
        showNetworkIndicator()
        let clientUrl   = C.URL_SERVER + REMOVE_CLIENT_SERVICE_URL_SEGMENT
        let user: User  = UserManager.getLoggedInUser()!

        var parameters  = Dictionary<String, String>()
        parameters      = ["userid":user.id, "clientid":client.id]

        Alamofire.request(clientUrl, method: .post, parameters:parameters, encoding: URLEncoding.default, headers: nil)
            .responseString {
                response in
                hideNetworkIndicator()
                
                if (response.result.isSuccess)
                {
                    if let JSON: String = response.result.value
                    {
                        print("JSON: \(JSON)")
                        var clients: Array<Client>?
                        do
                        {
                            clients = try Client.fromJsonToList(json: JSON)
                            
                            if (clients!.count > 0)
                            {
                                ClientManager.setClients(clients:clients!)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_REMOVED), object: self)
                            }
                            else
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_REMOVED), object: self)
                            }
                        }
                        catch _
                        {
                            clients = nil
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: C.CLIENT_FAILED_REMOVED), object: self)
                        }
                    }
                }
        }
    }
//    
//    static func updatePoints(parameters:Dictionary<String, String>)
//    {
//        showNetworkIndicator()
//        let clientUrl   = C.URL_SERVER + UPDATE_POINTS_SERVICE_URL_SEGMENT
//        
//        Alamofire.request(clientUrl, method: .post, parameters:parameters, encoding: URLEncoding.default, headers: nil)
//            .responseString {
//                response in
//                hideNetworkIndicator()
//                if (response.result.isSuccess)
//                {
//                }
//        }
//    }
    
    static func updatePoints(parameters:Dictionary<String, String>, image:UIImage)
    {
        showNetworkIndicator()
        let uploadUrl   = C.URL_SERVER + UPDATE_POINTS_SERVICE_URL_SEGMENT
        print(uploadUrl)
        Alamofire.upload(multipartFormData:
            {
                multipartFormData in
                if let imageData = UIImageJPEGRepresentation(image, 0.5)
                {
                    multipartFormData.append(imageData, withName: "photo", fileName: "file.jpeg", mimeType: "image/jpeg")
                }
                
                for (key, value) in parameters
                {
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
                    }
                case .failure(let encodingError):
                    print("error:\(encodingError)")
                }
        })
    }
    
}
