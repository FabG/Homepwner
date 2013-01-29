//
//  AssetTypePicker.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/29/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Possession;

@interface AssetTypePicker : UITableViewController
{
    Possession *possession;
}
@property (nonatomic, retain) Possession *possession;
@end
