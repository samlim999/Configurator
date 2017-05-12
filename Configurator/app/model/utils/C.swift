//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import UIKit

class C
{
    static let DEBUG:Bool = true

//    static let BASE_URL:String              = "http://192.168.0.123"
    static let BASE_URL:String              = "http://83.169.4.108"
    
    static let WEB_SERVICES_VERSION:String  = "/user/index"
    static let URL_SERVER:String            = BASE_URL + WEB_SERVICES_VERSION

    static let HEADERS = [
            "FrazzleTV-Client": "iOS",
            "X-FrazzleTV-REST-API-Key": "70875e1af7fc495c9553d50df890c783",
            "X-FrazzleTV-REST-API-Secret": "b7f21e4f83be4bdfa8f6e16676c9391f",
            "Content-Type": "application/json"
    ]

    enum TimelineType
    {
        case SHOPS
        case HERBS
        case TUNES
        case VIBES
        case LIVE
        case LIVE_PAST
        case SEARCH
    }

    enum UsersType
    {
        case PROFILES
        case FOLLOWERS
        case FOLLOWING
        case SEARCH
    }

    enum TabType: String
    {
        case HOME_HERBS
        case HOME_SHOPS
        case HOME_TUNES
        case HOME_VIBES
        case SHOPS
        case USERS_PROFILES
        case USERS_FOLLOWERS
        case USERS_FOLLOWING
        case LIVE
        case SEARCH
    }

    enum MainMode: String
    {
        case MAIN_EMOTION
        case MAIN_POINT
        case MAIN_DRAW
        case MAIN_DEFINED
        case MAIN_INIT
    }

    enum ButtonState: String
    {
        case NORMAL_STATE
        case SELECTED_STATE
    }
    
    static let COLOR_LABEL_NORMAL:String            = "#1F2833"
    static let COLOR_LABEL_SELECTED:String          = "#FFFFFF"
    
    static let COLOR_MAIN_CATEGORY_BORDER:String    = "#EBEBEB"
    static let COLOR_MAIN_CATEGORY_LABEL:String     = "#A6A9AD"
    
    static let COLOR_SUB_CATEGORY_BORDER:String     = "#F2EFEF"
    
    static let COLOR_GENDER_BUTTON_NORMAL:String    = "#F3F4F2"
    static let COLOR_GENDER_BUTTON_SELECTED:String  = "#E6648E"
    static let COLOR_GENDER_LABEL_NORMAL:String     = "#A8BEC4"
    static let COLOR_GENDER_LABEL_SELECTED:String   = "#FFFFFF"
    
    static let COLOR_MAIN_EMOTION:String            = "#5972CB"
    static let COLOR_MAIN_POINT:String              = "#2BB0D4"
    static let COLOR_MAIN_DRAW:String               = "#83D7A4"
    static let COLOR_MAIN_DEFINED:String            = "#F5AF62"
    static let COLOR_MAIN_INIT:String               = "#FFFFFF"
    
    static let NEW_PHOTO_CHANGED:String             = "NEW_PHOTO_CHANGED"
    static let NEW_PHOTO_CHANGED_WORKSPACE:String   = "NEW_PHOTO_CHANGED_WORKSPACE"
    
    static let REMOVE_SUB_VIEW:String               = "REMOVE_SUB_VIEW"
    
    static let USER_LOGGED_IN:String                = "USER_LOGGED_IN"
    static let USER_NOT_LOGGED_IN:String            = "USER_NOT_LOGGED_IN"
    static let USER_SIGNED_UP:String                = "USER_SIGNED_UP"
    static let USER_NOT_SIGNED_UP:String            = "USER_NOT_SIGNED_UP"
    static let USER_LOGGED_OUT:String               = "USER_LOGGED_OUT"
    static let USER_UPDATED:String                  = "USER_UPDATED"
    static let USER_FAILED_UPDATED:String           = "USER_FAILED_UPDATED"
    
    static let CLIENTS_DOWNLOADED:String            = "CLIENTS_DOWNLOADED"
    static let CLIENTS_EMPTY_DOWNLOADED:String      = "CLIENTS_EMPTY_DOWNLOADED"
    static let CLIENTS_FAILED_DOWNLOADED:String     = "CLIENTS_FAILED_DOWNLOADED"
    
    static let CLIENT_CREATED:String                = "CLIENT_CREATED"
    static let CLIENT_FAILED_CREATED:String         = "CLIENT_FAILED_CREATED"
    
    static let CLIENT_UPDATED:String                = "CLIENT_UPDATED"
    static let CLIENT_UPDATED_WITH_IMAGE:String     = "CLIENT_UPDATED_WITH_IMAGE"
    static let CLIENT_FAILED_UPDATED:String         = "CLIENT_FAILED_UPDATED"
    
    static let CLIENT_REMOVED:String                = "CLIENT_REMOVED"
    static let CLIENT_FAILED_REMOVED:String         = "CLIENT_FAILED_REMOVED"
    
    static let START_INDEX:Int                      = 100
}
