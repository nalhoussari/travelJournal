//
//  User.swift
//  travelJournal
//
//  Created by Katrina de Guzman on 2017-07-17.
//  Copyright © 2017 Noor Alhoussari. All rights reserved.
//

import Foundation


struct User {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
