//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import ObjectMapper

class Objects : Mappable
{
    var objects     :   Array<Object>
    var background  : String
    var height      : Int

    init()
    {
        objects     = []
        background  = ""
        height      = 0
    }

    required init?(map: Map)
    {
        objects     = []
        background  = ""
        height      = 0
    }

    // Mappable
    func mapping(map: Map)
    {
        objects     <- map["objects"]
        background  <- map["background"]
        height      <- map["height"]
    }

    static func fromJson(json:String)->Objects
    {
        return Mapper<Objects>().map(JSONString: json)!;
    }

    static func fromJsonToList(json:String) throws ->Array<Object>
    {
        var items   = Array<Object>()
        
        if(json     != "")
        {
            //var error: NSError
            if let data     = json.data(using: String.Encoding.utf8)
            {
                if let _    = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: AnyObject]]
                {
                    items   = Mapper<Object>().mapArray(JSONString: json)!
                }
            }
        }
        
        return items
    }

    func toJson()->String
    {
        return Mapper().toJSONString(self, prettyPrint: true)!
    }

    func toNonPrettyJson()->String
    {
        return Mapper().toJSONString(self, prettyPrint: false)!
    }
    
    static func toJsonFromList(items:Array<Object>)->String
    {
        return Mapper().toJSONString(items, prettyPrint: true)!
    }
}
