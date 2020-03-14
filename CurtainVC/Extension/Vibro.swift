//
//  Vibro.swift
//  GinzaGO
//
//  Created by Username on 27.11.2019.
//  Copyright © 2019 Hudihka. All rights reserved.
//

import Foundation
import AudioToolbox

class Vibro: NSObject {
    static func strong() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    static func weak() {
        AudioServicesPlaySystemSound(1_520)
    }

}
