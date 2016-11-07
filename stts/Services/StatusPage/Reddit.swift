//
//  Reddit.swift
//  stts
//
//  Created by inket on 7/11/16.
//  Copyright © 2016 inket. All rights reserved.
//

import Cocoa

class Reddit: StatusPageService {
    override var name: String { return "Reddit" }
    override var url: URL { return URL(string: "https://www.redditstatus.com/")! }
    override var statusPageID: String { return "2kbc0d48tv3j" }
}
