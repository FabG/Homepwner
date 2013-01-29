//
//  ImageStore.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "ImageStore.h"

// Make ImageStore a singleton
static ImageStore *defaultImageStore = nil;

@implementation ImageStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultImageStore];
}

+ (ImageStore *)defaultImageStore
{
    if (!defaultImageStore) {
        // Create the singleton
        defaultImageStore = [[super allocWithZone:NULL] init];
    }
    return defaultImageStore;
}

- (id)init {
    if (defaultImageStore) {
        return defaultImageStore;
    }
    
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
    
        // Register the image store as an observer of the notification:
        // UIApplicationDidReceiveMemoryWarningNotification
        // Now, a low-memory warning will send the message clearCache: to the
        // ImageStore instance.
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    
    return self;
}

- (void)setImage:(UIImage *)i forKey:(NSString *)s
{
    [dictionary setObject:i forKey:s];
    
    // Copy the JPEG representation of an image into a buffer in memory
    // Create full path for image
    NSString *imagePath = pathInDocumentDirectory(s);
    
    // Turn image into JPEG data,
    // The function UIImageJPEGRepresentation takes two parameters:
    // a UIImage and a compression quality.
    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    // Write it to full path
    // This NSData instance can be written to the filesystem by sending it the
    // message writeToFile:atomically:. The bytes held in this NSData are then
    // written to the path specified by the first parameter. The second parameter,
    // atomically, is a boolean value. If it is YES, the file is written to a
    // temporary place on the filesystem, and, once the writing operation is
    // complete, that file is renamed to the path of the first parameter, replacing
    // any previously existing file. This prevents data corruption should your
    // application crash during the write procedure.
    [d writeToFile:imagePath atomically:YES];
    
    //NSLOG(@"FileManager: write to file image (path: %@", imagePath);
}

- (UIImage *)imageForKey:(NSString *)s
{
    // If possible, get it from the dictionary
    UIImage *result = [dictionary objectForKey:s];
    
    if (!result) {
        // Create UIImage object from file
        //NSLOG(@"FileManager: load image (path: %c", pathInDocumentDirectory(s));

        result = [UIImage imageWithContentsOfFile:pathInDocumentDirectory(s)];
        // If we found an image on the file system, place it into the cache
        if (result)
            [dictionary setObject:result forKey:s];
        else
            NSLog(@"Error: unable to find %@", pathInDocumentDirectory(s));
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s
{
    if(!s)
        return;
    [dictionary removeObjectForKey:s];
    
    //  make sure that when an image is deleted from the store, it is also deleted
    // from the filesystem
    NSString *path = pathInDocumentDirectory(s);
    //NSLOG(@"FileManager: removing image (path: %c", path);
    [[NSFileManager defaultManager] removeItemAtPath:path
                                               error:NULL];
    
}
    
// When a low-memory warning is sent (clearCache)
// implement clearCache: to remove all the UIImage objects from the ImageStore’ s
// dictionary
- (void)clearCache:(NSNotification *)note
{
    NSLog(@"flushing %d images out of the cache", [dictionary count]);
    [dictionary removeAllObjects];
}

@end
