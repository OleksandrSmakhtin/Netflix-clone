//
//  YTSeachResponse.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 14.01.2023.
//

import Foundation


struct YTSearchResponse: Codable {
    
    let items: [VideoElement]
}

struct VideoElement: Codable {
    
    let id: IDVideoElement
}

struct IDVideoElement: Codable {
    let kind: String
    let videoId: String
}
