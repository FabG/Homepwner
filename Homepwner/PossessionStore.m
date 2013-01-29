//
//  PossessionStore.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/27/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "PossessionStore.h"
#import "Possession.h"
#import "ImageStore.h"

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
    // This ensures allPossessions is created
    [self fetchPossessionsIfNecessary];
    
    return allPossessions;
}

- (Possession *)createPossession
{
    // This ensures allPossessions is created
    [self fetchPossessionsIfNecessary];
    
    Possession *p = [Possession randomPossession];
    [allPossessions addObject:p];
    return p;
}

- (void)removePossession:(Possession *)p
{
    // When a Possession is removed from the store, its image should also be
    // removed from the filesystem.
    NSString *key = [p imageKey];
    [[ImageStore defaultImageStore] deleteImageForKey:key];
    
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

- (NSString *)possessionArchivePath
{
    // The returned path will be Sandbox/Documents/possessions.data
    // Both the saving and loading methods will call this method to get the same path,
    // preventing a typo in the path name of either method
    return pathInDocumentDirectory(@"possessions.data");
}


// The archiveRootObject:toFile: method creates an instance of NSKeyedArchiver and
// then sends encodeWithCoder: to allPossessions. The NSKeyedArchiver is passed as
// the argument. When an array is archived, all of its contents are archived along
// with it (as long as those contents conform to NSCoding), so passing an array full
// of Possession instances to archiveRootObject:toFile: kicks off a chain reaction of
// encoding.
- (BOOL)saveChanges
{
    // returns success or failure
    return [NSKeyedArchiver archiveRootObject:allPossessions
                                       toFile:[self possessionArchivePath]];
}

- (void)fetchPossessionsIfNecessary
{
    // If we don't currently have an allPossessions array, try to read one from disk
    if (!allPossessions) {
        NSString *path = [self possessionArchivePath];
        allPossessions = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    // If we tried to read one from disk but does not exist, then create a new one
    if (!allPossessions) {
        allPossessions = [[NSMutableArray alloc] init];
    }
}

@end
