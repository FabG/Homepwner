//
//  Possession.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/29/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "Possession.h"


@implementation Possession

@dynamic possessionName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic dateCreated;
@dynamic imageKey;
@dynamic thumbnailData;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;


- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    CGRect newRect;
    newRect.origin = CGPointZero;
    newRect.size = [[self class] thumbnailSize];
    float ratio = MAX(newRect.size.width/origImageSize.width,
                      newRect.size.height/origImageSize.height);
    // Create a bitmap image context
    UIGraphicsBeginImageContext(newRect.size);
    // Round the corners
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    [path addClip];
    
    // Into what rectangle shall I composite the image?
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context, retain it as our thumbnail
    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:small];
    
    // Get the image as a PNG data
    NSData *data = UIImagePNGRepresentation(small);
    [self setThumbnailData:data];
    
    // Cleanup image contex resources, we're done
    UIGraphicsEndImageContext();
}

+ (CGSize)thumbnailSize
{
    return CGSizeMake(40, 40);
}

// CoreData / no need to implement init methods for NSManagedObject subclasses
// Implement awakeFromFetch to set the thumbnail from the thumbnailData (which is saved).
// Note: The thumbnail attribute is not going to be saved – it is a transient attribute.
// Need to update thumbnail from the thumbnailData when the object first emerges from
// the filesystem.
- (void)awakeFromFetch
{
    NSLog(@"SQLLite - awakeFromFetch");
    [super awakeFromFetch];
    UIImage *tn = [UIImage imageWithData:[self thumbnailData]];
    [self setPrimitiveValue:tn forKey:@"thumbnail"];
}

// When objects are added to the database, they are sent the message awakeFromInsert.
// Here is where we set the dateCreated instance variable of a Possession.
- (void)awakeFromInsert
{
    NSLog(@"SQLLite - awakeFromInsert");
    [super awakeFromInsert];
    [self setDateCreated:[NSDate date]];
}

@end
