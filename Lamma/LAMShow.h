//
//  LAMShow.h
//  Lamma
//
//  Created by AquarHEAD L. on 8/6/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LAMShow : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *audio;
@property (nonatomic, strong) NSDate *date;

+ (instancetype)initFromDictionary:(NSDictionary *)dict;

@end
