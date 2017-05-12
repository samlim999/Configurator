//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import ObjectMapper

class Client : Mappable
{
    var id              :String
    var userid          :String
    var clientname      :String
    var phonenumber     :String
    var email           :String
    var address         :String
    var age             :String
    var gender          :String
    var image           :String
    var points          :String
    var objects         :Objects?
    var finished        :String
    var draft           :String
    var points_count    :String
    var points_image    :String
    var signature       :String
    var emotions_shown  :String

    init()
    {
        id              = ""
        userid          = ""
        clientname      = ""
        phonenumber     = ""
        email           = ""
        address         = ""
        age             = ""
        gender          = ""
        image           = ""
        points          = ""
        objects         = Objects()
        finished        = ""
        draft           = ""
        points_count    = ""
        points_image    = ""
        signature       = ""
        emotions_shown  = ""
    }

    required init?(map: Map)
    {
        id              = ""
        userid          = ""
        clientname      = ""
        phonenumber     = ""
        email           = ""
        address         = ""
        age             = ""
        gender          = ""
        image           = ""
        points          = ""
        objects         = Objects()
        finished        = ""
        draft           = ""
        points_count    = ""
        points_image    = ""
        signature       = ""
        emotions_shown  = ""
    }

    // Mappable
    func mapping(map: Map)
    {
        id              <- map["id"]
        userid          <- map["userid"]
        clientname      <- map["clientname"]
        phonenumber     <- map["phonenumber"]
        email           <- map["email"]
        address         <- map["address"]
        age             <- map["age"]
        gender          <- map["gender"]
        image           <- map["image"]
        points          <- map["points"]
//        objects         <- map["points"]
        finished        <- map["finished"]
        draft           <- map["draft"]
        points_count    <- map["points_count"]
        points_image    <- map["points_image"]
        signature       <- map["signature"]
        emotions_shown  <- map["emotions_shown"]
    }

    static func fromJson(json:String)->Client
    {
        let client:Client = Mapper<Client>().map(JSONString: json)!
        client.setObjects()
        
        return client
    }

    static func fromJsonToList(json:String) throws ->Array<Client>
    {
        var items   = Array<Client>()
        if(json     != "")
        {
            //var error: NSError
            if let data     = json.data(using: String.Encoding.utf8)
            {
                if let _    = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]]
                {
                    items   = Mapper<Client>().mapArray(JSONString: json)!
                }
            }
        }
        return items
    }

    func toJson()->String
    {
        return Mapper().toJSONString(self, prettyPrint: true)!
    }
    
    func toDictionary()->[String: Any]?
    {
        print("json = \(self.toJson())")
        if let data = self.toJson().data(using: .utf8)
        {
            do
            {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func toJsonFromList(items:Array<Client>)->String
    {
        return Mapper().toJSONString(items, prettyPrint: true)!
    }
    
    func setObjects()
    {
        var objs:Objects = Objects()
        if (self.points != "")
        {
            if let data     = self.points.data(using: String.Encoding.utf8)
            {
                objs        = Objects.fromJson(json: String.init(data: data, encoding: String.Encoding.utf8)!)
                print(objs.toJson())
            }
        }
        
        self.objects    = objs
    }
    /*
     {
     "type":"image",
     "originX":"left",
     "originY":"top",
     "left":65,
     "top":-1.5,
     "width":794,
     "height":711,
     "fill":"rgb(0,0,0)",
     "stroke":null,
     "strokeWidth":0,
     "strokeDashArray":null,
     "strokeLineCap":"butt",
     "strokeLineJoin":"miter",
     "strokeMiterLimit":10,
     "scaleX":1,
     "scaleY":1,
     "angle":0,
     "flipX":false,
     "flipY":false,
     "opacity":1,
     "shadow":null,
     "visible":true,
     "clipTo":null,
     "backgroundColor":"",
     "fillRule":"nonzero",
     "globalCompositeOperation":"source-over",
     "transformMatrix":null,
     "skewX":0,
     "skewY":0,
     "src":"http://192.168.0.123/upload/model_2.png",
     "filters":[
     ],
     "resizeFilters":[
     ],
     "crossOrigin":"",
     "alignX":"none",
     "alignY":"none",
     "meetOrSlice":"meet",
     "id":0,
     "createdWidth":924,
     "hasControls":false,
     "hasBorders":false,
     "lockMovementX":false,
     "lockMovementY":false,
     "selectable":false
     }
    */


}
