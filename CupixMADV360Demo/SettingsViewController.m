//
//  SettingsViewController.m
//  CupixMADV360Demo
//
//  Created by DOM QIU on 2018/10/15.
//  Copyright © 2018 QiuDong. All rights reserved.
//

#import "SettingsViewController.h"

typedef enum {
    CellID_FirmwareVer = 0,
    CellID_Space = 1,
    CellID_BeepingVolume = 2,
    CellID_PhotoResolution = 3,
    CellID_WhiteBalance = 4,
    CellID_ISO = 5,
} CellID;

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row)
    {
        case CellID_ISO:
            cell.detailTextLabel.text = @"ISO Value";
            break;
            
        default:
            break;
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row)
    {
        case CellID_ISO:
        {
            UIAlertController* sheetVC = [UIAlertController alertControllerWithTitle:@"ISO Setting" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* iso800 = [UIAlertAction actionWithTitle:@"800" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }];
            UIAlertAction* iso1600 = [UIAlertAction actionWithTitle:@"1600" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [sheetVC addAction:iso800];
            [sheetVC addAction:iso1600];
            [self showViewController:sheetVC sender:self];
        }
            break;
            
        default:
            break;
    }
}

@end
