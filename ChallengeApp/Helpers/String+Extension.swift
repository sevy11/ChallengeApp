//
//  String+Extension.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 5/28/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation


extension String {
    func isEqualToCaseInsensitive(string: String) -> Bool {
        let result: ComparisonResult = self.compare(string, options: NSString.CompareOptions.caseInsensitive)
        return result == .orderedSame ? true : false
    }
}
