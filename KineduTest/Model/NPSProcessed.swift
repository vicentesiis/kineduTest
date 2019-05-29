//
//  File.swift
//  KineduTest
//
//  Created by Vicente Cantu Garcia on 5/29/19.
//  Copyright © 2019 Vicente Cantu Garcia. All rights reserved.
//

import Foundation

enum UserPlan{
    
    case premium
    case freemium
}

class NPSProcessed {
    
    var version: String!
    
    var premium = Array(repeating: 0, count: 11)
    var freemium = Array(repeating: 0, count: 11)
    
    var activityViews: [[(countOfUsers: Int, activityViews: Int)]] = Array(repeating: [], count: 11)
    
    init(version: String) {
        self.version = version
    }
    
    
    // Return a tuple with the NPS Score and the total of users
    func getNPSScore(_ userPlan: UserPlan) -> (Int, Int) {
        
        var userPlanSelected: [Int]!
        
        switch userPlan {
        case .premium:
            userPlanSelected = premium
        case .freemium:
            userPlanSelected = freemium
        }
        
        var total = 0
        var detractors = 0
        var promoters = 0
        
        for i in 0 ..< userPlanSelected.count {
            total += userPlanSelected[i]
            if i <= 6 {
                detractors += userPlanSelected[i]
            } else if i > 8 {
                promoters += userPlanSelected[i]
            }
        }
        
        let npsScore = Int(((Double(promoters) / Double(total)) * 100) - ((Double(detractors) / Double(total)) * 100))
        
        return (npsScore, total)
    }
    
}
