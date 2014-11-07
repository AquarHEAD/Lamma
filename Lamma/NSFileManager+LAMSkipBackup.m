//
//  NSFileManager+LAMSkipBackup.m
//  Lamma
//
//  Created by AquarHEAD L. on 08/11/2014.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "NSFileManager+LAMSkipBackup.h"

@implementation NSFileManager (LAMSkipBackup)

- (BOOL)skipBackup:(NSURL *)URL
{
    NSError *error = nil;
    [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    return error == nil;
}

@end
