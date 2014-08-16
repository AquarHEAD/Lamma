//
//  LAMShow.m
//  Lamma
//
//  Created by AquarHEAD L. on 8/6/14.
//  Copyright (c) 2014 ElaWorkshop. All rights reserved.
//

#import "LAMShow.h"

@implementation LAMShow

+ (instancetype)initFromDictionary:(NSDictionary *)dict
{
    LAMShow *show = [LAMShow new];
    show.key = dict[@"id"];
    show.type = dict[@"type"];
    show.title = dict[@"title"];
    show.subtitle = dict[@"subtitle"];
    show.detail = dict[@"detail"];
    show.audio = dict[@"audio"];
    show.date = dict[@"date"];
    show.host = dict[@"host"];
    show.status = LAMSHOWSTAT_TODOWNLOAD;
    return show;
}

@end
