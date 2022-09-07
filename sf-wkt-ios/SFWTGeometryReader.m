//
//  SFWTGeometryReader.m
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTGeometryReader.h"

@interface SFWTGeometryReader()

/**
 * Text Reader
 */
@property (nonatomic, strong) SFTextReader *reader;

@end

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
    SFWTGeometryReader *reader = [[SFWTGeometryReader alloc] initWithText:text];
    return [reader readWithFilter:filter andExpectedType:expectedType];
}

-(instancetype) initWithText: (NSString *) text{
    return [self initWithReader:[[SFTextReader alloc] initWithText:text]];
}

-(instancetype) initWithReader: (SFTextReader *) reader{
    self = [super init];
    if(self != nil){
        _reader = reader;
    }
    return self;
}

-(SFTextReader *) textReader{
    return _reader;
}

-(SFGeometry *) read{
    return [self readWithFilter:nil andExpectedType:nil];
}

-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter{
    return [self readWithFilter:filter andExpectedType:nil];
}

-(SFGeometry *) readWithExpectedType: (Class) expectedType{
    return [self readWithFilter:nil andExpectedType:expectedType];
}

-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter andExpectedType: (Class) expectedType{
    return [self readWithFilter:filter inType:SF_NONE andExpectedType:expectedType];
}

-(SFGeometry *) readWithFilter: (NSObject<SFGeometryFilter> *) filter inType: (enum SFGeometryType) containingType andExpectedType: (Class) expectedType{
    
    SFGeometry *geometry = nil;
    
    // Read the geometry type
    SFWTGeometryTypeInfo *geometryTypeInfo = [self readGeometryType];
    
    if(geometryTypeInfo != nil){
        
        enum SFGeometryType geometryType = [geometryTypeInfo geometryType];
        BOOL hasZ = [geometryTypeInfo hasZ];
        BOOL hasM = [geometryTypeInfo hasM];
        
        switch(geometryType){
        
            case SF_GEOMETRY:
                [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POINT:
                geometry = [self readPointTextWithHasZ:hasZ andHasM:hasM];
                break;
            case SF_LINESTRING:
                geometry = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_POLYGON:
                geometry = [self readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTIPOINT:
                geometry = [self readMultiPointWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTILINESTRING:
                geometry = [self readMultiLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTIPOLYGON:
                geometry = [self readMultiPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_GEOMETRYCOLLECTION:
                geometry = [self readGeometryCollectionWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTICURVE:
                geometry = [self readMultiCurveWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_MULTISURFACE:
                geometry = [self readMultiSurfaceWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_CIRCULARSTRING:
                geometry = [self readCircularStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_COMPOUNDCURVE:
                geometry = [self readCompoundCurveWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_CURVEPOLYGON:
                geometry = [self readCurvePolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_CURVE:
                [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_SURFACE:
                [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
            case SF_POLYHEDRALSURFACE:
                geometry = [self readPolyhedralSurfaceWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_TIN:
                geometry = [self readTINWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_TRIANGLE:
                geometry = [self readTriangleWithFilter:filter andHasZ:hasZ andHasM:hasM];
                break;
            case SF_NONE:
            default:
                [NSException raise:@"Unsupported Geometry" format:@"Geometry Type not supported: %@", [SFGeometryTypes name:geometryType]];
        }
        
        if(![SFWTGeometryReader filter:filter geometry:geometry inType:containingType]){
            geometry = nil;
        }
        
        // If there is an expected type, verify the geometry is of that type
        if (expectedType != nil && geometry != nil && ![geometry isKindOfClass:expectedType]){
            [NSException raise:@"Unexpected Geometry" format:@"Unexpected Geometry Type. Expected: %@, Actual: %@", expectedType, [geometry class]];
        }
        
    }
    
    return geometry;
}

-(SFWTGeometryTypeInfo *) readGeometryType{
    
    SFWTGeometryTypeInfo *geometryInfo = nil;
    
    // Read the geometry type
    NSString *geometryTypeValue = [_reader readToken];
    
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
            NSString *next = [_reader peekToken];
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
                [_reader readToken];
            }

        }

        geometryInfo = [[SFWTGeometryTypeInfo alloc] initWithType:geometryType andHasZ:hasZ andHasM:hasM];
        
    }
    
    return geometryInfo;
}

-(SFPoint *) readPointTextWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{

    SFPoint *point = nil;
    
    if([self leftParenthesisOrEmpty]){
        point = [self readPointWithHasZ:hasZ andHasM:hasM];
        [self rightParenthesis];
    }
    
    return point;
}

-(SFPoint *) readPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    double x = [_reader readDouble];
    double y = [_reader readDouble];
    
    SFPoint *point = [SFPoint pointWithHasZ:hasZ andHasM:hasM andXValue:x andYValue:y];
    
    if(hasZ || hasM){
        if(hasZ){
            [point setZValue:[_reader readDouble]];
        }
        
        if(hasM){
            [point setMValue:[_reader readDouble]];
        }
    } else if(![self isCommaOrRightParenthesis]){
        
        [point setZValue:[_reader readDouble]];
        
        if(![self isCommaOrRightParenthesis]){
            
            [point setMValue:[_reader readDouble]];
            
        }
        
    }
    
    return point;
}

-(SFLineString *) readLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readLineStringWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFLineString *) readLineStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFLineString *lineString = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        lineString = [SFLineString lineStringWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPoint *point = [self readPointWithHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:point inType:SF_LINESTRING]){
                [lineString addPoint:point];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return lineString;
}

-(SFPolygon *) readPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolygonWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFPolygon *) readPolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolygon *polygon = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        polygon = [SFPolygon polygonWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *ring = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:ring inType:SF_POLYGON]){
                [polygon addRing:ring];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return polygon;
}

-(SFMultiPoint *) readMultiPointWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPointWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFMultiPoint *) readMultiPointWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPoint *multiPoint = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        multiPoint = [SFMultiPoint multiPointWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPoint *point = nil;
            if([self isLeftParenthesisOrEmpty]){
                point = [self readPointTextWithHasZ:hasZ andHasM:hasM];
            }else{
                point = [self readPointWithHasZ:hasZ andHasM:hasM];
            }
            if([SFWTGeometryReader filter:filter geometry:point inType:SF_MULTIPOINT]){
                [multiPoint addPoint:point];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return multiPoint;
}

-(SFMultiLineString *) readMultiLineStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiLineStringWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFMultiLineString *) readMultiLineStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiLineString *multiLineString = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        multiLineString = [SFMultiLineString multiLineStringWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *lineString = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:lineString inType:SF_MULTILINESTRING]){
                [multiLineString addLineString:lineString];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return multiLineString;
}

-(SFMultiPolygon *) readMultiPolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readMultiPolygonWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFMultiPolygon *) readMultiPolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFMultiPolygon *multiPolygon = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        multiPolygon = [SFMultiPolygon multiPolygonWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPolygon *polygon = [self readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:polygon inType:SF_MULTIPOLYGON]){
                [multiPolygon addPolygon:polygon];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return multiPolygon;
}

-(SFGeometryCollection *) readGeometryCollectionWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readGeometryCollectionWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFGeometryCollection *) readGeometryCollectionWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *geometryCollection = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        geometryCollection = [SFGeometryCollection geometryCollectionWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFGeometry *geometry = [self readWithFilter:filter inType:SF_GEOMETRYCOLLECTION andExpectedType:[SFGeometry class]];
            if(geometry != nil){
                [geometryCollection addGeometry:geometry];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return geometryCollection;
}

-(SFGeometryCollection *) readMultiCurveWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
     
     SFGeometryCollection *multiCurve = nil;
     
     if([self leftParenthesisOrEmpty]){
         
         multiCurve = [SFGeometryCollection geometryCollectionWithHasZ:hasZ andHasM:hasM];
         
         do {
             SFCurve *curve = nil;
             if([self isLeftParenthesisOrEmpty]){
                 curve = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
                 if(![SFWTGeometryReader filter:filter geometry:curve inType:SF_MULTICURVE]){
                     curve = nil;
                 }
             }else{
                 curve = (SFCurve *)[self readWithFilter:filter inType:SF_MULTICURVE andExpectedType:[SFCurve class]];
             }
             if(curve != nil){
                 [multiCurve addGeometry:curve];
             }
         } while ([self commaOrRightParenthesis]);
         
     }
     
     return multiCurve;
 }

-(SFGeometryCollection *) readMultiSurfaceWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFGeometryCollection *multiSurface = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        multiSurface = [SFGeometryCollection geometryCollectionWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFSurface *surface = nil;
            if([self isLeftParenthesisOrEmpty]){
                surface = [self readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
                if(![SFWTGeometryReader filter:filter geometry:surface inType:SF_MULTISURFACE]){
                    surface = nil;
                }
            }else{
                surface = (SFSurface *)[self readWithFilter:filter inType:SF_MULTISURFACE andExpectedType:[SFSurface class]];
            }
            if(surface != nil){
                [multiSurface addGeometry:surface];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return multiSurface;
}

-(SFCircularString *) readCircularStringWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCircularStringWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFCircularString *) readCircularStringWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCircularString *circularString = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        circularString = [SFCircularString circularStringWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPoint *point = [self readPointWithHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:point inType:SF_CIRCULARSTRING]){
                [circularString addPoint:point];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return circularString;
}

-(SFCompoundCurve *) readCompoundCurveWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCompoundCurveWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFCompoundCurve *) readCompoundCurveWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCompoundCurve *compoundCurve = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        compoundCurve = [SFCompoundCurve compoundCurveWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *lineString = nil;
            if([self isLeftParenthesisOrEmpty]){
                lineString = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
                if(![SFWTGeometryReader filter:filter geometry:lineString inType:SF_COMPOUNDCURVE]){
                    lineString = nil;
                }
            }else{
                lineString = (SFLineString *)[self readWithFilter:filter inType:SF_COMPOUNDCURVE andExpectedType:[SFLineString class]];
            }
            if(lineString != nil){
                [compoundCurve addLineString:lineString];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return compoundCurve;
}

-(SFCurvePolygon *) readCurvePolygonWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readCurvePolygonWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFCurvePolygon *) readCurvePolygonWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFCurvePolygon *curvePolygon = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        curvePolygon = [SFCurvePolygon curvePolygonWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFCurve *ring = nil;
            if([self isLeftParenthesisOrEmpty]){
                ring = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
                if(![SFWTGeometryReader filter:filter geometry:ring inType:SF_CURVEPOLYGON]){
                    ring = nil;
                }
            }else{
                ring = (SFCurve *)[self readWithFilter:filter inType:SF_CURVEPOLYGON andExpectedType:[SFCurve class]];
            }
            if(ring != nil){
                [curvePolygon addRing:ring];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return curvePolygon;
}

-(SFPolyhedralSurface *) readPolyhedralSurfaceWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readPolyhedralSurfaceWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFPolyhedralSurface *) readPolyhedralSurfaceWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFPolyhedralSurface *polyhedralSurface = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        polyhedralSurface = [SFPolyhedralSurface polyhedralSurfaceWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPolygon *polygon = [self readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:polygon inType:SF_POLYHEDRALSURFACE]){
                [polyhedralSurface addPolygon:polygon];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return polyhedralSurface;
}

-(SFTIN *) readTINWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTINWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFTIN *) readTINWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTIN *tin = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        tin = [SFTIN tinWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFPolygon *polygon = [self readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:polygon inType:SF_TIN]){
                [tin addPolygon:polygon];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return tin;
}

-(SFTriangle *) readTriangleWithHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    return [self readTriangleWithFilter:nil andHasZ:hasZ andHasM:hasM];
}

-(SFTriangle *) readTriangleWithFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    
    SFTriangle *triangle = nil;
    
    if([self leftParenthesisOrEmpty]){
        
        triangle = [SFTriangle triangleWithHasZ:hasZ andHasM:hasM];
        
        do {
            SFLineString *ring = [self readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
            if([SFWTGeometryReader filter:filter geometry:ring inType:SF_TRIANGLE]){
                [triangle addRing:ring];
            }
        } while ([self commaOrRightParenthesis]);
        
    }
    
    return triangle;
}

/**
 * Read a left parenthesis or empty set
 *
 * @return true if not empty
 */
-(BOOL) leftParenthesisOrEmpty{
    return [SFWTGeometryReader leftParenthesisOrEmpty:_reader];
}

/**
 * Read a comma or right parenthesis
 *
 * @return true if a comma
 */
-(BOOL) commaOrRightParenthesis{
    return [SFWTGeometryReader commaOrRightParenthesis:_reader];
}

/**
 * Read a right parenthesis
 */
-(void) rightParenthesis{
    return [SFWTGeometryReader rightParenthesis:_reader];
}

/**
 * Determine if the next token is either a left parenthesis or empty
 *
 * @return true if a left parenthesis or empty
 */
-(BOOL) isLeftParenthesisOrEmpty{
    return [SFWTGeometryReader isLeftParenthesisOrEmpty:_reader];
}

/**
 * Determine if the next token is either a comma or right parenthesis
 *
 * @return true if a comma
 */
-(BOOL) isCommaOrRightParenthesis{
    return [SFWTGeometryReader isCommaOrRightParenthesis:_reader];
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
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readWithFilter:filter inType:containingType andExpectedType:expectedType];
}

+(SFWTGeometryTypeInfo *) readGeometryTypeWithReader: (SFTextReader *) reader{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readGeometryType];
}

+(SFPoint *) readPointTextWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPointTextWithHasZ:hasZ andHasM:hasM];
}

+(SFPoint *) readPointWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPointWithHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) readLineStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readLineStringWithHasZ:hasZ andHasM:hasM];
}

+(SFLineString *) readLineStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) readPolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolygonWithHasZ:hasZ andHasM:hasM];
}

+(SFPolygon *) readPolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) readMultiPointWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPointWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiPoint *) readMultiPointWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPointWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiLineStringWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiLineString *) readMultiLineStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiLineStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPolygonWithHasZ:hasZ andHasM:hasM];
}

+(SFMultiPolygon *) readMultiPolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiPolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readGeometryCollectionWithHasZ:hasZ andHasM:hasM];
}

+(SFGeometryCollection *) readGeometryCollectionWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readGeometryCollectionWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

 +(SFGeometryCollection *) readMultiCurveWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
     SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
     return [geometryReader readMultiCurveWithFilter:filter andHasZ:hasZ andHasM:hasM];
 }

+(SFGeometryCollection *) readMultiSurfaceWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readMultiSurfaceWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) readCircularStringWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCircularStringWithHasZ:hasZ andHasM:hasM];
}

+(SFCircularString *) readCircularStringWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCircularStringWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCompoundCurveWithHasZ:hasZ andHasM:hasM];
}

+(SFCompoundCurve *) readCompoundCurveWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCompoundCurveWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCurvePolygonWithHasZ:hasZ andHasM:hasM];
}

+(SFCurvePolygon *) readCurvePolygonWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readCurvePolygonWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolyhedralSurfaceWithHasZ:hasZ andHasM:hasM];
}

+(SFPolyhedralSurface *) readPolyhedralSurfaceWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readPolyhedralSurfaceWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) readTINWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTINWithHasZ:hasZ andHasM:hasM];
}

+(SFTIN *) readTINWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTINWithFilter:filter andHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) readTriangleWithReader: (SFTextReader *) reader andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTriangleWithHasZ:hasZ andHasM:hasM];
}

+(SFTriangle *) readTriangleWithReader: (SFTextReader *) reader andFilter: (NSObject<SFGeometryFilter> *) filter andHasZ: (BOOL) hasZ andHasM: (BOOL) hasM{
    SFWTGeometryReader *geometryReader = [[SFWTGeometryReader alloc] initWithReader:reader];
    return [geometryReader readTriangleWithFilter:filter andHasZ:hasZ andHasM:hasM];
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
