//
// Copyright (c) 2016 Frazzle. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class UserManager
{
    private static let KEY_USER:String      = "KEY_USER"
    private static let KEY_LOGGED_IN:String = "KEY_LOGGED_IN"

    private static var shopuserInfo : User!
    private static var searchQuery : String!
    
    static func loginUser(user:User)
    {
        UserService.loginUser(user: user)
    }
    
    static func signupUser(user:User)
    {
        UserService.signupUser(user: user)
    }

    static func logoutUser()
    {
        SimplePersistence.setBool(key: KEY_LOGGED_IN, value: false)
        SimplePersistence.setString(key: KEY_USER, value:"")
    }

    static func setLoginUser(user:User)
    {
        SimplePersistence.setBool(key: KEY_LOGGED_IN, value: true)
        SimplePersistence.setString(key: KEY_USER, value:user.toJson())
    }
    
    static func updateLogInUser(user:User)
    {
        SimplePersistence.setString(key: KEY_USER, value:user.toJson())
    }

    static func isUserLoggedIn()->Bool
    {
        return SimplePersistence.getBool(key: KEY_LOGGED_IN)
    }

    static func getLoggedInUser()->User?
    {
        let key = DefaultsKey<String>(KEY_USER)

        if Defaults.hasKey(key)
        {
            return User.fromJson(json: Defaults[key])
        }
        else
        {
            let user = User()
            user.username = "test@test.com"
            user.password = "asd"
            return user
        }
    }
}
