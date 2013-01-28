//
//  ImageStore.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Simple key-value store to store pictures taken with the camera
@interface ImageStore : NSObject
{
    NSMutableDictionary *dictionary;
}

+ (ImageStore *)defaultImageStore;

- (void)setImage:(UIImage *)i forKey:(NSString *)s;
- (UIImage *)imageForKey:(NSString *)s;
- (void)deleteImageForKey:(NSString *)s;

@end
