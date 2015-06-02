//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Abdelaziz Elrashed on 6/1/15.
//  Copyright (c) 2015 Abdelaziz Elrashed. All rights reserved.
//

import Foundation

class RecordedAudio{
    
    var title:String!
    var filePathURL:NSURL!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathURL = filePathUrl
        self.title = title
    }
}