//
//  SettingsViewController.swift
//  CupixMADV360Demo_Swift
//
//  Created by DOM QIU on 2018/10/15.
//  Copyright © 2018 QiuDong. All rights reserved.
//

import Foundation
import UIKit

enum CellID : Int {
    case FirmwareVer = 0
    case Space = 1
    case BeepingVolume = 2
    case PhotoResolution = 3
    case WhiteBalance = 4
    case ISO = 5
}

@objc(SettingsViewController) class SettingsViewController : UITableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch indexPath.row
        {
        case CellID.FirmwareVer.rawValue:
            cell.detailTextLabel?.text = "Unknown version"
        default:
            break
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case CellID.ISO.rawValue:
            let alertController:UIAlertController? = UIAlertController(title: "ISO Setting", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let iso800 = UIAlertAction(title: "800", style: UIAlertActionStyle.default) { (UIAlertAction) in
                
            }
            let iso1600 = UIAlertAction(title: "1600", style: UIAlertActionStyle.default) { (UIAlertAction) in
                tableView.deselectRow(at: indexPath, animated: false)
            }
            alertController?.addAction(iso800)
            alertController?.addAction(iso1600)
            if let alertVC = alertController {
                self.show(alertVC, sender: self)
            }
        default:
            break
        }
    }
}
