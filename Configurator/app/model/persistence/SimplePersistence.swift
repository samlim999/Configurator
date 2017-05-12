//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class SimplePersistence {

    static func exist(key:String)->Bool
    {
        return Defaults.hasKey(key)
    }

    static func setString(key:String, value:String)
    {
        setStringWithDefaultKey(key: DefaultsKey<String>(key), value: value)
    }

    static func getString(key:String)->String
    {
        return getStringWithDefaultKey(key: DefaultsKey<String>(key))
    }

    static func setStringWithDefaultKey(key:DefaultsKey<String>, value:String)
    {
        Defaults[key] = value
    }
    
    static func getStringWithDefaultKey(key:DefaultsKey<String>)->String
    {
        if Defaults.hasKey(key)
        {
            return Defaults[key] as String
        }
        else
        {
            return ""
        }
    }

    static func setBool(key:String, value:Bool)
    {
        setBoolWithDefaultKey(key: DefaultsKey<Bool>(key), value:value)
    }

    static func getBool(key:String)->Bool
    {
        return getBoolWithDefaultKey(key: DefaultsKey<Bool>(key))
    }

    static func setBoolWithDefaultKey(key:DefaultsKey<Bool>, value:Bool)
    {
        Defaults[key] = value
    }

    static func getBoolWithDefaultKey(key:DefaultsKey<Bool>)->Bool
    {
        if Defaults.hasKey(key)
        {
            return Defaults[key] as Bool
        }
        else
        {
            return false
        }
    }
}
