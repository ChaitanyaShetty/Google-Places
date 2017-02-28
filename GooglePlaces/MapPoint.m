//
//  MapPoint.m
//  GooglePlaces
//
//  Created by test on 2/27/17.
//  Copyright © 2017 com.meheboob. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;

-(id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
    }
    return self;
}

-(NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
        else
        return _name;
}

-(NSString *)subtitle {
    return _address;
}
@end
