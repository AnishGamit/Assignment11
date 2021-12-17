//
//  Student.swift
//  Assignment11
//
//  Created by DCS on 17/12/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import Foundation
class Student{
    var spid:Int = 0
    var sname:String = ""
    var email:String = ""
    var gen:String = ""
    var pwd:String = ""
    var course:String = ""
    
    init(spid:Int,sname:String,email:String,gen:String,pwd:String,course:String) {
        self.spid = spid
        self.sname = sname
        self.email = email
        self.gen = gen
        self.pwd = pwd
        self.course = course
    }
}
