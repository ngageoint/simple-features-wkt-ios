//
//  SFWTGeometryTypeInfo.m
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTGeometryTypeInfo.h"

@interface SFWTGeometryTypeInfo()

/**
 * Geometry type
 */
@property (nonatomic) enum SFGeometryType geometryType;

/**
 * Has Z values flag
 */
@property (nonatomic) BOOL hasZ;

/**
 * Has M values flag
 */
@property (nonatomic) BOOL hasM;

@end

@implementation SFWTGeometryTypeInfo

-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    self = [super init];
    if(self != nil){
        self.geometryType = geometryType;
        self.hasZ = hasZ;
        self.hasM = hasM;
    }
    return self;
}

-(enum SFGeometryType) geometryType{
    return _geometryType;
}

-(BOOL) hasZ{
    return _hasZ;
}

-(BOOL) hasM{
    return _hasM;
}

@end
