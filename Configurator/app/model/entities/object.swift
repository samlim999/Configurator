//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import ObjectMapper

class Object : Mappable
{
    var type                            :String
    var originX                         :String
    var originY                         :String
    var left                            :Float
    var top                             :Float
    var width                           :Float
    var height                          :Float
    var fill                            :String
    var stroke                          :String
    var strokeWidth                     :Float
    var strokeDashArray                 :[Float]
    var strokeLineCap                   :String
    var strokeLineJoin                  :String
    var strokeMiterLimit                :Float
    var scaleX                          :Float
    var scaleY                          :Float
    var angle                           :Float
    var flipX                           :Bool
    var flipY                           :Bool
    var opacity                         :Float
    var shadow                          :String
    var visible                         :Bool
    var clipTo                          :Float
    var backgroundColor                 :String
    var fillRule                        :String
    var globalCompositeOperation        :String
    var transformMatrix                 :String
    var skewX                           :Float
    var skewY                           :Float
    var src                             :String
    var crossOrigin                     :String
    var alignX                          :String
    var alignY                          :String
    var meetOrSlice                     :String
    var id                              :Int
    var description                     :String
    var category                        :String
    var sub_category                    :String
    var title                           :String
    var sub_title                       :String
    var patternColor                    :String
    var mode                            :Int
    var createdWidth                    :Float
    var hasControls                     :Bool
    var hasBorders                      :Bool
    var lockMovementX                   :Bool
    var lockMovementY                   :Bool
    var selectable                      :Bool
    var myCustomOptionKeepStrokeWidth   :Float
    var path                            :[[Any]]
    var pathOffset                      :PathOffset
    var radius                          :Float

    init()
    {
        type                            = ""
        originX                         = "left"
        originY                         = "top"
        left                            = 0
        top                             = 0
        width                           = 0
        height                          = 0
        fill                            = "rgb(0,0,0)"
        stroke                          = ""
        strokeWidth                     = 1.6
        strokeDashArray                 = [3, 4]
        strokeLineCap                   = "butt"
        strokeLineJoin                  = "miter"
        strokeMiterLimit                = 10
        scaleX                          = 1
        scaleY                          = 1
        angle                           = 0
        flipX                           = false
        flipY                           = false
        opacity                         = 1
        shadow                          = ""
        visible                         = true
        clipTo                          = 0
        backgroundColor                 = ""
        fillRule                        = "nonzero"
        globalCompositeOperation        = "source-over"
        transformMatrix                 = ""
        skewX                           = 0
        skewY                           = 0
        src                             = ""
        crossOrigin                     = ""
        alignX                          = ""
        alignY                          = ""
        meetOrSlice                     = ""
        id                              = -1
        description                     = ""
        category                        = ""
        sub_category                    = ""
        title                           = ""
        sub_title                       = ""
        patternColor                    = ""
        mode                            = 0
        createdWidth                    = 0
        hasControls                     = true
        hasBorders                      = true
        lockMovementX                   = false
        lockMovementY                   = false
        selectable                      = true
        myCustomOptionKeepStrokeWidth   = 1.6
        path                            = [[]]
        pathOffset                      = PathOffset()
        radius                          = 0
    }

    required init?(map: Map)
    {
        type                            = ""
        originX                         = "left"
        originY                         = "top"
        left                            = 0
        top                             = 0
        width                           = 0
        height                          = 0
        fill                            = "rgb(0,0,0)"
        stroke                          = ""
        strokeWidth                     = 1.6
        strokeDashArray                 = [3, 4]
        strokeLineCap                   = "butt"
        strokeLineJoin                  = "miter"
        strokeMiterLimit                = 10
        scaleX                          = 1
        scaleY                          = 1
        angle                           = 0
        flipX                           = false
        flipY                           = false
        opacity                         = 1
        shadow                          = ""
        visible                         = true
        clipTo                          = 0
        backgroundColor                 = ""
        fillRule                        = "nonzero"
        globalCompositeOperation        = "source-over"
        transformMatrix                 = ""
        skewX                           = 0
        skewY                           = 0
        src                             = ""
        crossOrigin                     = ""
        alignX                          = "none"
        alignY                          = "none"
        meetOrSlice                     = "meet"
        id                              = -1
        description                     = ""
        category                        = ""
        sub_category                    = ""
        title                           = ""
        sub_title                       = ""
        patternColor                    = ""
        mode                            = 0
        createdWidth                    = 0
        hasControls                     = true
        hasBorders                      = true
        lockMovementX                   = false
        lockMovementY                   = false
        selectable                      = true
        myCustomOptionKeepStrokeWidth   = 1.6
        path                            = [[]]
        pathOffset                      = PathOffset()
        radius                          = 0
    }

    // Mappable
    func mapping(map: Map)
    {
        type                            <- map["type"]
        originX                         <- map["originX"]
        originY                         <- map["originY"]
        left                            <- map["left"]
        top                             <- map["top"]
        width                           <- map["width"]
        height                          <- map["height"]
        fill                            <- map["fill"]
        stroke                          <- map["stroke"]
        strokeWidth                     <- map["strokeWidth"]
        strokeDashArray                 <- map["strokeDashArray"]
        strokeLineCap                   <- map["strokeLineCap"]
        strokeLineJoin                  <- map["strokeLineJoin"]
        strokeMiterLimit                <- map["strokeMiterLimit"]
        scaleX                          <- map["scaleX"]
        scaleY                          <- map["scaleY"]
        angle                           <- map["angle"]
        flipX                           <- map["flipX"]
        flipY                           <- map["flipY"]
        opacity                         <- map["opacity"]
        shadow                          <- map["shadow"]
        visible                         <- map["visible"]
        clipTo                          <- map["clipTo"]
        backgroundColor                 <- map["backgroundColor"]
        globalCompositeOperation        <- map["globalCompositeOperation"]
        transformMatrix                 <- map["transformMatrix"]
        skewX                           <- map["skewX"]
        skewY                           <- map["skewY"]
        src                             <- map["src"]
        crossOrigin                     <- map["crossOrigin"]
        alignX                          <- map["alignX"]
        alignY                          <- map["alignY"]
        meetOrSlice                     <- map["meetOrSlice"]
        id                              <- map["id"]
        description                     <- map["description"]
        category                        <- map["category"]
        sub_category                    <- map["sub_category"]
        title                           <- map["title"]
        sub_title                       <- map["sub_title"]
        patternColor                    <- map["patternColor"]
        mode                            <- map["mode"]
        createdWidth                    <- map["createdWidth"]
        hasControls                     <- map["hasControls"]
        hasBorders                      <- map["hasBorders"]
        lockMovementX                   <- map["lockMovementX"]
        lockMovementY                   <- map["lockMovementY"]
        selectable                      <- map["selectable"]
        myCustomOptionKeepStrokeWidth   <- map["myCustomOptionKeepStrokeWidth"]
        path                            <- map["path"]
        pathOffset                      <- map["pathOffset"]
        radius                          <- map["radius"]
    }

    static func fromJson(json:String)->Object
    {
        return Mapper<Object>().map(JSONString: json)!;
    }

    static func fromJsonToList(json:String) throws ->Array<Object>
    {
        var items   = Array<Object>()
        if(json     != "")
        {
            
            //var error: NSError
            if let data     = json.data(using: String.Encoding.utf8)
            {
                if let _    = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
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

    static func toJsonFromList(items:Array<Object>)->String
    {
        return Mapper().toJSONString(items, prettyPrint: true)!
    }

    static func toJsonNonPrettyFromList(items:Array<Object>)->String
    {
        return Mapper().toJSONString(items, prettyPrint: false)!
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
