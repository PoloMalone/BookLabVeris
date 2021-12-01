//
//  active.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-14.
//

import Foundation
import FirebaseFirestore

class active{
    
    var activeDesc: String?
    var activeEmail: String?
    var activeId: String?
    var activeName: String?
    var activeBookingId: String?
    var timestamp: String?

    init(activeDesc:String?, activeEmail:String?, activeId:String?, activeName:String?, activeBookingId:String? ,timestamp:String?){
        self.activeDesc = activeDesc;
        self.activeEmail = activeEmail;
        self.activeId = activeId;
        self.activeName = activeName;
        self.activeBookingId = activeBookingId;
        self.timestamp = timestamp;
}

}
