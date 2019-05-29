//
//  Manager.swift
//  KineduTest
//
//  Created by Vicente Cantu Garcia on 5/29/19.
//  Copyright © 2019 Vicente Cantu Garcia. All rights reserved.
//

import Foundation

fileprivate let PREMIUM = "premium"

class Manager {
    
    var allNPS: [NPSProcessed] = []
    
    func proccesData(allData: [NPS], valuesProcessed: @escaping ([NPSProcessed]) -> Void) {

        var nps: NPSProcessed!

        for data in allData {
            
            nps = allNPS.filter({ $0.version == data.build.version }).first ?? (NPSProcessed(version: data.build.version))
            
            let foundIndex = nps.activityViews[data.nps].firstIndex(where: { $0.activityViews == data.activity_views })
            
            if let index = foundIndex {
                nps.activityViews[data.nps][index].countOfUsers += 1
            } else {
                nps.activityViews[data.nps].append((1, data.activity_views))
            }
            
            if data.user_plan == PREMIUM {
                nps.premium[data.nps] += 1
            } else {
                nps.freemium[data.nps] += 1
            }
            
            if !allNPS.contains(where: { $0.version == nps.version }) {
                allNPS.append(nps)
            }
            
        }
        valuesProcessed(allNPS)
    }
    
}
