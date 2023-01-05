//
//  SFWTGeometryTestUtils.h
//  sf-wkt-iosTests
//
//  Created by Brian Osborn on 8/7/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFMultiPoint.h"
#import "SFCircularString.h"
#import "SFCompoundCurve.h"
#import "SFTIN.h"
#import "SFTriangle.h"

@interface SFWTGeometryTestUtils : NSObject

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual;

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual andDelta: (double) delta;

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual;

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andDelta: (double) delta;

+(void) compareBaseGeometryAttributesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual;

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual;

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual andDelta: (double) delta;

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual;

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual andDelta: (double) delta;

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual;

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual andDelta: (double) delta;

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual;

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual andDelta: (double) delta;

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual;

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual andDelta: (double) delta;

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual;

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual andDelta: (double) delta;

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual;

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual andDelta: (double) delta;

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual;

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual andDelta: (double) delta;

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual;

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual andDelta: (double) delta;

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual;

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual andDelta: (double) delta;

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual;

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual andDelta: (double) delta;

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual;

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual andDelta: (double) delta;

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual;

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual andDelta: (double) delta;

+(void) compareGeometryTextWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual;

+(void) compareDataGeometriesWithExpected: (NSString *) expected andActual: (NSString *) actual;

+(NSString *) writeTextWithGeometry: (SFGeometry *) geometry;

+(SFGeometry *) readGeometryWithText: (NSString *) text;

+(SFGeometry *) readGeometryWithText: (NSString *) text andValidateZM: (BOOL) validateZM;

+(void) compareTextWithExpected: (NSString *) expected andActual: (NSString *) actual;

+(void) compareTextWithExpected: (NSString *) expected andActual: (NSString *) actual andDelta: (double) delta;

+(SFPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring;

+(SFCircularString *) createCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFCircularString *) createCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andClosed: (BOOL) closed;

+(SFPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiLineString *) createMultiLineStringOfCircularStringsWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring;

+(SFCurvePolygon *) createCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM;

+(SFGeometryCollection *) createMultiCurve;

+(SFGeometryCollection *) createMultiSurface;

@end
