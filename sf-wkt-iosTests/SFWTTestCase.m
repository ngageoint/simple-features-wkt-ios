//
//  SFWTTestCase.m
//  sf-wkt-iosTests
//
//  Created by Brian Osborn on 8/7/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SFWTTestUtils.h"
#import "SFWTGeometryTestUtils.h"
#import "SFGeometryEnvelopeBuilder.h"
#import "SFExtendedGeometryCollection.h"
#import "SFByteReader.h"
#import "SFPointFiniteFilter.h"
#import "SFWTGeometryReader.h"

@interface SFWTTestCase : XCTestCase

@end

@implementation SFWTTestCase

static NSUInteger GEOMETRIES_PER_TEST = 10;

-(void) setUp {
    [super setUp];
}

-(void) tearDown {
    [super tearDown];
}

-(void) testPoint {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a point
        SFPoint * point = [SFWTGeometryTestUtils createPointWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: point];
    }
}

-(void) testLineString {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a line string
        SFLineString * lineString = [SFWTGeometryTestUtils createLineStringWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: lineString];
    }
}

-(void) testPolygon {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a polygon
        SFPolygon * polygon = [SFWTGeometryTestUtils createPolygonWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: polygon];
    }
}

-(void) testMultiPoint {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi point
        SFMultiPoint * multiPoint = [SFWTGeometryTestUtils createMultiPointWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: multiPoint];
    }
}

-(void) testMultiLineString {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi line string
        SFMultiLineString * multiLineString = [SFWTGeometryTestUtils createMultiLineStringWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: multiLineString];
    }
}

-(void) testMultiCurveWithLineStrings{

    // Test a pre-created WKB saved as the abstract MultiCurve type with
    // LineStrings
    
    NSString *text = @"MULTICURVE ( LINESTRING ( 18.889800697319032 -35.036463112927535, -37.76441919748682 -75.81115933696286, 68.9116399151478 -88.32707858422387 ), LINESTRING ( 145.52101409832818 -41.91160298025902, -173.4468670533211 11.756492650408305, -77.99433389977924 -39.554308892198534, 136.58380908612207 41.90364270668213, 39.97441553368359 -17.43335525530797, -121.31829755251131 -65.16951612235937, 49.88151008675286 7.029670331650452, 112.99918207874451 -35.62758965128506, -175.71124906933335 -36.04238233215776, -76.52909336488278 44.2390383216843 ) )";
    
    [SFWTTestUtils assertTrue:[text hasPrefix:[SFGeometryTypes name:SF_MULTICURVE]]];
    
    SFGeometry *geometry = [SFWTGeometryTestUtils readGeometryWithText:text];
    [SFWTTestUtils assertTrue:[geometry isKindOfClass:[SFGeometryCollection class]]];
    [SFWTTestUtils assertEqualIntWithValue:geometry.geometryType andValue2:SF_GEOMETRYCOLLECTION];
    SFGeometryCollection *multiCurve = (SFGeometryCollection *) geometry;
    [SFWTTestUtils assertEqualIntWithValue:2 andValue2:[multiCurve numGeometries]];
    SFGeometry *geometry1 = [multiCurve geometryAtIndex:0];
    SFGeometry *geometry2 = [multiCurve geometryAtIndex:1];
    [SFWTTestUtils assertTrue:[geometry1 isKindOfClass:[SFLineString class]]];
    [SFWTTestUtils assertTrue:[geometry2 isKindOfClass:[SFLineString class]]];
    SFLineString *lineString1 = (SFLineString *) geometry1;
    SFLineString *lineString2 = (SFLineString *) geometry2;
    [SFWTTestUtils assertEqualIntWithValue:3 andValue2:[lineString1 numPoints]];
    [SFWTTestUtils assertEqualIntWithValue:10 andValue2:[lineString2 numPoints]];
    SFPoint *point1 = [lineString1 startPoint];
    SFPoint *point2 = [lineString2 endPoint];
    [SFWTTestUtils assertEqualDoubleWithValue:18.889800697319032 andValue2:[point1.x doubleValue] andDelta:0.0000000000001];
    [SFWTTestUtils assertEqualDoubleWithValue:-35.036463112927535 andValue2:[point1.y doubleValue] andDelta:0.0000000000001];
    [SFWTTestUtils assertEqualDoubleWithValue:-76.52909336488278 andValue2:[point2.x doubleValue] andDelta:0.0000000000001];
    [SFWTTestUtils assertEqualDoubleWithValue:44.2390383216843 andValue2:[point2.y doubleValue] andDelta:0.0000000000001];
    
    SFExtendedGeometryCollection *extendedMultiCurve = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiCurve];
    [SFWTTestUtils assertEqualIntWithValue:SF_MULTICURVE andValue2:extendedMultiCurve.geometryType];
    
    [self geometryTester:extendedMultiCurve withCompare:multiCurve andDelta:0.000000000001];
    
    NSString *text2 = [SFWTGeometryTestUtils writeTextWithGeometry:extendedMultiCurve];
    [SFWTTestUtils assertTrue:[text2 hasPrefix:[SFGeometryTypes name:SF_MULTICURVE]]];
    [SFWTGeometryTestUtils compareTextWithExpected:text andActual:text2 andDelta:0.000000000001];
    
}

-(void) testMultiCurveWithCompoundCurve{

    // Test a pre-created WKB saved as the abstract MultiCurve type with a
    // CompoundCurve
    
    NSString *text = @"MULTICURVE (COMPOUNDCURVE (LINESTRING (3451418.006 5481808.951, 3451417.787 5481809.927, 3451409.995 5481806.744), LINESTRING (3451409.995 5481806.744, 3451418.006 5481808.951)))";
    
    [SFWTTestUtils assertTrue:[text hasPrefix:[SFGeometryTypes name:SF_MULTICURVE]]];
    
    SFGeometry *geometry = [SFWTGeometryTestUtils readGeometryWithText:text];
    [SFWTTestUtils assertTrue:[geometry isKindOfClass:[SFGeometryCollection class]]];
    [SFWTTestUtils assertEqualIntWithValue:geometry.geometryType andValue2:SF_GEOMETRYCOLLECTION];
    SFGeometryCollection *multiCurve = (SFGeometryCollection *) geometry;
    [SFWTTestUtils assertEqualIntWithValue:1 andValue2:[multiCurve numGeometries]];
    SFGeometry *geometry1 = [multiCurve geometryAtIndex:0];
    [SFWTTestUtils assertTrue:[geometry1 isKindOfClass:[SFCompoundCurve class]]];
    SFCompoundCurve *compoundCurve1 = (SFCompoundCurve *) geometry1;
    [SFWTTestUtils assertEqualIntWithValue:2 andValue2:[compoundCurve1 numLineStrings]];
    SFLineString *lineString1 = [compoundCurve1 lineStringAtIndex:0];
    SFLineString *lineString2 = [compoundCurve1 lineStringAtIndex:1];
    [SFWTTestUtils assertEqualIntWithValue:3 andValue2:[lineString1 numPoints]];
    [SFWTTestUtils assertEqualIntWithValue:2 andValue2:[lineString2 numPoints]];
    
    [SFWTTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451418.006 andYValue:5481808.951] andValue2:[lineString1 pointAtIndex:0]];
    [SFWTTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451417.787 andYValue:5481809.927] andValue2:[lineString1 pointAtIndex:1]];
    [SFWTTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451409.995 andYValue:5481806.744] andValue2:[lineString1 pointAtIndex:2]];
    
    [SFWTTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451409.995 andYValue:5481806.744] andValue2:[lineString2 pointAtIndex:0]];
    [SFWTTestUtils assertEqualWithValue:[[SFPoint alloc] initWithXValue:3451418.006 andYValue:5481808.951] andValue2:[lineString2 pointAtIndex:1]];
    
    SFExtendedGeometryCollection *extendedMultiCurve = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiCurve];
    [SFWTTestUtils assertEqualIntWithValue:SF_MULTICURVE andValue2:extendedMultiCurve.geometryType];
    
    [self geometryTester:extendedMultiCurve withCompare:multiCurve];
    
    NSString *text2 = [SFWTGeometryTestUtils writeTextWithGeometry:extendedMultiCurve];
    [SFWTTestUtils assertTrue:[text2 hasPrefix:[SFGeometryTypes name:SF_MULTICURVE]]];
    [SFWTGeometryTestUtils compareTextWithExpected:text andActual:text2 andDelta:0.00000001];
    
}

-(void) testMultiCurve{

    // Test the abstract MultiCurve type
    
    SFGeometryCollection *multiCurve = [SFWTGeometryTestUtils createMultiCurve];
    
    NSString *text = [SFWTGeometryTestUtils writeTextWithGeometry:multiCurve];
    
    SFExtendedGeometryCollection *extendedMultiCurve = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiCurve];
    [SFWTTestUtils assertEqualIntWithValue:SF_MULTICURVE andValue2:extendedMultiCurve.geometryType];
    
    NSString *extendedText = [SFWTGeometryTestUtils writeTextWithGeometry:extendedMultiCurve];
    
    [SFWTTestUtils assertTrue:[text hasPrefix:[SFGeometryTypes name:SF_GEOMETRYCOLLECTION]]];
    [SFWTTestUtils assertTrue:[extendedText hasPrefix:[SFGeometryTypes name:SF_MULTICURVE]]];
    
    SFGeometry *geometry1 = [SFWTGeometryTestUtils readGeometryWithText:text];
    SFGeometry *geometry2 = [SFWTGeometryTestUtils readGeometryWithText:extendedText];
    
    [SFWTTestUtils assertTrue:[geometry1 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTTestUtils assertTrue:[geometry2 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry1.geometryType];
    [SFWTTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry2.geometryType];
    
    [SFWTTestUtils assertEqualWithValue:multiCurve andValue2:geometry1];
    [SFWTTestUtils assertEqualWithValue:geometry1 andValue2:geometry2];
    
    SFGeometryCollection *geometryCollection1 = (SFGeometryCollection *) geometry1;
    SFGeometryCollection *geometryCollection2 = (SFGeometryCollection *) geometry2;
    [SFWTTestUtils assertTrue:[geometryCollection1 isMultiCurve]];
    [SFWTTestUtils assertTrue:[geometryCollection2 isMultiCurve]];
    
    [self geometryTester:multiCurve];
    [self geometryTester:extendedMultiCurve withCompare:multiCurve];
}

-(void) testMultiSurface{

    // Test the abstract MultiSurface type
    
    SFGeometryCollection *multiSurface = [SFWTGeometryTestUtils createMultiSurface];
    
    NSString *text = [SFWTGeometryTestUtils writeTextWithGeometry:multiSurface];
    
    SFExtendedGeometryCollection *extendedMultiSurface = [[SFExtendedGeometryCollection alloc] initWithGeometryCollection:multiSurface];
    [SFWTTestUtils assertEqualIntWithValue:SF_MULTISURFACE andValue2:extendedMultiSurface.geometryType];
    
    NSString *extendedText = [SFWTGeometryTestUtils writeTextWithGeometry:extendedMultiSurface];
    
    [SFWTTestUtils assertTrue:[text hasPrefix:[SFGeometryTypes name:SF_GEOMETRYCOLLECTION]]];
    [SFWTTestUtils assertTrue:[extendedText hasPrefix:[SFGeometryTypes name:SF_MULTISURFACE]]];
    
    SFGeometry *geometry1 = [SFWTGeometryTestUtils readGeometryWithText:text];
    SFGeometry *geometry2 = [SFWTGeometryTestUtils readGeometryWithText:extendedText];
    
    [SFWTTestUtils assertTrue:[geometry1 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTTestUtils assertTrue:[geometry2 isKindOfClass:[SFGeometryCollection class]]];
    [SFWTTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry1.geometryType];
    [SFWTTestUtils assertEqualIntWithValue:SF_GEOMETRYCOLLECTION andValue2:geometry2.geometryType];
    
    [SFWTTestUtils assertEqualWithValue:multiSurface andValue2:geometry1];
    [SFWTTestUtils assertEqualWithValue:geometry1 andValue2:geometry2];
    
    SFGeometryCollection *geometryCollection1 = (SFGeometryCollection *) geometry1;
    SFGeometryCollection *geometryCollection2 = (SFGeometryCollection *) geometry2;
    [SFWTTestUtils assertTrue:[geometryCollection1 isMultiSurface]];
    [SFWTTestUtils assertTrue:[geometryCollection2 isMultiSurface]];
    
    [self geometryTester:multiSurface];
    [self geometryTester:extendedMultiSurface withCompare:multiSurface];
}

-(void) testMultiPolygon {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a multi polygon
        SFMultiPolygon *multiPolygon = [SFWTGeometryTestUtils createMultiPolygonWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: multiPolygon];
    }
}

-(void) testGeometryCollection {
    for (int i = 0; i < GEOMETRIES_PER_TEST; i++) {
        // Create and test a geometry collection
        SFGeometryCollection *geometryCollection = [SFWTGeometryTestUtils createGeometryCollectionWithHasZ:[SFWTTestUtils coinFlip] andHasM:[SFWTTestUtils coinFlip]];
        [self geometryTester: geometryCollection];
    }
}

-(void) testMultiPolygon25{

    // Test a pre-created WKB hex saved as a 2.5D MultiPolygon
    
    NSString *text = @"MULTIPOLYGON Z(((-91.07087880858114 14.123634886445812 0.0,-91.07087285992856 14.123533759353165 0.0,-91.07105845788698 14.123550415580155 0.0,-91.07106797573107 14.12356112315473 0.0,-91.07112508279522 14.12359443560882 0.0,-91.07105144284623 14.123746753409705 0.0,-91.07104865928 14.123752510973361 0.0,-91.0709799356739 14.123874022276935 0.0,-91.07095614106379 14.123925180688502 0.0,-91.07092996699276 14.124102450533544 0.0,-91.07090855184373 14.124346345286652 0.0,-91.07090141346072 14.124415349655804 0.0,-91.07086453181506 14.12441891884731 0.0,-91.07087404965915 14.12390376553958 0.0,-91.07087880858114 14.123634886445812 0.0)))";
    
    [SFWTTestUtils assertTrue:[text hasPrefix:[NSString stringWithFormat:@"%@ Z", [SFGeometryTypes name:SF_MULTIPOLYGON]]]];

    SFGeometry *geometry = [SFWTGeometryTestUtils readGeometryWithText:text];
    [SFWTTestUtils assertTrue:[geometry isKindOfClass:[SFMultiPolygon class]]];
    [SFWTTestUtils assertEqualIntWithValue:SF_MULTIPOLYGON andValue2:geometry.geometryType];
    SFMultiPolygon *multiPolygon = (SFMultiPolygon *) geometry;
    [SFWTTestUtils assertTrue:multiPolygon.hasZ];
    [SFWTTestUtils assertFalse:multiPolygon.hasM];
    [SFWTTestUtils assertEqualIntWithValue:1 andValue2:[multiPolygon numGeometries]];
    SFPolygon *polygon = [multiPolygon polygonAtIndex:0];
    [SFWTTestUtils assertTrue:polygon.hasZ];
    [SFWTTestUtils assertFalse:polygon.hasM];
    [SFWTTestUtils assertEqualIntWithValue:1 andValue2:[polygon numRings]];
    SFLineString *ring = [polygon ringAtIndex:0];
    [SFWTTestUtils assertTrue:ring.hasZ];
    [SFWTTestUtils assertFalse:ring.hasM];
    [SFWTTestUtils assertEqualIntWithValue:15 andValue2:[ring numPoints]];
    for(SFPoint *point in ring.points){
        [SFWTTestUtils assertTrue:point.hasZ];
        [SFWTTestUtils assertFalse:point.hasM];
        [SFWTTestUtils assertNotNil:point.z];
        [SFWTTestUtils assertNil:point.m];
    }
    
    NSString *multiPolygonText = [SFWTGeometryTestUtils writeTextWithGeometry:multiPolygon];
    [SFWTGeometryTestUtils compareTextWithExpected:text andActual:multiPolygonText andDelta:0.0000000000001];
    
    SFGeometry *geometry2 = [SFWTGeometryTestUtils readGeometryWithText:multiPolygonText];
    
    [self geometryTester:geometry withCompare:geometry2];
    
}

-(void) testFiniteFilter{

    SFPoint *point = [SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:NO];

    SFPoint *nan = [[SFPoint alloc] initWithXValue:NAN andYValue:NAN];
    SFPoint *nanZ = [SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:NO];
    [nanZ setZValue:NAN];
    SFPoint *nanM = [SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:YES];
    [nanM setMValue:NAN];
    SFPoint *nanZM = [SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES];
    [nanZ setZValue:NAN];
    [nanM setMValue:NAN];
    
    SFPoint *infinite = [[SFPoint alloc] initWithXValue:INFINITY andYValue:INFINITY];
    SFPoint *infiniteZ = [SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:NO];
    [infiniteZ setZValue:INFINITY];
    SFPoint *infiniteM = [SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:YES];
    [infiniteM setMValue:INFINITY];
    SFPoint *infiniteZM = [SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES];
    [infiniteZM setZValue:INFINITY];
    [infiniteZM setMValue:INFINITY];

    SFPoint *nanInfinite = [[SFPoint alloc] initWithXValue:NAN andYValue:INFINITY];
    SFPoint *nanInfiniteZM = [SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES];
    [nanInfiniteZM setZValue:NAN];
    [nanInfiniteZM setMValue:-INFINITY];

    SFPoint *infiniteNan = [[SFPoint alloc] initWithXValue:INFINITY andYValue:NAN];
    SFPoint *infiniteNanZM = [SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES];
    [infiniteNanZM setZValue:-INFINITY];
    [infiniteNanZM setMValue:NAN];

    SFLineString *lineString1 = [[SFLineString alloc] init];
    [lineString1 addPoint:point];
    [lineString1 addPoint:nan];
    [lineString1 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:NO]];
    [lineString1 addPoint:infinite];
    [lineString1 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:NO]];
    [lineString1 addPoint:nanInfinite];
    [lineString1 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:NO]];
    [lineString1 addPoint:infiniteNan];

    SFLineString *lineString2 = [[SFLineString alloc] initWithHasZ:YES andHasM:NO];
    [lineString2 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:NO]];
    [lineString2 addPoint:nanZ];
    [lineString2 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:NO]];
    [lineString2 addPoint:infiniteZ];

    SFLineString *lineString3 = [[SFLineString alloc] initWithHasZ:NO andHasM:YES];
    [lineString3 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:YES]];
    [lineString3 addPoint:nanM];
    [lineString3 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:NO andHasM:YES]];
    [lineString3 addPoint:infiniteM];

    SFLineString *lineString4 = [[SFLineString alloc] initWithHasZ:YES andHasM:YES];
    [lineString4 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES]];
    [lineString4 addPoint:nanZM];
    [lineString4 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES]];
    [lineString4 addPoint:infiniteZM];
    [lineString4 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES]];
    [lineString4 addPoint:nanInfiniteZM];
    [lineString4 addPoint:[SFWTGeometryTestUtils createPointWithHasZ:YES andHasM:YES]];
    [lineString4 addPoint:infiniteNanZM];

    SFPolygon *polygon1 = [[SFPolygon alloc] initWithRing:lineString1];
    SFPolygon *polygon2 = [[SFPolygon alloc] initWithRing:lineString2];
    SFPolygon *polygon3 = [[SFPolygon alloc] initWithRing:lineString3];
    SFPolygon *polygon4 = [[SFPolygon alloc] initWithRing:lineString4];

    for(SFPoint *pnt in lineString1.points){
        [SFWTTestCase finiteFilterTester:pnt];
    }

    for(SFPoint *pnt in lineString2.points){
        [SFWTTestCase finiteFilterTester:pnt];
    }

    for(SFPoint *pnt in lineString3.points){
        [SFWTTestCase finiteFilterTester:pnt];
    }

    for(SFPoint *pnt in lineString4.points){
        [SFWTTestCase finiteFilterTester:pnt];
    }
    
    [SFWTTestCase finiteFilterTester:lineString1];
    [SFWTTestCase finiteFilterTester:lineString2];
    [SFWTTestCase finiteFilterTester:lineString3];
    [SFWTTestCase finiteFilterTester:lineString4];
    [SFWTTestCase finiteFilterTester:polygon1];
    [SFWTTestCase finiteFilterTester:polygon2];
    [SFWTTestCase finiteFilterTester:polygon3];
    [SFWTTestCase finiteFilterTester:polygon4];
    
}

-(void) testGeometries{
    [self geometryTextTester:@"Point (10 10)"];
    [self geometryTextTester:@"LineString ( 10 10, 20 20, 30 40)"];
    [self geometryTextTester:@"Polygon\n((10 10, 10 20, 20 20, 20 15, 10 10))"];
    [self geometryTextTester:@"MultiPoint ((10 10), (20 20))"];
    [self geometryTextTester:@"MultiLineString\n(\n(10 10, 20 20), (15 15, 30 15)\n) "];
    [self geometryTextTester:@" MultiPolygon\n(\n((10 10, 10 20, 20 20, 20 15, 10 10)),\n((60 60, 70 70, 80 60, 60 60 ))\n)"];
    [self geometryTextTester:@"GeometryCollection\n(\nPOINT (10 10),\nPOINT (30 30),\nLINESTRING (15 15, 20 20)\n)"];
    [self geometryTextTester:@"PolyhedralSurface Z\n(\n((0 0 0, 0 0 1, 0 1 1, 0 1 0, 0 0 0)),\n((0 0 0, 0 1 0, 1 1 0, 1 0 0, 0 0 0)),\n((0 0 0, 1 0 0, 1 0 1, 0 0 1, 0 0 0)),\n((1 1 0, 1 1 1, 1 0 1, 1 0 0, 1 1 0)),\n((0 1 0, 0 1 1, 1 1 1, 1 1 0, 0 1 0)),\n((0 0 1, 1 0 1, 1 1 1, 0 1 1, 0 0 1))\n)"];
    [self geometryTextTester:@"Tin Z (\n((0 0 0, 0 0 1, 0 1 0, 0 0 0)),\n((0 0 0, 0 1 0, 1 0 0, 0 0 0)),\n((0 0 0, 1 0 0, 0 0 1, 0 0 0)),\n((1 0 0, 0 1 0, 0 0 1, 1 0 0))\n)"];
    [self geometryTextTester:@"Point Z (10 10 5)"];
    [self geometryTextTester:@"Point ZM (10 10 5 40)"];
    [self geometryTextTester:@"Point M (10 10 40)"];
    [self geometryTextTester:@"MULTICURVE (COMPOUNDCURVE (LINESTRING (3451418.006 5481808.951, 3451417.787 5481809.927, 3451409.995 5481806.744), LINESTRING (3451409.995 5481806.744, 3451418.006 5481808.951)), LINESTRING (3451418.006 5481808.951, 3451417.787 5481809.927, 3451409.995 5481806.744), LINESTRING (3451409.995 5481806.744, 3451418.006 5481808.951))" withReplace:[SFGeometryTypes name:SF_MULTICURVE] withReplacement:[SFGeometryTypes name:SF_GEOMETRYCOLLECTION] andDelta:0.00000001];
    [self geometryTextTester:@"COMPOUNDCURVE(EMPTY,CIRCULARSTRING EMPTY)"
            withReplace:@"(EMPTY,CIRCULARSTRING EMPTY)" withReplacement:@" EMPTY"];
    [self geometryTextTester:@"COMPOUNDCURVE(LINESTRING EMPTY,CIRCULARSTRING EMPTY)"
            withReplace:@"(LINESTRING EMPTY,CIRCULARSTRING EMPTY)" withReplacement:@" EMPTY"];
    [self geometryTextTester:@"COMPOUNDCURVE(EMPTY, CIRCULARSTRING(1 5,6 2,7 3))"
            withReplace:@"EMPTY, " withReplacement:@""];
    [self geometryTextTester:@"COMPOUNDCURVE(LINESTRING EMPTY, CIRCULARSTRING(1 5,6 2,7 3))"
            withReplace:@"LINESTRING EMPTY," withReplacement:@""];
    [self geometryTextTester:@"CircularString(1.1 1.9, 1.1 2.5, 1.1 1.9)"];
    [self geometryTextTester:@"Point(0.96 2.32)"];
    [self geometryTextTester:@"MultiCurve(CircularString(0.9 2.32, 0.95 2.3, 1.0 2.32),CircularString(0.9 2.32, 0.95 2.34, 1.0 2.32))"
            withReplace:@"MultiCurve" withReplacement:[SFGeometryTypes name:SF_GEOMETRYCOLLECTION] andDelta:0.000000000000001];
    [self geometryTextTester:@"MultiCurve(CircularString(1.05 1.56, 1.03 1.53, 1.05 1.50),CircularString(1.05 1.50, 1.10 1.48, 1.15 1.52),CircularString(1.15 1.52, 1.14 1.54, 1.12 1.53),CircularString(1.12 1.53, 1.06 1.42, 0.95 1.28),CircularString(0.95 1.28, 0.92 1.31, 0.95 1.34),CircularString(0.95 1.34, 1.06 1.28, 1.17 1.32))"
            withReplace:@"MultiCurve" withReplacement:[SFGeometryTypes name:SF_GEOMETRYCOLLECTION] andDelta:0.000000000000001];
    [self geometryTextTester:@"MultiPolygon(((2.18 1.0, 2.1 1.2, 2.3 1.4, 2.5 1.2, 2.35 1.0, 2.18 1.0)),((2.3 1.4, 2.57 1.6, 2.7 1.3, 2.3 1.4)))"];
    [self geometryTextTester:@"MultiSurface(((1.6 1.9, 1.9 1.9, 1.9 2.2, 1.6 2.2, 1.6 1.9)),((1.1 1.8, 0.7 1.2, 1.5 1.2, 1.1 1.8)))" withExpected:@"GEOMETRYCOLLECTION (POLYGON ((1.6 1.9, 1.9 1.9, 1.9 2.2, 1.6 2.2, 1.6 1.9)), POLYGON ((1.1 1.8, 0.7 1.2, 1.5 1.2, 1.1 1.8)))"];
    [self geometryTextTester:@"CurvePolygon(CompoundCurve(CircularString(2.6 1.0, 2.7 1.3, 2.8 1.0),(2.8 1.0, 2.6 1.0)))" withReplace:@"(2.8 1.0, 2.6 1.0)" withReplacement:[NSString stringWithFormat:@"%@(2.8 1.0, 2.6 1.0)", [SFGeometryTypes name:SF_LINESTRING]]];
    [self geometryTextTester:@"GeometryCollection(MultiCurve((2.0 1.0, 2.1 1.0),CircularString(2.0 1.0, 1.98 1.1, 1.9 1.2),CircularString(2.1 1.0, 2.08 1.1, 2.0 1.2),(1.9 1.2, 1.85 1.3),(2.0 1.2, 1.9 1.35),(1.85 1.3, 1.9 1.35)),CircularString(1.85 1.3, 1.835 1.29, 1.825 1.315),CircularString(1.9 1.35, 1.895 1.38, 1.88 1.365),LineString(1.825 1.315, 1.88 1.365))" withExpected:@"GEOMETRYCOLLECTION (GEOMETRYCOLLECTION (LINESTRING (2.0 1.0, 2.1 1.0), CIRCULARSTRING (2.0 1.0, 1.98 1.1, 1.9 1.2), CIRCULARSTRING (2.1 1.0, 2.08 1.1, 2.0 1.2), LINESTRING (1.9 1.2, 1.85 1.3), LINESTRING (2.0 1.2, 1.9 1.35), LINESTRING (1.85 1.3, 1.9 1.35)), CIRCULARSTRING (1.85 1.3, 1.835 1.29, 1.825 1.315), CIRCULARSTRING (1.9 1.35, 1.895 1.38, 1.88 1.365), LINESTRING (1.825 1.315, 1.88 1.365))" andDelta:0.000000000000001];
    [self geometryTextTester:@"COMPOUNDCURVE((0 0, 0.25 0), CIRCULARSTRING(0.25 0, 0.5 0.5, 0.75 0), (0.75 0, 1 0))" withExpected:@"COMPOUNDCURVE(LINESTRING(0 0, 0.25 0), CIRCULARSTRING(0.25 0, 0.5 0.5, 0.75 0), LINESTRING(0.75 0, 1 0))"];
    [self geometryTextTester:@"POLYHEDRALSURFACE Z(\n    ((0 0 0, 0 0 1, 0 1 1, 0 1 0, 0 0 0)),\n    ((0 0 0, 0 1 0, 1 1 0, 1 0 0, 0 0 0)),\n    ((0 0 0, 1 0 0, 1 0 1, 0 0 1, 0 0 0)),\n    ((1 1 0, 1 1 1, 1 0 1, 1 0 0, 1 1 0)),\n    ((0 1 0, 0 1 1, 1 1 1, 1 1 0, 0 1 0)),\n    ((0 0 1, 1 0 1, 1 1 1, 0 1 1, 0 0 1))\n)"];
    [self geometryTextTester:@"POLYHEDRALSURFACE(\n    ((0 0 0, 0 0 1, 0 1 1, 0 1 0, 0 0 0)),\n    ((0 0 0, 0 1 0, 1 1 0, 1 0 0, 0 0 0)),\n    ((0 0 0, 1 0 0, 1 0 1, 0 0 1, 0 0 0)),\n    ((1 1 0, 1 1 1, 1 0 1, 1 0 0, 1 1 0)),\n    ((0 1 0, 0 1 1, 1 1 1, 1 1 0, 0 1 0)),\n    ((0 0 1, 1 0 1, 1 1 1, 0 1 1, 0 0 1))\n)" withReplace:@"POLYHEDRALSURFACE" withReplacement:@"POLYHEDRALSURFACE Z" andValidateZM:NO];
    [self geometryTextTester:@"CIRCULARSTRING Z (220268 150415 1,220227 150505 2,220227 150406 3)"];
    [self geometryTextTester:@"CIRCULARSTRING(220268 150415 1,220227 150505 2,220227 150406 3)"
            withReplace:@"CIRCULARSTRING" withReplacement:@"CIRCULARSTRING Z" andValidateZM:NO];
    [self geometryTextTester:@"TRIANGLE ((0 0, 0 9, 9 0, 0 0))"];
    [self geometryTextTester:@"MULTIPOLYGON(((0 0 0,4 0 0,4 4 0,0 4 0,0 0 0),(1 1 0,2 1 0,2 2 0,1 2 0,1 1 0)),((-1 -1 0,-1 -2 0,-2 -2 0,-2 -1 0,-1 -1 0)))"
            withReplace:@"MULTIPOLYGON" withReplacement:@"MULTIPOLYGON Z" andValidateZM:NO];
    [self geometryTextTester:@"TIN( ((0 0 0, 0 0 1, 0 1 0, 0 0 0)), ((0 0 0, 0 1 0, 1 1 0, 0 0 0)) )"
            withReplace:@"TIN" withReplacement:@"TIN Z" andValidateZM:NO];
    [self geometryTextTester:@"POINT(0 0 0)" withReplace:@"POINT" withReplacement:@"POINT Z" andValidateZM:NO];
    [self geometryTextTester:@"POINTM(0 0 0)" withReplace:@"POINTM" withReplacement:@"POINT M"];
    [self geometryTextTester:@"POINT(0 0 0 0)" withReplace:@"POINT" withReplacement:@"POINT ZM" andValidateZM:NO];
    [self geometryTextTester:@"POINTZM(0 0 0 0)" withReplace:@"POINTZM" withReplacement:@"POINT ZM"];
    [self geometryTextTester:@"MULTIPOINTM(0 0 0,1 2 1)"
            withExpected:@"MULTIPOINT M((0 0 0),(1 2 1))"];
    [self geometryTextTester:@"GEOMETRYCOLLECTIONM( POINTM(2 3 9), LINESTRINGM(2 3 4, 3 4 5) )"
            withExpected:@"GEOMETRYCOLLECTION M( POINT M(2 3 9), LINESTRING M(2 3 4, 3 4 5) )"];
    [self geometryTextTester:@"GEOMETRYCOLLECTIONZ(POINTZ(13.21 47.21 0.21),\nLINESTRINGZ(15.21 57.58 0.31,\n15.81 57.12 0.33))"
            withExpected:@"GEOMETRYCOLLECTION Z(POINT Z(13.21 47.21 0.21),\nLINESTRING Z(15.21 57.58 0.31,\n15.81 57.12 0.33))" andDelta:0.0000000000001];
    [self geometryTextTester:@"GEOMETRYCOLLECTIONM(POINTM(13.21 47.21 1000.0),\nLINESTRINGM(15.21 57.58 1000.0, 15.81 57.12 1100.0))"
            withExpected:@"GEOMETRYCOLLECTION M(POINT M(13.21 47.21 1000.0),\nLINESTRING M(15.21 57.58 1000.0, 15.81 57.12 1100.0))" andDelta:0.0000000000001];
    [self geometryTextTester:@"GEOMETRYCOLLECTIONZM(POINTZM(13.21 47.21 0.21 1000.0),\nLINESTRINGZM(15.21 57.58 0.31 1000.0, 15.81 57.12 0.33 1100.0))"
                withExpected:@"GEOMETRYCOLLECTION ZM(POINT ZM(13.21 47.21 0.21 1000.0),\nLINESTRING ZM(15.21 57.58 0.31 1000.0, 15.81 57.12 0.33 1100.0))" andDelta:0.0000000000001];
}

-(void) geometryTextTester: (NSString *) text{
    [self geometryTextTester:text withExpected:text];
}

-(void) geometryTextTester: (NSString *) text withReplace: (NSString *) replace withReplacement: (NSString *) replacement{
    [self geometryTextTester:text withReplace:replace withReplacement:replacement andDelta:0];
}

-(void) geometryTextTester: (NSString *) text withReplace: (NSString *) replace withReplacement: (NSString *) replacement andDelta: (double) delta{
    [self geometryTextTester:text withReplace:replace withReplacement:replacement andValidateZM:YES andDelta:delta];
}

-(void) geometryTextTester: (NSString *) text withReplace: (NSString *) replace withReplacement: (NSString *) replacement andValidateZM: (BOOL) validateZM{
    [self geometryTextTester:text withReplace:replace withReplacement:replacement andValidateZM:validateZM andDelta:0];
}

-(void) geometryTextTester: (NSString *) text withReplace: (NSString *) replace withReplacement: (NSString *) replacement andValidateZM: (BOOL) validateZM andDelta: (double) delta{
    [self geometryTextTester:text withExpected:[text stringByReplacingOccurrencesOfString:replace withString:replacement] andValidateZM:validateZM andDelta:delta];
}

-(void) geometryTextTester: (NSString *) text withExpected: (NSString *) expected{
    [self geometryTextTester:text withExpected:expected andDelta:0];
}

-(void) geometryTextTester: (NSString *) text withExpected: (NSString *) expected andDelta: (double) delta{
    [self geometryTextTester:text withExpected:expected andValidateZM:YES andDelta:delta];
}

-(void) geometryTextTester: (NSString *) text withExpected: (NSString *) expected andValidateZM: (BOOL) validateZM{
    [self geometryTextTester:text withExpected:expected andValidateZM:YES andDelta:0];
}

-(void) geometryTextTester: (NSString *) text withExpected: (NSString *) expected andValidateZM: (BOOL) validateZM andDelta: (double) delta{
    
    SFGeometry *geometry = [SFWTGeometryTestUtils readGeometryWithText:text andValidateZM:validateZM];
    NSString *text2 = [SFWTGeometryTestUtils writeTextWithGeometry:geometry];
    [SFWTGeometryTestUtils compareTextWithExpected:expected andActual:text2 andDelta:delta];
    
}

-(void) geometryTester: (SFGeometry *) geometry{
    [self geometryTester:geometry withCompare:geometry];
}

-(void) geometryTester: (SFGeometry *) geometry withCompare: (SFGeometry *) compareGeometry{
    [self geometryTester:geometry withCompare:compareGeometry andDelta:0];
}

-(void) geometryTester: (SFGeometry *) geometry withCompare: (SFGeometry *) compareGeometry andDelta: (double) delta{
    
    // Write the geometry to text
    NSString *text = [SFWTGeometryTestUtils writeTextWithGeometry:geometry];
    
    // Test the geometry read from text
    SFGeometry *geometryFromText = [SFWTGeometryTestUtils readGeometryWithText:text];
    [SFWTGeometryTestUtils compareTextWithExpected:[SFWTGeometryTestUtils writeTextWithGeometry:compareGeometry] andActual:[SFWTGeometryTestUtils writeTextWithGeometry:geometryFromText] andDelta:delta];
    
    [SFWTGeometryTestUtils compareGeometriesWithExpected:compareGeometry andActual:geometryFromText andDelta:delta];
    
    SFGeometryEnvelope *envelope = [compareGeometry envelope];
    SFGeometryEnvelope *envelopeFromText = [geometryFromText envelope];
    
    [SFWTGeometryTestUtils compareEnvelopesWithExpected:envelope andActual:envelopeFromText andDelta:delta];
}

+(void) finiteFilterTester: (SFGeometry *) geometry{

    NSString *text = [SFWTGeometryTestUtils writeTextWithGeometry:geometry];
    
    SFGeometry *geometry2 = [SFWTGeometryReader readGeometryWithText:text];
    [SFWTGeometryTestUtils compareGeometriesWithExpected:geometry andActual:geometry2];
    
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] init]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithZ:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithZ:NO andM:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithZ:YES andM:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_NAN]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_NAN andZ:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_NAN andZ:NO andM:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_NAN andZ:YES andM:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_INFINITE]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_INFINITE andZ:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_INFINITE andZ:NO andM:YES]];
    [self finiteFilterTester:text andFilter:[[SFPointFiniteFilter alloc] initWithType:SF_FF_FINITE_AND_INFINITE andZ:YES andM:YES]];
    
}

+(void) finiteFilterTester: (NSString *) text andFilter: (SFPointFiniteFilter *) filter{
    
    SFGeometry *geometry = [SFWTGeometryReader readGeometryWithText:text andFilter:filter];
    
    if(geometry != nil){
        
        NSMutableArray<SFPoint *> *points = [NSMutableArray array];
        
        switch(geometry.geometryType){
            case SF_POINT:
                [points addObject:(SFPoint *)geometry];
                break;
            case SF_LINESTRING:
                [points addObjectsFromArray:((SFLineString *) geometry).points];
                break;
            case SF_POLYGON:
                [points addObjectsFromArray:[((SFPolygon *) geometry) ringAtIndex:0].points];
                break;
            default:
                [SFWTTestUtils fail:[NSString stringWithFormat:@"Unexpected test case: %u", geometry.geometryType]];
        }
        
        for(SFPoint *point in points){
            
            switch (filter.type) {
                case SF_FF_FINITE:
                    [SFWTTestUtils assertTrue:isfinite([point.x doubleValue])];
                    [SFWTTestUtils assertTrue:isfinite([point.y doubleValue])];
                    if(filter.filterZ && point.hasZ){
                        [SFWTTestUtils assertTrue:isfinite([point.z doubleValue])];
                    }
                    if(filter.filterM && point.hasM){
                        [SFWTTestUtils assertTrue:isfinite([point.m doubleValue])];
                    }
                    break;
                case SF_FF_FINITE_AND_NAN:
                    [SFWTTestUtils assertTrue:isfinite([point.x doubleValue]) || isnan([point.x doubleValue])];
                    [SFWTTestUtils assertTrue:isfinite([point.y doubleValue]) || isnan([point.y doubleValue])];
                    if(filter.filterZ && point.hasZ){
                        [SFWTTestUtils assertTrue:isfinite([point.z doubleValue]) || isnan([point.z doubleValue])];
                    }
                    if(filter.filterM && point.hasM){
                        [SFWTTestUtils assertTrue:isfinite([point.m doubleValue]) || isnan([point.m doubleValue])];
                    }
                    break;
                case SF_FF_FINITE_AND_INFINITE:
                    [SFWTTestUtils assertTrue:isfinite([point.x doubleValue]) || isinf([point.x doubleValue])];
                    [SFWTTestUtils assertTrue:isfinite([point.y doubleValue]) || isinf([point.y doubleValue])];
                    if(filter.filterZ && point.hasZ){
                        [SFWTTestUtils assertTrue:isfinite([point.z doubleValue]) || isinf([point.z doubleValue])];
                    }
                    if(filter.filterM && point.hasM){
                        [SFWTTestUtils assertTrue:isfinite([point.m doubleValue]) || isinf([point.m doubleValue])];
                    }
                    break;
                default:
                    break;
            }
            
        }
        
    }
    
}

@end
