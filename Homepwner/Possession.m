//
//  Possession.m
//  RandomPossessions
//
//  Created by Fabrice Guillaume on 1/25/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "Possession.h"

@implementation Possession

@synthesize possessionName, serialNumber, valueInDollars, dateCreated;
@synthesize imageKey;

/* Using properties so commenting out getter/setter
// possessionName Setter / Getter
- (void)setPossessionName:(NSString *)str;
{
    possessionName = str;
}

- (NSString *) possessionName
{
    return possessionName;
}

// SerialNumber Setter / Getter
- (void) setSerialNumber:(NSString *)str
{
    serialNumber = str;
}

- (NSString *) serialNumber
{
    return serialNumber;
}

// ValueInDollars Setter / Getter
- (void) setValueInDollars:(int)i
{
    valueInDollars = i;
}

- (int) valueInDollars
{
    return valueInDollars;
}

// Getter for DateCreated
- (NSDate *) dateCreated
{
    return dateCreated;
}
 */

// Override the description method.
- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     possessionName,
     serialNumber,
     valueInDollars,
     dateCreated];
    return descriptionString;
}

// Initializer
- (id)initWithPossessionName:(NSString *)name
              valueInDollars:(int)value
                serialNumber:(NSString *)sNumber
{
    // Call the superclass's designated initializer
    self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        NSLog(@"Possession created");
        // Give the instance variables initial values
        [self setPossessionName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    
    // Return the address of the newly initialized object
    return self;
}

/*
// Override the local init method
- (id)init
{
    return [self initWithPossessionName:@"Possession"
                         valueInDollars:0
                            serialNumer:@""];
}
*/
// Convenience Class Method to create a random instance for test purpose
+ (id)randomPossession
{
    // Create an array of three adjectives
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Mint",
                                    @"Shiny",
                                    @"Rusty", nil];
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bike",
                               @"Computer",
                               @"TV stand", nil];
    
    // Get the index of a random adjective/noun from the lists
    // Note: The % operator, called the modulo operator, gives
    // you the remainder. So adjectiveIndex is a random number
    // from 0 to 2 inclusive.
    int adjectiveIndex = rand() % [randomAdjectiveList count];
    int nounIndex = rand() % [randomNounList count];
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];
    int randomValue = rand() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    
    // Once again, ignore the memory problems with this method
    Possession *newPossession =
    [[self alloc] initWithPossessionName:randomName
                          valueInDollars:randomValue
                            serialNumber:randomSerialNumber];
    return newPossession;
}

// Class method that returns the size of a thumbnail
+ (CGSize)thumbnailSize
{
    return CGSizeMake(40, 40);
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    // For each instance variable, archive it under its variable name
    // These objects will also be sent encodeWithCoder:
    [encoder encodeObject:possessionName forKey:@"possessionName"];
    [encoder encodeObject:serialNumber forKey:@"serialNumber"];
    
    [encoder encodeObject:dateCreated forKey:@"dateCreated"];
    [encoder encodeObject:imageKey forKey:@"imageKey"];
    
    // For the primitive valueInDollars, make sure to use encodeInt:forKey:
    // the value in valueInDollars will be placed in the coder object
    [encoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    
    [encoder encodeObject:thumbnailData forKey:@"thumbnailData"];
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        // For each instance variable that is archived, we decode it,
        // and pass it to our setters. (Where it is retained)
        [self setPossessionName:[decoder decodeObjectForKey:@"possessionName"]];
        [self setSerialNumber:[decoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[decoder decodeObjectForKey:@"imageKey"]];
        // Make sure to use decodeIntForKey:, since valueInDollars is not an object
        [self setValueInDollars:[decoder decodeIntForKey:@"valueInDollars"]];
        // dateCreated is read only, we have no setter. We explicitly
        // retain it and set our instance variable pointer to it
        dateCreated = [[decoder decodeObjectForKey:@"dateCreated"] retain];
        
        thumbnailData = [[decoder decodeObjectForKey:@"thumbnailData"] retain];
    }
    return self;
}

// Getter method for thumbnail that will create it from the data if necessary
- (UIImage *)thumbnail
{
    // Am I imageless?
    if (!thumbnailData) {
        return nil; }
    // Is there no cached thumbnail image?
    if (!thumbnail) {
        // Create the image from the data
        thumbnail = [[UIImage imageWithData:thumbnailData] retain];
    }
    return thumbnail;
}

- (void)dealloc
{
    [thumbnail release];
    [thumbnailData release];
    [possessionName release];
    [serialNumber release];
    [dateCreated release];
    [imageKey release];
    [super dealloc];
}

// Following methods create a thumbnail using an offscreen context.
// Private setter
- (void)setThumbnail:(UIImage *)image
{
    [image retain];
    [thumbnail release];
    thumbnail = image;
}

// Private setter
- (void)setThumbnailData:(NSData *)d
{
    [d retain];
    [thumbnailData release];
    thumbnailData = d;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    CGRect newRect;
    newRect.origin = CGPointZero;
    newRect.size = [[self class] thumbnailSize];
    
    // How do we scale the image?
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

@end