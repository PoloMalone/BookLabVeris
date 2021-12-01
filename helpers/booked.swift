//
//  booked.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-07.
//

import Foundation
import FirebaseFirestore

class booked{
    
    var bookDesc: String?
    var bookEmail: String?
    var bookId: String?
    var bookName: String?
    var bookingId: String?
    var timestamp: String?
    
    init(bookDesc:String?, bookEmail:String?, bookId:String?, bookName:String?, bookingId:String?, timestamp:String?){
        self.bookDesc = bookDesc;
        self.bookEmail = bookEmail;
        self.bookId = bookId;
        self.bookName = bookName;
        self.bookingId = bookingId;
        self.timestamp = timestamp;
    }
    
    
}
