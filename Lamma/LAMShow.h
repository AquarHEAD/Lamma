//
//  LAMShow.h
//  Lamma
//
//  Created by AquarHEAD L. on 8/6/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LAMSHOWSTAT_TODOWNLOAD 0
#define LAMSHOWSTAT_DOWNLOADING 1
#define LAMSHOWSTAT_DOWNLOADED 2

@interface LAMShow : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *audio;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *host;
@property (nonatomic) NSUInteger status;

+ (instancetype)initFromDictionary:(NSDictionary *)dict;

@end
