//
//  AdminCollectionViewCell.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol AdminPendingTableViewCellDelegate : class {
    func approve(transaction: Transaction)
    func reject(transaction: Transaction)
}

class AdminPendingTableViewCell: UITableViewCell {
    
    var memberPicView: UIImageView!
    var memberNameLabel: UILabel!
    var descriptionLabel: UILabel!
    var rejectButton: UIButton!
    var approveButton: UIButton!
    var transaction: Transaction!
    let constants = Constants()
    let rootRef = FIRDatabase.database().reference()
    var reportButton: UIButton!
    
    weak var delegate : AdminPendingTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        makeMemberPicView()
        makeMemberNameLabel()
        makeDescriptionLabel()
        makeRejectButton()
        makeApproveButton()
        makeReportButton()
    }
    
    func makeMemberPicView() {
        memberPicView = UIImageView()
        memberPicView.frame = CGRect(x: 0.05 * contentView.frame.width, y: 0.05 * contentView.frame.height, width: 0.900 * contentView.frame.height, height: 0.900 * contentView.frame.height)
        memberPicView.clipsToBounds = true
        memberPicView.contentMode = .scaleAspectFill
        memberPicView.image = #imageLiteral(resourceName: "Group")
        memberPicView.layer.cornerRadius = 0.5 * 0.900 * contentView.frame.height
        contentView.addSubview(memberPicView)
    }
    
    func makeMemberNameLabel() {
        memberNameLabel = UILabel()
        memberNameLabel.frame = CGRect(x: 0.251 * contentView.frame.width, y: 0.005 * contentView.frame.height, width: 0.749 * contentView.frame.width, height: 0.25 * contentView.frame.height)
        memberNameLabel.textColor = constants.fontMediumBlue
        memberNameLabel.font = UIFont(name: "SFUIText-Semibold", size: 14)
        contentView.addSubview(memberNameLabel)
    }
    
    func makeDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 0.251 * contentView.frame.width, y: 0.225 * contentView.frame.height, width: 0.696 * contentView.frame.width, height: 0.425 * contentView.frame.height)
        descriptionLabel.textColor = UIColor.blue
        descriptionLabel.textColor = constants.fontMediumBlue
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont(name: "SFUIText-LightItalic", size: 12)
        contentView.addSubview(descriptionLabel)
    }
    
    func makeRejectButton() {
        rejectButton = UIButton()
        rejectButton.frame = CGRect(x: 0.248 * contentView.frame.width, y: 0.672 * contentView.frame.height, width: 0.340 * contentView.frame.width, height: 0.303 * contentView.frame.height)
        rejectButton.setTitle("Reject", for: .normal)
        rejectButton.layer.borderColor = UIColor.blue.cgColor
        rejectButton.layer.borderColor = constants.lightBlue.cgColor
        rejectButton.titleLabel?.textColor = constants.fontMediumDarkBlue
        rejectButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 10)
        rejectButton.backgroundColor = constants.lightRed
        rejectButton.layer.cornerRadius = 3
        rejectButton.addTarget(self, action: #selector(reject), for: .touchUpInside)
        contentView.addSubview(rejectButton)
    }
    
    func makeApproveButton() {
        approveButton = UIButton()
        approveButton.frame = CGRect(x: 0.603 * contentView.frame.width, y: 0.672 * contentView.frame.height, width: 0.340 * contentView.frame.width, height: 0.303 * contentView.frame.height)
        approveButton.titleLabel?.textColor = UIColor.white
        approveButton.titleLabel?.font = UIFont(name: "SFUIText-Medium", size: 10)
        approveButton.layer.cornerRadius = 3
        approveButton.backgroundColor = constants.lightGreen
        approveButton.addTarget(self, action: #selector(approve), for: .touchUpInside)
        contentView.addSubview(approveButton)
    }
    
    func makeReportButton() {
        reportButton = UIButton(frame: CGRect(x: 0.803 * contentView.frame.width, y: 0.15 * contentView.frame.height, width: 0.14 * contentView.frame.width, height: 0.225 * contentView.frame.height))
        reportButton.setTitle("Report", for: .normal)
        reportButton.setTitleColor(constants.lightRed, for: .normal)
        reportButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 12)
        reportButton.layer.borderWidth = 1
        reportButton.layer.cornerRadius = 3
        reportButton.layer.borderColor = constants.lightRed.cgColor
        reportButton.clipsToBounds = true
        contentView.addSubview(reportButton)
    }
    
    func approve() {
        delegate?.approve(transaction: transaction)
    }
    
    func reject() {
        delegate?.reject(transaction: transaction)
    }
    
}
 
