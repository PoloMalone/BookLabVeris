//
//  history.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-12.
//

import Foundation

class history{
    
    
   
    var historyEmail: String?
    var historyId: String?
    var historyName: String?
    var timestamp: String?
    var historyAction: String?
    
    init(historyEmail:String?, historyId:String?, historyName:String?, timestamp:String?, historyAction:String?){
        self.historyEmail = historyEmail;
        self.historyId = historyId;
        self.historyName = historyName;
        self.timestamp = timestamp;
        self.historyAction = historyAction;
    }
    
    
    
}
