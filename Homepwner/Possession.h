//
//  Possession.h
//  RandomPossessions
//
//  Created by Fabrice Guillaume on 1/25/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Possession : NSObject
{
    NSString *possessionName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
}

// Convenience Class Method to create a random instance for test purpose
+ (id)randomPossession;

// Initializer
// The Possession class has four instance variables, but only three are writeable.
// Therefore, Possession’s designated initializer needs to accept three arguments.
- (id)initWithPossessionName:(NSString *)name
              valueInDollars:(int)value
                serialNumber:(NSString *)sNumber;

// The generated accessor methods for this property will be a getter
// and a setter that retains the incoming object and releases the old object.
@property (nonatomic, retain) NSString *possessionName;
// Ditto to the previous property
@property (nonatomic, retain) NSString *serialNumber;
// The generated accessor methods for this property will be a getter and a setter // that simply assigns the incoming value to the ivar valueInDollars.
@property (nonatomic) int valueInDollars;
// The only generated accessor method for this property will be a getter.
@property (nonatomic, readonly) NSDate *dateCreated;

/* No need for Getters/Steers with use of properties
// Getters and setters
- (void)setPossessionName:(NSString *)str;
- (NSString *)possessionName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)i;
- (int)valueInDollars;

- (NSDate *)dateCreated;
*/

@end
