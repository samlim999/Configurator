//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

class ThemeUtil {

    static func getModeColor(type:C.MainMode)->UIColor
    {
        switch type
        {
        case C.MainMode.MAIN_EMOTION:
            return UIColor(C.COLOR_MAIN_EMOTION)
        case C.MainMode.MAIN_POINT:
            return UIColor(C.COLOR_MAIN_POINT)
        case C.MainMode.MAIN_DRAW:
            return UIColor(C.COLOR_MAIN_DRAW)
        case C.MainMode.MAIN_DEFINED:
            return UIColor(C.COLOR_MAIN_DEFINED)
        case C.MainMode.MAIN_INIT:
            return UIColor(C.COLOR_MAIN_INIT)
            
        }
    }

    static func getStateColor(type:C.ButtonState)->UIColor
    {
        switch type
        {
        case C.ButtonState.NORMAL_STATE:
            return UIColor(C.COLOR_LABEL_NORMAL)
        case C.ButtonState.SELECTED_STATE:
            return UIColor(C.COLOR_LABEL_SELECTED)
        }
    }
    
    static func getGenderButtonColor(type:C.ButtonState)->UIColor
    {
        switch type
        {
        case C.ButtonState.NORMAL_STATE:
            return UIColor(C.COLOR_GENDER_BUTTON_NORMAL)
        case C.ButtonState.SELECTED_STATE:
            return UIColor(C.COLOR_GENDER_BUTTON_SELECTED)
        }
    }
    
    static func getGenderLabelColor(type:C.ButtonState)->UIColor
    {
        switch type
        {
        case C.ButtonState.NORMAL_STATE:
            return UIColor(C.COLOR_GENDER_LABEL_NORMAL)
        case C.ButtonState.SELECTED_STATE:
            return UIColor(C.COLOR_GENDER_LABEL_SELECTED)
        }
    }
    
    static func getMainCategoryBorderColor()->UIColor
    {
        return UIColor(C.COLOR_MAIN_CATEGORY_BORDER)
    }
    
    static func getMainCategoryLabelColor()->UIColor
    {
        return UIColor(C.COLOR_MAIN_CATEGORY_LABEL)
    }
    
    static func getSubCategoryBorderColor()->UIColor
    {
        return UIColor(C.COLOR_MAIN_CATEGORY_BORDER)
    }
    
}
