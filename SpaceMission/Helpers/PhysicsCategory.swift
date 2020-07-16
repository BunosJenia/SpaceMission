//
//  PhysicsCategory.swift
//  SpaceMission
//
//  Created by Yauheni Bunas on 7/15/20.
//  Copyright © 2020 Yauheni Bunas. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Enemy: UInt32 = 4
    static let Asteroid: UInt32 = 8
}
