//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Possession;

@interface HomepwnerItemCell : UITableViewCell
{
    UILabel *valueLabel;
    UILabel *nameLabel;
    UIImageView *imageView;
}
- (void)setPossession:(Possession *)possession;

@end
