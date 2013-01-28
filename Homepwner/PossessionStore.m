//
//  PossessionStore.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/27/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "PossessionStore.h"
#import "Possession.h"

// When defaultStore message is sent to the PossessionStore class, the class
// will check to see if the instance of PossessionStore has already been
// created. If the store exists, the class will return the instance. If
// not, it will create the instance and return it. To do this, you’ll use a
// global static variable.
static PossessionStore *defaultStore = nil;

@implementation PossessionStore
// Implement +defaultStore, +allocWithZone: and -init so that only one instance
// of the class can be created.

+ (PossessionStore *)defaultStore
{
    if (!defaultStore) {
        // Create the singleton
        defaultStore = [[super allocWithZone:NULL] init];
    }
    return defaultStore;
}

// Prevent creation of additional instances
+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultStore];
}

- (id)init {
    // If we already have an instance of PossessionStore...
    if (defaultStore) {
        // Return the old one
        return defaultStore;
    }
    self = [super init];
    
    // Create an instance of NSMutableArray and assign it to the instance
    // variable
    if (self) {
        allPossessions = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allPossessions
{
    return allPossessions;
}

- (Possession *)createPossession
{
    Possession *p = [Possession randomPossession];
    [allPossessions addObject:p];
    return p;
}

- (void)removePossession:(Possession *)p
{
    [allPossessions removeObjectIdenticalTo:p];
}

- (void)movePossessionAtIndex:(int)from
                      toIndex:(int)to
{
    if (from == to) {
        return; }
    // Get pointer to object being moved
    Possession *p = [allPossessions objectAtIndex:from];
    // Retain it... (retain count of p = 2)

    [allPossessions removeObjectAtIndex:from];
    
    // Insert p in array at new location, retained by array (retain count of p = 2)
    [allPossessions insertObject:p atIndex:to];

}


@end
