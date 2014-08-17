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
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    show.localFile = [documentsDirectoryURL URLByAppendingPathComponent:[[NSURL URLWithString:show.audio] lastPathComponent]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[show.localFile absoluteString]]) {
        show.status = LAMSHOWSTAT_DOWNLOADED;
    }
    else {
        show.status = LAMSHOWSTAT_TODOWNLOAD;
    }
    return show;
}

@end
