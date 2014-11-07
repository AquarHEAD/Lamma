//
//  NSFileManager+LAMSkipBackup.h
//  Lamma
//
//  Created by AquarHEAD L. on 08/11/2014.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (LAMSkipBackup)

- (BOOL)skipBackup:(NSURL *)URL;

@end
