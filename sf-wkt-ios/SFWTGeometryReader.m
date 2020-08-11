//
//  SFWTGeometryReader.m
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTGeometryReader.h"

@implementation SFWTGeometryReader

+(SFGeometry *) readGeometryWithText: (NSString *) text{
    return [self readGeometryWithText:text andFilter:nil andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithText: (NSString *) text andFilter: (NSObject<SFGeometryFilter> *) filter{
    return [self readGeometryWithText:text andFilter:filter andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithText: (NSString *) text andExpectedType: (Class) expectedType{
    return [self readGeometryWithText:text andFilter:nil andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithText: (NSString *) text andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType{
    SFTextReader *reader = [[SFTextReader alloc] initWithText:text];
    return [self readGeometryWithReader:reader andFilter:filter andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader{
    return [self readGeometryWithReader:reader andFilter:nil andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter{
    return [self readGeometryWithReader:reader andFilter:filter andExpectedType:nil];
}

+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andExpectedType: (Class) expectedType{
    return [self readGeometryWithReader:reader andFilter:nil andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType{
    return [self readGeometryWithReader:reader andFilter:filter inType:SF_NONE andExpectedType:expectedType];
}

+(SFGeometry *) readGeometryWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter inType: (enum SFGeometryType) containingType andExpectedType: (Class) expectedType{
    
    SFGeometry *geometry = nil;
    
    // Read the geometry type
    SFWTGeometryTypeInfo *geometryTypeInfo = [self readGeometryTypeWithReader:reader];
    
    if(geometryTypeInfo != nil){
        
        enum SFGeometryType geometryType = [geometryTypeInfo geometryType];
        BOOL hasZ = [geometryTypeInfo hasZ];
        BOOL hasM = [geometryTypeInfo hasM];
        
        switch(geometryType){
        
            case SF_GEOMETRY:
                [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POINT:
                geometry = [self readPointTextWithReader:reader andHasZ:hasZ andHasM:hasM];
                break;
            case SF_LINESTRING:
                geometry = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_POLYGON:
                geometry = [self readPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTIPOINT:
                geometry = [self readMultiPointWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTILINESTRING:
                geometry = [self readMultiLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTIPOLYGON:
                geometry = [self readMultiPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_GEOMETRYCOLLECTION:
                geometry = [self readGeometryCollectionWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTICURVE:
                geometry = [self readMultiCurveWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTISURFACE:
                geometry = [self readMultiSurfaceWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_CIRCULARSTRING:
                geometry = [self readCircularStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_COMPOUNDCURVE:
                geometry = [self readCompoundCurveWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_CURVEPOLYGON:
                geometry = [self readCurvePolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_CURVE:
                [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_SURFACE:
                [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POLYHEDRALSURFACE:
                geometry = [self readPolyhedralSurfaceWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_TIN:
                geometry = [self readTINWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_TRIANGLE:
                geometry = [self readTriangleWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_NONE:
            default:
                [NSException raise:@"Unsupported Geometry" format:@"Geometry Type not supported: %@", [SFGeometryTypes name:geometryType]];
        }
        
        if(![self filter:filter geometry:geometry inType:containingType]){
            geometry = nil;
        }
        
        // If there is an expected type, verify the geometry is of that type
        if (expectedType != nil && geometry != nil && ![geometry isKindOfClass:expectedType]){
            [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type. Expected: %@, Actual: %@", expectedType, [geometry class]];
        }
        
    }
    
    return geometry;
}

+(SFWTGeometryTypeInfo *) readGeometryTypeWithReader: (SFTextReader *) reader{
    
    SFWTGeometryTypeInfo *geometryInfo = nil;
    
    // Read the geometry type
    NSString *geometryTypeValue = [reader readToken];
    
    if(geometryTypeValue != nil
       && [geometryTypeValue caseInsensitiveCompare:@"EMPTY"] != NSOrderedSame){
        
        BOOL hasZ = NO;
        BOOL hasM = NO;
        
        // Determine the geometry type
        enum SFGeometryType geometryType = [SFGeometryTypes fromName:geometryTypeValue];

        // If not found, check if the geometry type has Z and/or M suffix
        if (geometryType == SF_NONE) {

            // Check if the Z and/or M is appended to the geometry type
            NSString *geomType = [geometryTypeValue uppercaseString];
            if([geomType hasSuffix:@"Z"]){
                hasZ = YES;
            } else if ([geomType hasSuffix:@"M"]) {
                hasM = YES;
                if ([geomType hasSuffix:@"ZM"]) {
                    hasZ = YES;
                }
            }

            int suffixSize = 0;
            if (hasZ) {
                suffixSize++;
            }
            if (hasM) {
                suffixSize++;
            }

            if (suffixSize > 0) {
                // Check for the geometry type without the suffix
                geomType = [geometryTypeValue substringToIndex:geometryTypeValue.length - suffixSize];
                geometryType = [SFGeometryTypes fromName:geomType];
            }

            if (geometryType == SF_NONE) {
                [NSException raise:@"Unexpected Type" format:@"Expected a valid geometry type, found: '%@'", geometryTypeValue];
            }

        }

        // Determine if the geometry has a z (3d) or m (linear referencing
        // system) value
        if (!hasZ && !hasM) {

            // Peek at the next token without popping it off
            NSString *next = [reader peekToken];
            NSString *nextUpper = [next uppercaseString];

            if([nextUpper isEqualToString:@"Z"]){
                hasZ = YES;
            }else if([nextUpper isEqualToString:@"M"]){
                hasM = YES;
            }else if([nextUpper isEqualToString:@"ZM"]){
                hasZ = YES;
                hasM = YES;
            }else if(![nextUpper isEqualToString:@"("] && ![nextUpper isEqualToString:@"EMPTY"]){
                [NSException raise:@"Invalid Value" format:@"Invalid value following geometry type: '%@', value: '%@'", geometryTypeValue, next];
            }

            if (hasZ || hasM) {
                // Read off the Z and/or M token
                [reader readToken];
            }

        }

        geometryInfo = [[SFWTGeometryTypeInfo alloc] initWithType:geometryType andHasZ:hasZ andHasM:hasM];
        
    }
    
    return geometryInfo;
}

+(SFPoint *) readPointTextWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{

    SFPoint *point = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        point = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
        [self rightParenthesis:reader];
    }
    
    return point;
}

+(SFPoint *) readPointWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [reader readDouble];
    double y = [reader readDouble];
    
    SFPoint *point = [[SFPoint alloc] initWithHasZ:hasZ andHasM:hasM andXValue:x andYValue:y];
    
    if(hasZ || hasM){
        if(hasZ){
            [point setZValue:[reader readDouble]];
        }
        
        if(hasM){
            [point setMValue:[reader readDouble]];
        }
    } else if(![self isCommaOrRightParenthesis:reader]){
        
        [point setZValue:[reader readDouble]];
        
        if(![self isCommaOrRightParenthesis:reader]){
            
            [point setMValue:[reader readDouble]];
            
        }
        
    }
    
    return point;
}

+(SFLineString *) readLineStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readLineStringWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) readLineStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFLineString *lineString = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        lineString = [[SFLineString alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPoint *point = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:point inType:SF_LINESTRING]){
                [lineString addPoint:point];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return lineString;
}

+(SFPolygon *) readPolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolygonWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) readPolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolygon *polygon = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        polygon = [[SFPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *ring = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:ring inType:SF_POLYGON]){
                [polygon addRing:ring];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return polygon;
}

+(SFMultiPoint *) readMultiPointWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPointWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) readMultiPointWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint *multiPoint = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        multiPoint = [[SFMultiPoint alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPoint *point = nil;
            if([self isLeftParenthesisOrEmpty:reader]){
                point = [self readPointTextWithReader:reader andHasZ:hasZ andHasM:hasM];
            }else{
                point = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            }
            if([self filter:filter geometry:point inType:SF_MULTIPOINT]){
                [multiPoint addPoint:point];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return multiPoint;
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiLineStringWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        multiLineString = [[SFMultiLineString alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *lineString = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:lineString inType:SF_MULTILINESTRING]){
                [multiLineString addLineString:lineString];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return multiLineString;
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPolygonWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon *multiPolygon = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        multiPolygon = [[SFMultiPolygon alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPolygon *polygon = [self readPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:polygon inType:SF_MULTIPOLYGON]){
                [multiPolygon addPolygon:polygon];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return multiPolygon;
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readGeometryCollectionWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *geometryCollection = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        geometryCollection = [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFGeometry *geometry = [self readGeometryWithReader:reader andFilter:filter inType:SF_GEOMETRYCOLLECTION andExpectedType:[SFGeometry class]];
            if(geometry != nil){
                [geometryCollection addGeometry:geometry];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return geometryCollection;
}

 +(SFGeometryCollection *) readMultiCurveWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
     
     SFGeometryCollection *multiCurve = nil;
     
     if([self leftParenthesisOrEmpty:reader]){
         
         multiCurve = [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
         
         do {
             SFCurve *curve = nil;
             if([self isLeftParenthesisOrEmpty:reader]){
                 curve = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                 if(![self filter:filter geometry:curve inType:SF_MULTICURVE]){
                     curve = nil;
                 }
             }else{
                 curve = (SFCurve *)[self readGeometryWithReader:reader andFilter:filter inType:SF_MULTICURVE andExpectedType:[SFCurve class]];
             }
             if(curve != nil){
                 [multiCurve addGeometry:curve];
             }
         } while ([self commaOrRightParenthesis:reader]);
         
     }
     
     return multiCurve;
 }

+(SFGeometryCollection *) readMultiSurfaceWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *multiSurface = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        multiSurface = [[SFGeometryCollection alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFSurface *surface = nil;
            if([self isLeftParenthesisOrEmpty:reader]){
                surface = [self readPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                if(![self filter:filter geometry:surface inType:SF_MULTISURFACE]){
                    surface = nil;
                }
            }else{
                surface = (SFSurface *)[self readGeometryWithReader:reader andFilter:filter inType:SF_MULTISURFACE andExpectedType:[SFSurface class]];
            }
            if(surface != nil){
                [multiSurface addGeometry:surface];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return multiSurface;
}

+(SFCircularString *) readCircularStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCircularStringWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) readCircularStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCircularString *circularString = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        circularString = [[SFCircularString alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPoint *point = [self readPointWithReader:reader andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:point inType:SF_CIRCULARSTRING]){
                [circularString addPoint:point];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return circularString;
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCompoundCurveWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCompoundCurve *compoundCurve = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        compoundCurve = [[SFCompoundCurve alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *lineString = nil;
            if([self isLeftParenthesisOrEmpty:reader]){
                lineString = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                if(![self filter:filter geometry:lineString inType:SF_COMPOUNDCURVE]){
                    lineString = nil;
                }
            }else{
                lineString = (SFLineString *)[self readGeometryWithReader:reader andFilter:filter inType:SF_COMPOUNDCURVE andExpectedType:[SFLineString class]];
            }
            if(lineString != nil){
                [compoundCurve addLineString:lineString];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return compoundCurve;
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCurvePolygonWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        curvePolygon = [[SFCurvePolygon alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFCurve *ring = nil;
            if([self isLeftParenthesisOrEmpty:reader]){
                ring = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
                if(![self filter:filter geometry:ring inType:SF_CURVEPOLYGON]){
                    ring = nil;
                }
            }else{
                ring = (SFCurve *)[self readGeometryWithReader:reader andFilter:filter inType:SF_CURVEPOLYGON andExpectedType:[SFCurve class]];
            }
            if(ring != nil){
                [curvePolygon addRing:ring];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return curvePolygon;
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolyhedralSurfaceWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolyhedralSurface *polyhedralSurface = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        polyhedralSurface = [[SFPolyhedralSurface alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPolygon *polygon = [self readPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:polygon inType:SF_POLYHEDRALSURFACE]){
                [polyhedralSurface addPolygon:polygon];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return polyhedralSurface;
}

+(SFTIN *) readTINWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTINWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) readTINWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTIN *tin = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        tin = [[SFTIN alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPolygon *polygon = [self readPolygonWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:polygon inType:SF_TIN]){
                [tin addPolygon:polygon];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return tin;
}

+(SFTriangle *) readTriangleWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTriangleWithReader:reader andFilter:nil andHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) readTriangleWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTriangle *triangle = nil;
    
    if([self leftParenthesisOrEmpty:reader]){
        
        triangle = [[SFTriangle alloc] initWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *ring = [self readLineStringWithReader:reader andFilter:filter andHasZ:hasZ andHasM:hasM];
            if([self filter:filter geometry:ring inType:SF_TRIANGLE]){
                [triangle addRing:ring];
            }
        } while ([self commaOrRightParenthesis:reader]);
        
    }
    
    return triangle;
}

/**
 * Read a left parenthesis or empty set
 *
 * @param reader
 *            text reader
 * @return true if not empty
 */
+(BOOL) leftParenthesisOrEmpty: (SFTextReader *) reader{
    
    BOOL nonEmpty;
    
    NSString *token = [reader readToken];
    NSString *tokenUpper = [token uppercaseString];
    
    if([tokenUpper isEqualToString:@"EMPTY"]){
        nonEmpty = NO;
    }else if([tokenUpper isEqualToString:@"("]){
        nonEmpty = YES;
    }else{
        [NSException raise:@"Invalid Token" format:@"Invalid token, expected 'EMPTY' or '('. found: '%@'", token];
    }
    
    return nonEmpty;
}

/**
 * Read a comma or right parenthesis
 *
 * @param reader
 *            text reader
 * @return true if a comma
 */
+(BOOL) commaOrRightParenthesis: (SFTextReader *) reader{
    
    BOOL comma;
    
    NSString *token = [reader readToken];
    NSString *tokenUpper = [token uppercaseString];
    
    if([tokenUpper isEqualToString:@","]){
        comma = YES;
    }else if([tokenUpper isEqualToString:@")"]){
        comma = NO;
    }else{
        [NSException raise:@"Invalid Token" format:@"Invalid token, expected ',' or ')'. found: '%@'", token];
    }
    
    return comma;
}

/**
 * Read a right parenthesis
 *
 * @param reader
 *            text reader
 */
+(void) rightParenthesis: (SFTextReader *) reader{
    NSString *token = [reader readToken];
    if (![token isEqualToString:@")"]) {
        [NSException raise:@"Invalid Token" format:@"Invalid token, expected ')'. found: '%@'", token];
    }
}

/**
 * Determine if the next token is either a left parenthesis or empty
 *
 * @param reader
 *            text reader
 * @return true if a left parenthesis or empty
 */
+(BOOL) isLeftParenthesisOrEmpty: (SFTextReader *) reader{
    NSString *token = [[reader peekToken] uppercaseString];
    return [token isEqualToString:@"EMPTY"] || [token isEqualToString:@"("];
}

/**
 * Determine if the next token is either a comma or right parenthesis
 *
 * @param reader
 *            text reader
 * @return true if a comma
 */
+(BOOL) isCommaOrRightParenthesis: (SFTextReader *) reader{
    NSString *token = [reader peekToken];
    return [token isEqualToString:@","] || [token isEqualToString:@")"];
}

/**
 * Filter the geometry
 *
 * @param filter
 *            geometry filter or null
 * @param containingType
 *            containing geometry type
 * @param geometry
 *            geometry or null
 * @return true if passes filter
 */
+(BOOL) filter: (NSObject<SFGeometryFilter> *) filter geometry: (SFGeometry *) geometry inType: (enum SFGeometryType) containingType{
    return filter == nil || geometry == nil || [filter filterGeometry:geometry inType:containingType];
}

/**
 * To upper case helper with null handling for switch statements
 *
 * @param value
 *            string value
 * @return upper case value or empty string
 */
+(NSString *) toUpperCase: (NSString *) value{
    return value != nil ? [value uppercaseString] : @"";
}

@end
