//
//  Possession.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/29/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Possession : NSManagedObject {
    @private
}

@property (nonatomic, retain) NSString *possessionName;
@property (nonatomic, retain) NSString *serialNumber;
@property (nonatomic, retain) NSNumber *valueInDollars;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSString *imageKey;
@property (nonatomic, retain) NSData *thumbnailData;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSNumber *orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailDataFromImage:(UIImage *)image;
+ (CGSize)thumbnailSize;

@end
