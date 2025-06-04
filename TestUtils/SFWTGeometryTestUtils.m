//
//  SFWTGeometryTestUtils.m
//  sf-wkt-iosTests
//
//  Created by Brian Osborn on 8/7/20.
//  Copyright © 2020 NGA. All rights reserved.
//

@import XCTest;
@import SimpleFeaturesWKT;

#import "SFWTGeometryTestUtils.h"
#import "SFWTTestUtils.h"

@implementation SFWTGeometryTestUtils

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual{
    [self compareEnvelopesWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareEnvelopesWithExpected: (SFGeometryEnvelope *) expected andActual: (SFGeometryEnvelope *) actual andDelta: (double) delta{
    
    if(expected == nil){
        [SFWTTestUtils assertNil:actual];
    }else{
        [SFWTTestUtils assertNotNil:actual];
        
        [SFWTTestUtils assertEqualDoubleWithValue:[expected.minX doubleValue] andValue2:[actual.minX doubleValue] andDelta:delta];
        [SFWTTestUtils assertEqualDoubleWithValue:[expected.maxX doubleValue] andValue2:[actual.maxX doubleValue] andDelta:delta];
        [SFWTTestUtils assertEqualDoubleWithValue:[expected.minY doubleValue] andValue2:[actual.minY doubleValue] andDelta:delta];
        [SFWTTestUtils assertEqualDoubleWithValue:[expected.maxY doubleValue] andValue2:[actual.maxY doubleValue] andDelta:delta];
        [SFWTTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
        if(expected.hasZ){
            [SFWTTestUtils assertEqualDoubleWithValue:[expected.minZ doubleValue] andValue2:[actual.minZ doubleValue] andDelta:delta];
            [SFWTTestUtils assertEqualDoubleWithValue:[expected.maxZ doubleValue] andValue2:[actual.maxZ doubleValue] andDelta:delta];
        }else{
            [SFWTTestUtils assertNil:expected.minZ];
            [SFWTTestUtils assertNil:expected.maxZ];
            [SFWTTestUtils assertNil:actual.minZ];
            [SFWTTestUtils assertNil:actual.maxZ];
        }
        [SFWTTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
        if(expected.hasM){
            [SFWTTestUtils assertEqualDoubleWithValue:[expected.minM doubleValue] andValue2:[actual.minM doubleValue] andDelta:delta];
            [SFWTTestUtils assertEqualDoubleWithValue:[expected.maxM doubleValue] andValue2:[actual.maxM doubleValue] andDelta:delta];
        }else{
            [SFWTTestUtils assertNil:expected.minM];
            [SFWTTestUtils assertNil:expected.maxM];
            [SFWTTestUtils assertNil:actual.minM];
            [SFWTTestUtils assertNil:actual.maxM];
        }
    }
    
}

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    [self compareGeometriesWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareGeometriesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual andDelta: (double) delta{
    if(expected == nil){
        [SFWTTestUtils assertNil:actual];
    }else{
        [SFWTTestUtils assertNotNil:actual];
        
        SFGeometryType geometryType = expected.geometryType;
        switch(geometryType){
            case SF_GEOMETRY:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POINT:
                [self comparePointWithExpected:(SFPoint *)expected andActual:(SFPoint *)actual andDelta:delta];
                break;
            case SF_LINESTRING:
                [self compareLineStringWithExpected:(SFLineString *)expected andActual:(SFLineString *)actual andDelta:delta];
                break;
            case SF_POLYGON:
                [self comparePolygonWithExpected:(SFPolygon *)expected andActual:(SFPolygon *)actual andDelta:delta];
                break;
            case SF_MULTIPOINT:
                [self compareMultiPointWithExpected:(SFMultiPoint *)expected andActual:(SFMultiPoint *)actual andDelta:delta];
                break;
            case SF_MULTILINESTRING:
                [self compareMultiLineStringWithExpected:(SFMultiLineString *)expected andActual:(SFMultiLineString *)actual andDelta:delta];
                break;
            case SF_MULTIPOLYGON:
                [self compareMultiPolygonWithExpected:(SFMultiPolygon *)expected andActual:(SFMultiPolygon *)actual andDelta:delta];
                break;
            case SF_GEOMETRYCOLLECTION:
                [self compareGeometryCollectionWithExpected:(SFGeometryCollection *)expected andActual:(SFGeometryCollection *)actual andDelta:delta];
                break;
            case SF_CIRCULARSTRING:
                [self compareCircularStringWithExpected:(SFCircularString *)expected andActual:(SFCircularString *)actual andDelta:delta];
                break;
            case SF_COMPOUNDCURVE:
                [self compareCompoundCurveWithExpected:(SFCompoundCurve *)expected andActual:(SFCompoundCurve *)actual andDelta:delta];
                break;
            case SF_CURVEPOLYGON:
                [self compareCurvePolygonWithExpected:(SFCurvePolygon *)expected andActual:(SFCurvePolygon *)actual andDelta:delta];
                break;
            case SF_MULTICURVE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_MULTISURFACE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_CURVE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_SURFACE:
                [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
                break;
            case SF_POLYHEDRALSURFACE:
                [self comparePolyhedralSurfaceWithExpected:(SFPolyhedralSurface *)expected andActual:(SFPolyhedralSurface *)actual andDelta:delta];
                break;
            case SF_TIN:
                [self compareTINWithExpected:(SFTIN *)expected andActual:(SFTIN *)actual andDelta:delta];
                break;
            case SF_TRIANGLE:
                [self compareTriangleWithExpected:(SFTriangle *)expected andActual:(SFTriangle *)actual andDelta:delta];
                break;
            default:
                [NSException raise:@"Geometry Type Not Supported" format:@"Geometry Type not supported: %ld", geometryType];
        }
    }
    
    //[SFWTTestUtils assertEqualWithValue:expected andValue2:actual];
}

+(void) compareBaseGeometryAttributesWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    XCTAssertEqual(expected.geometryType, actual.geometryType);
    [SFWTTestUtils assertEqualBoolWithValue:expected.hasZ andValue2:actual.hasZ];
    [SFWTTestUtils assertEqualBoolWithValue:expected.hasM andValue2:actual.hasM];
}

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual{
    [self comparePointWithExpected:expected andActual:actual andDelta:0];
}

+(void) comparePointWithExpected: (SFPoint *) expected andActual: (SFPoint *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualDoubleWithValue:[expected.x doubleValue] andValue2:[actual.x doubleValue] andDelta:delta];
    [SFWTTestUtils assertEqualDoubleWithValue:[expected.y doubleValue] andValue2:[actual.y doubleValue] andDelta:delta];
    [SFWTTestUtils assertEqualDoubleWithValue:[expected.z doubleValue] andValue2:[actual.z doubleValue] andDelta:delta];
    [SFWTTestUtils assertEqualDoubleWithValue:[expected.m doubleValue] andValue2:[actual.m doubleValue] andDelta:delta];
}

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual{
    [self compareLineStringWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareLineStringWithExpected: (SFLineString *) expected andActual: (SFLineString *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i] andDelta:delta];
    }
}

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual{
    [self comparePolygonWithExpected:expected andActual:actual andDelta:0];
}

+(void) comparePolygonWithExpected: (SFPolygon *) expected andActual: (SFPolygon *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual{
    [self compareMultiPointWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareMultiPointWithExpected: (SFMultiPoint *) expected andActual: (SFMultiPoint *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[[expected points] objectAtIndex:i] andActual:[[actual points] objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual{
    [self compareMultiLineStringWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareMultiLineStringWithExpected: (SFMultiLineString *) expected andActual: (SFMultiLineString *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [expected numLineStrings]; i++){
        [self compareLineStringWithExpected:[[expected lineStrings] objectAtIndex:i] andActual:[[actual lineStrings] objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual{
    [self compareMultiPolygonWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareMultiPolygonWithExpected: (SFMultiPolygon *) expected andActual: (SFMultiPolygon *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self comparePolygonWithExpected:[[expected polygons] objectAtIndex:i] andActual:[[actual polygons] objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual{
    [self compareGeometryCollectionWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareGeometryCollectionWithExpected: (SFGeometryCollection *) expected andActual: (SFGeometryCollection *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numGeometries] andValue2:[actual numGeometries]];
    for(int i = 0; i < [expected numGeometries]; i++){
        [self compareGeometriesWithExpected:[expected.geometries objectAtIndex:i] andActual:[actual.geometries objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual{
    [self compareCircularStringWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareCircularStringWithExpected: (SFCircularString *) expected andActual: (SFCircularString *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numPoints] andValue2:[actual numPoints]];
    for(int i = 0; i < [expected numPoints]; i++){
        [self comparePointWithExpected:[expected.points objectAtIndex:i] andActual:[actual.points objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual{
    [self compareCompoundCurveWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareCompoundCurveWithExpected: (SFCompoundCurve *) expected andActual: (SFCompoundCurve *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numLineStrings] andValue2:[actual numLineStrings]];
    for(int i = 0; i < [expected numLineStrings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual{
    [self compareCurvePolygonWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareCurvePolygonWithExpected: (SFCurvePolygon *) expected andActual: (SFCurvePolygon *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareGeometriesWithExpected:[expected.rings objectAtIndex:i] andActual:[actual.rings objectAtIndex:i] andDelta:delta];
    }
}

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual{
    [self comparePolyhedralSurfaceWithExpected:expected andActual:actual andDelta:0];
}

+(void) comparePolyhedralSurfaceWithExpected: (SFPolyhedralSurface *) expected andActual: (SFPolyhedralSurface *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual{
    [self compareTINWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareTINWithExpected: (SFTIN *) expected andActual: (SFTIN *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numPolygons] andValue2:[actual numPolygons]];
    for(int i = 0; i < [expected numPolygons]; i++){
        [self compareGeometriesWithExpected:[expected.polygons objectAtIndex:i] andActual:[actual.polygons objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual{
    [self compareTriangleWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareTriangleWithExpected: (SFTriangle *) expected andActual: (SFTriangle *) actual andDelta: (double) delta{
    [self compareBaseGeometryAttributesWithExpected:expected andActual:actual];
    [SFWTTestUtils assertEqualIntWithValue:[expected numRings] andValue2:[actual numRings]];
    for(int i = 0; i < [expected numRings]; i++){
        [self compareLineStringWithExpected:[expected.lineStrings objectAtIndex:i] andActual:[actual.lineStrings objectAtIndex:i] andDelta:delta];
    }
}

+(void) compareGeometryTextWithExpected: (SFGeometry *) expected andActual: (SFGeometry *) actual{
    
    NSString *expectedText = [self writeTextWithGeometry:expected];
    NSString *actualText = [self writeTextWithGeometry:actual];
    
    [self compareTextWithExpected:expectedText andActual:actualText];
}

+(void) compareDataGeometriesWithExpected: (NSString *) expected andActual: (NSString *) actual{
    
    SFGeometry *expectedGeometry = [self readGeometryWithText:expected];
    SFGeometry *actualGeometry = [self readGeometryWithText:actual];
    
    [self compareGeometriesWithExpected:expectedGeometry andActual:actualGeometry];
}

+(NSString *) writeTextWithGeometry: (SFGeometry *) geometry{
    return [SFWTGeometryWriter writeGeometry:geometry];
}

+(SFGeometry *) readGeometryWithText: (NSString *) text{
    return [self readGeometryWithText:text andValidateZM:YES];
}

+(SFGeometry *) readGeometryWithText: (NSString *) text andValidateZM: (BOOL) validateZM{
    
    SFGeometry *geometry = [SFWTGeometryReader readGeometryWithText:text];
    
    SFTextReader *reader = [[SFTextReader alloc] initWithText:text];
    SFWTGeometryTypeInfo *geometryTypeInfo = [SFWTGeometryReader readGeometryTypeWithReader:reader];
    SFGeometryType expectedGeometryType = [geometryTypeInfo geometryType];
    switch (expectedGeometryType) {
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            expectedGeometryType = SF_GEOMETRYCOLLECTION;
            break;
        default:
            break;
    }
    XCTAssertEqual(expectedGeometryType, geometry.geometryType);
    if(validateZM){
        [SFWTTestUtils assertEqualBoolWithValue:[geometryTypeInfo hasZ] andValue2:geometry.hasZ];
        [SFWTTestUtils assertEqualBoolWithValue:[geometryTypeInfo hasM] andValue2:geometry.hasM];
    }
    
    return geometry;
}

+(void) compareTextWithExpected: (NSString *) expected andActual: (NSString *) actual{
    [self compareTextWithExpected:expected andActual:actual andDelta:0];
}

+(void) compareTextWithExpected: (NSString *) expected andActual: (NSString *) actual andDelta: (double) delta{
    
    SFTextReader *reader1 = [[SFTextReader alloc] initWithText:expected];
    SFTextReader *reader2 = [[SFTextReader alloc] initWithText:actual];
    
    while([reader1 peekToken] != nil){
        NSString *token1 = [reader1 readToken];
        NSString *token2 = [reader2 readToken];
        if([token1 caseInsensitiveCompare:token2] != NSOrderedSame){
            double token1Double = [token1 doubleValue];
            double token2Double = [token2 doubleValue];
            [SFWTTestUtils assertEqualDoubleWithValue:token1Double andValue2:token2Double andDelta:delta];
        }
    }
    
    [SFWTTestUtils assertNil:[reader1 readToken]];
    [SFWTTestUtils assertNil:[reader2 readToken]];
    
}

+(SFPoint *) createPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [SFWTTestUtils randomDoubleLessThan:180.0] * ([SFWTTestUtils randomDouble] < .5 ? 1 : -1);
    double y = [SFWTTestUtils randomDoubleLessThan:90.0] * ([SFWTTestUtils randomDouble] < .5 ? 1 : -1);
    
    NSDecimalNumber *xNumber = [SFWTTestUtils roundDouble:x];
    NSDecimalNumber *yNumber = [SFWTTestUtils roundDouble:y];
    
    SFPoint *point = [SFPoint pointWithHasZ:hasZ andHasM:hasM andX:xNumber andY:yNumber];
    
    if(hasZ){
        double z = [SFWTTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber *zNumber = [SFWTTestUtils roundDouble:z];
        [point setZ:zNumber];
    }
    
    if(hasM){
        double m = [SFWTTestUtils randomDoubleLessThan:1000.0];
        NSDecimalNumber *mNumber = [SFWTTestUtils roundDouble:m];
        [point setM:mNumber];
    }
    
    return point;
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createLineStringWithHasZ:hasZ andHasM:hasM andRing:false];
}

+(SFLineString *) createLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    SFLineString *lineString = [SFLineString lineStringWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWTTestUtils randomIntLessThan:9];
    
    for(int i = 0; i < num; i++){
        [lineString addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    if(ring){
        [lineString addPoint:[lineString.points objectAtIndex:0]];
    }
    
    return lineString;
}

+(SFCircularString *) createCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createCircularStringWithHasZ:hasZ andHasM:hasM andClosed:false];
}

+(SFCircularString *) createCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andClosed: (BOOL) closed{
    
    SFCircularString *circularString = [SFCircularString circularStringWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWTTestUtils randomIntLessThan:9];
    
    for(int i = 0; i < num; i++){
        [circularString addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    if(closed){
        [circularString addPoint:[circularString.points objectAtIndex:0]];
    }
    
    return circularString;
}

+(SFPolygon *) createPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolygon *polygon = [SFPolygon polygonWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [polygon addRing:[self createLineStringWithHasZ:hasZ andHasM:hasM andRing:true]];
    }
    
    return polygon;
}

+(SFMultiPoint *) createMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint *multiPoint = [SFMultiPoint multiPointWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPoint addPoint:[self createPointWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPoint;
}

+(SFMultiLineString *) createMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = [SFMultiLineString multiLineStringWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiLineString addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiLineString;
}

+(SFMultiLineString *) createMultiLineStringOfCircularStringsWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = [SFMultiLineString multiLineStringWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiLineString addLineString:[self createCircularStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiLineString;
}

+(SFMultiPolygon *) createMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon *multiPolygon = [SFMultiPolygon multiPolygonWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        [multiPolygon addPolygon:[self createPolygonWithHasZ:hasZ andHasM:hasM]];
    }
    
    return multiPolygon;
}

+(SFGeometryCollection *) createGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *geometryCollection = [SFGeometryCollection geometryCollectionWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for(int i = 0; i < num; i++){
        
        SFGeometry *geometry = nil;
        int randomGeometry =[SFWTTestUtils randomIntLessThan:6];
        
        switch(randomGeometry){
            case 0:
                geometry = [self createPointWithHasZ:hasZ andHasM:hasM];
                break;
            case 1:
                geometry = [self createLineStringWithHasZ:hasZ andHasM:hasM];
                break;
            case 2:
                geometry = [self createPolygonWithHasZ:hasZ andHasM:hasM];
                break;
            case 3:
                geometry = [self createMultiPointWithHasZ:hasZ andHasM:hasM];
                break;
            case 4:
                geometry = [self createMultiLineStringWithHasZ:hasZ andHasM:hasM];
                break;
            case 5:
                geometry = [self createMultiPolygonWithHasZ:hasZ andHasM:hasM];
                break;
        }
        
        [geometryCollection addGeometry:geometry];
    }
    
    return geometryCollection;
}

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self createCompoundCurveWithHasZ:hasZ andHasM:hasM andRing:NO];
}

+(SFCompoundCurve *) createCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM andRing: (BOOL) ring{
    
    SFCompoundCurve *compoundCurve = [SFCompoundCurve compoundCurveWithHasZ:hasZ andHasM:hasM];
    
    int num = 2 + [SFWTTestUtils randomIntLessThan:9];
    
    for (int i = 0; i < num; i++) {
        [compoundCurve addLineString:[self createLineStringWithHasZ:hasZ andHasM:hasM]];
    }
    
    if (ring) {
        [[compoundCurve lineStringAtIndex:num-1] addPoint:[[compoundCurve lineStringAtIndex:0] startPoint]];
    }
    
    return compoundCurve;
}

+(SFCurvePolygon *) createCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = [SFCurvePolygon curvePolygonWithHasZ:hasZ andHasM:hasM];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        [curvePolygon addRing:[self createCompoundCurveWithHasZ:hasZ andHasM:hasM andRing:YES]];
    }
    
    return curvePolygon;
}

+(SFGeometryCollection *) createMultiCurve{
    
    SFGeometryCollection *multiCurve = [SFGeometryCollection geometryCollection];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        if (i % 2 == 0) {
            [multiCurve addGeometry:[self createCompoundCurveWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]]];
        } else {
            [multiCurve addGeometry:[self createLineStringWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]]];
        }
    }
    
    return multiCurve;
}

+(SFGeometryCollection *) createMultiSurface{
    
    SFGeometryCollection *multiSurface = [SFGeometryCollection geometryCollection];
    
    int num = 1 + [SFWTTestUtils randomIntLessThan:5];
    
    for (int i = 0; i < num; i++) {
        if (i % 2 == 0) {
            [multiSurface addGeometry:[self createCurvePolygonWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]]];
        } else {
            [multiSurface addGeometry:[self createPolygonWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]]];
        }
    }
    
    return multiSurface;
}

@end
