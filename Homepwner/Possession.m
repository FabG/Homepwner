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
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                    @"Rusty",
                                    @"Shiny", nil];
    // Create an array of three nouns
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                               @"Spork",
                               @"Mac", nil];
    
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

@end