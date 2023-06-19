//
//  Utils.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/16/23.
//

import Foundation
import SwiftUI

func createEmojiFlag(isoCode: String) -> String? {
    let baseOffset: UInt32 = 127397  // Offset for regional indicator symbol '🇦'
    let flagScalars = isoCode.uppercased().unicodeScalars
        .compactMap { UnicodeScalar(baseOffset + $0.value) }

    guard flagScalars.count == 2 else {
        return nil  // Invalid ISO code
    }

    return String(String.UnicodeScalarView(flagScalars))
}
