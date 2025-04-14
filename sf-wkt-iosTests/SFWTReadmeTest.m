//
//  SFWTReadmeTest.m
//  sf-wkt-iosTests
//
//  Created by Brian Osborn on 8/7/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTReadmeTest.h"
@import SimpleFeatures;
@import SimpleFeaturesWKT;
@import TestUtils;

@implementation SFWTReadmeTest

static SFGeometry *TEST_GEOMETRY;
static NSString *TEST_TEXT;

-(void) setUp{
    TEST_GEOMETRY = [SFPoint pointWithXValue:1.0 andYValue:1.0];
    TEST_TEXT = @"POINT (1.0 1.0)";
}

/**
 * Test read
 */
-(void) testRead{
    
    SFGeometry *geometry = [self readTester:TEST_TEXT];
    
    [SFWTTestUtils assertEqualWithValue:TEST_GEOMETRY andValue2:geometry];
    
}

/**
 * Test read
 *
 * @param text
 *            text
 * @return geometry
 */
-(SFGeometry *) readTester: (NSString *) text{
    
    // NSString *text = ...
    
    SFGeometry *geometry = [SFWTGeometryReader readGeometryWithText:text];
//    SFGeometryType geometryType = geometry.geometryType;
    
    return geometry;
}

/**
 * Test write
 */
-(void) testWrite{
    
    NSString *text = [self writeTester:TEST_GEOMETRY];

    [SFWTGeometryTestUtils compareTextWithExpected:TEST_TEXT andActual:text];
    
}

/**
 * Test write
 *
 * @param geometry
 *            geometry
 * @return text
 */
-(NSString *) writeTester: (SFGeometry *) geometry{
    
    // SFGeometry *geometry = ...
    
    NSString *text = [SFWTGeometryWriter writeGeometry:geometry];
    
    return text;
}

@end
