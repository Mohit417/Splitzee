//
//  Transactions.swift
//  Splitzee
//
//  Created by Mohit Katyal on 11/10/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import Foundation
import UIKit

struct Constants
{
    
    // COLORS FOR SHAPES - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    let white: UIColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 1.0) /* #ffffff */
    let whiteTransparent: UIColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.2) /* #ffffff */
    let darkGray: UIColor = UIColor(hue: 0, saturation: 0, brightness: 0.26, alpha: 1.0) /* #444444 */
    let lightRed: UIColor = UIColor(hue: 0.0139, saturation: 0.27, brightness: 0.9, alpha: 1.0) /* #e8aea8 */
    let red: UIColor = UIColor(hue: 0, saturation: 0.61, brightness: 1, alpha: 1.0) /* #ff6262 */
    let lightBlue: UIColor = UIColor(hue: 0.5667, saturation: 0.25, brightness: 1, alpha: 1.0) /* #bee5ff */
    let mediumBlue: UIColor = UIColor(hue: 0.5722, saturation: 0.39, brightness: 1, alpha: 1.0) /* #9ad3ff */
    let gradientBlue: UIColor = UIColor(hue: 0.5444, saturation: 0.27, brightness: 1, alpha: 1.0) /* #b8ebff */
    let gradientPurple: UIColor = UIColor(hue: 0.6833, saturation: 0.24, brightness: 1, alpha: 1.0) /* #c7c0ff */
    let lightGreen: UIColor = UIColor(hue: 0.25, saturation: 0.27, brightness: 0.9, alpha: 1.0) /* #c7e8a8 */
    
    
    // COLORS FOR FONTS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    let fontWhite: UIColor = UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 1.0) /* #ffffff */
    let fontLightGray: UIColor = UIColor(hue: 0, saturation: 0, brightness: 0.79, alpha: 1.0) /* #cbcbcb */
    let fontMediumGray: UIColor = UIColor(hue: 0.5722, saturation: 0.04, brightness: 0.75, alpha: 1.0) /* #b7bcc0 */
    let fontDarkGray: UIColor = UIColor(hue: 0, saturation: 0, brightness: 0.47, alpha: 1.0) /* #787878 */
    let fontMediumBlue: UIColor = UIColor(hue: 0.5722, saturation: 0.39, brightness: 1, alpha: 1.0) /* #9ad3ff */
    let fontMediumDarkBlue: UIColor = UIColor(hue: 0.6833, saturation: 0.24, brightness: 1, alpha: 1.0) /* #c7c0ff */
    
    struct DataNames {
        static let User = "User"
        static let Transaction = "Transaction"
        static let Group = "Group"

    }
    
    struct UserFields {
        static let name = "name"
        static let profPicURL = "profPicURL"
        static let email = "email"
        static let transactionIDs = "transactionIDs"
        static let groupIDs = "memberIDs"
        static let groupAdminIDs = "adminIDs"
    }
    
    struct TransactionFields {
        static let groupID = "groupID"
        static let groupToMember = "groupToMember"
        static let memberID = "memberID"
        static let amount = "amount"
        static let isApproved = "isApproved"
        static let isRejected = "isRejected"
        static let isFlagged = "isFlagged"
        static let description = "description"
    }
    
    struct GroupFields {
        static let name = "name"
        static let picURL = "picURL"
        static let memberIDs = "memberIDs"
        static let adminIDs = "adminIDs"
        static let transactionIDs = "transactionIDs"
        static let total = "total"
        static let memberCode = "memberCode"
        static let adminCode = "adminCode"
    }
    
    
    
    /*  COLORS FOR EACH VC - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     
     Follow these instead of using the Sketch file!
     
     Sign In VC
     SHAPES: white, red, darkGray
     FONTS:  fontWhite, fontLightGray
     
     Create Account VC
     SHAPES: white, red,
     FONTS:  fontWhite, fontLightGray
     
     Create Group VC
     SHAPES: white, mediumBlue
     FONTS:  fontWhite, fontMediumGray
     
     Admin Page VC
     SHAPES: white, whiteTransparent, mediumBlue, lightBlue (CELL), lightRed (CELL), lightGreen (CELL)
     FONTS:  fontWhite, fontMediumBlue, fontMediumDarkBlue (CELL)
     
     Member Page VC
     SHAPES: white, whiteTransparent, mediumBlue, lightBlue (CELL), lightRed (CELL), lightGreen (CELL)
     FONTS:  fontWhite, fontMediumBlue, fontMediumDarkBlue (CELL)
     
     Detail VC
     SHAPES: white, lightRed, lightGreen, mediumBlue
     FONTS:  fontWhite, fontMediumBlue, fontDarkGray
     
     New Admin Transaction VC
     SHAPES: white, mediumBlue
     FONTS:  fontWhite, fontMediumBlue, fontDarkGray
     
     New Member Transaction VC
     SHAPES: white, mediumBlue
     FONTS:  fontWhite, fontMediumBlue, fontDarkGray
     
     */
    
    
}
