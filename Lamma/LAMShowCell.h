//
//  LAMShowCell.h
//  Lamma
//
//  Created by AquarHEAD L. on 8/17/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LAMShowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UIButton *manageButton;

@end