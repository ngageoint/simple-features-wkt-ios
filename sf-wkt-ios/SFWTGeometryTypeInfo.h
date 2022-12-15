//
//  SFWTGeometryTypeInfo.h
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFGeometryTypes.h"

/**
 * Geometry type info
 */
@interface SFWTGeometryTypeInfo : NSObject

/**
 * Initializer
 *
 * @param geometryType
 *            geometry type
 * @param hasZ
 *            has z
 * @param hasM
 *            has m
 */
-(instancetype) initWithType: (enum SFGeometryType) geometryType andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Get the geometry type
 *
 * @return geometry type
 */
-(enum SFGeometryType) geometryType;

/**
 * Has z values
 *
 * @return true if has z values
 */
-(BOOL) hasZ;

/**
 * Has m values
 *
 * @return true if has m values
 */
-(BOOL) hasM;

@end
