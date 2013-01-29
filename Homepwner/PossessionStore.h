//
//  PossessionStore.h
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/27/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Possession;

// PossessionStore will be a singleton
// This means there will only be one instance of this type in the application;
// if you try and create another instance, the class will quietly return the
// existing instance instead.
@interface PossessionStore : NSObject
{
    NSMutableArray *allPossessions;
    NSMutableArray *allAssetTypes;      // For SQL Lite
    NSManagedObjectContext *context;    // For SQL Lite
    NSManagedObjectModel *model;        // For SQL Lite
}
// Notice that this is a class method, and is prefixed with a + instead of a -
+ (PossessionStore *)defaultStore;

#pragma mark Possessions
- (NSArray *)allPossessions;
- (Possession *)createPossession;
- (void)removePossession:(Possession *)p;
- (void)movePossessionAtIndex:(int)from
                      toIndex:(int)to;

#pragma mark Asset types
- (NSArray *)allAssetTypes;

// specifies the name of the file on the filesystem that contains the data for all of the Possessions
- (NSString *)possessionArchivePath;


- (BOOL)saveChanges;                    // archiving
- (void)fetchPossessionsIfNecessary;    //unarchiving

@end
