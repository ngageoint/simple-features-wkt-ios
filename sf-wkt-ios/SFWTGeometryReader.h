//
//  SFWTGeometryReader.h
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFTextReader.h"
#import "SFGeometry.h"
#import "SFPoint.h"
#import "SFLineString.h"
#import "SFPolygon.h"
#import "SFMultiPoint.h"
#import "SFMultiLineString.h"
#import "SFMultiPolygon.h"
#import "SFGeometryCollection.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFCurvePolygon.h"
#import "SFPolyhedralSurface.h"
#import "SFTIN.h"
#import "SFTriangle.h"
#import "SFWTGeometryTypeInfo.h"
#import "SFGeometryFilter.h"

/**
 * Well Known Text reader
 */
@interface SFWTGeometryReader : NSObject

/**
 *  Read a geometry from well-known text
 *
 *  @param text well-known text
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithText: (NSString *) text;

/**
 *  Read a geometry from well-known text
 *
 *  @param text well-known text
 *  @param filter geometry filter
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithText: (NSString *) text andFilter: (NSObject<SFGeometryFilter> *) filter;

/**
 *  Read a geometry from well-known text
 *
 *  @param text well-known text
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithText: (NSString *) text andExpectedType: (Class) expectedType;

/**
 *  Read a geometry from well-known text
 *
 *  @param text well-known text
 *  @param filter geometry filter
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithText: (NSString *) text andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType;

/**
 * Initializer
 *
 * @param text well-known text
 */
-(instancetype) initWithText: (NSString *) text;

/**
 * Initializer
 *
 * @param reader text reader
 */
-(instancetype) initWithReader: (SFTextReader *) reader;

/**
 * Get the text reader
 *
 * @return text reader
 */
-(SFTextReader *) textReader;

/**
 *  Read a geometry
 *
 *  @param reader text reader
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader;

/**
 *  Read a geometry
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter;

/**
 *  Read a geometry
 *
 *  @param reader text reader
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andExpectedType: (Class) expectedType;

/**
 *  Read a geometry
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType;

/**
 *  Read a geometry
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param containingType containing geometry type
 *  @param expectedType expected geometry class type
 *
 *  @return geometry
 */
+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter inType: (enum SFGeometryType) containingType andExpectedType: (Class) expectedType;

/**
 * Read the geometry type info
 *
 * @param reader text reader
 * @return geometry type info
 */
+(SFWTGeometryTypeInfo *) readGeometryTypeWithReader: (SFTextReader *) reader;

/**
 *  Read a point
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return point
 */
+(SFPoint *) readPointTextWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a point
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return point
 */
+(SFPoint *) readPointWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
+(SFLineString *) readLineStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a line string
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return line string
 */
+(SFLineString *) readLineStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
+(SFPolygon *) readPolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polygon
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polygon
 */
+(SFPolygon *) readPolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
+(SFMultiPoint *) readMultiPointWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi point
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi point
 */
+(SFMultiPoint *) readMultiPointWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
+(SFMultiLineString *) readMultiLineStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi line string
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi line string
 */
+(SFMultiLineString *) readMultiLineStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
+(SFMultiPolygon *) readMultiPolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a multi polygon
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return multi polygon
 */
+(SFMultiPolygon *) readMultiPolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a geometry collection
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return geometry collection
 */
+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Read a multi curve
 *
 * @param reader text reader
 * @param filter geometry filter
 * @param hasZ has z flag
 * @param hasM has m flag
 *
 * @return multi curve
 */
 +(SFGeometryCollection *) readMultiCurveWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 * Read a multi surface
 *
 * @param reader text reader
 * @param filter geometry filter
 * @param hasZ has z flag
 * @param hasM has m flag
 *
 * @return multi surface
*/
+(SFGeometryCollection *) readMultiSurfaceWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
+(SFCircularString *) readCircularStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a circular string
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return circular string
 */
+(SFCircularString *) readCircularStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
+(SFCompoundCurve *) readCompoundCurveWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a compound curve
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return compound curve
 */
+(SFCompoundCurve *) readCompoundCurveWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
+(SFCurvePolygon *) readCurvePolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a curve polygon
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return curve polygon
 */
+(SFCurvePolygon *) readCurvePolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a polyhedral surface
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return polyhedral surface
 */
+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
+(SFTIN *) readTINWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a TIN
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return TIN
 */
+(SFTIN *) readTINWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param reader text reader
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
+(SFTriangle *) readTriangleWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

/**
 *  Read a triangle
 *
 *  @param reader text reader
 *  @param filter geometry filter
 *  @param hasZ   has z values
 *  @param hasM   has m values
 *
 *  @return triangle
 */
+(SFTriangle *) readTriangleWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

@end
