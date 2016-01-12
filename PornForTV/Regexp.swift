//
//  Regexp.swift
//  PornForTV
//
//  Created by Tomoya_Hirano on H28/01/12.
//  Copyright © 平成28年 noppefoxwolf. All rights reserved.
//

import UIKit

class Regexp {
  let internalRegexp: NSRegularExpression
  let pattern: String
  
  init(_ pattern: String) {
    self.pattern = pattern
    self.internalRegexp = try! NSRegularExpression( pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
  }
  
  func isMatch(input: String) -> Bool {
    let matches = self.internalRegexp.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
    return matches.count > 0
  }
  
  func matches(input: String) -> [String]? {
    if self.isMatch(input) {
      let matches = self.internalRegexp.matchesInString( input, options: [], range:NSMakeRange(0, input.characters.count) )
      var results: [String] = []
      for i in 0 ..< matches.count {
        results.append( (input as NSString).substringWithRange(matches[i].range) )
      }
      return results
    }
    return nil
  }
}

