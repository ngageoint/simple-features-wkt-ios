//
//  SFWTGeometryWriter.m
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTGeometryWriter.h"

@interface SFWTGeometryWriter()

/**
 * Text
 */
@property (nonatomic, strong) NSMutableString *text;

@end

@implementation SFWTGeometryWriter

static double DECIMAL_NUMBER_INFINITY;
static double DECIMAL_NUMBER_NEGATIVE_INFINITY;

+(void) initialize{
    DECIMAL_NUMBER_INFINITY = [[[NSDecimalNumber alloc] initWithDouble:INFINITY] doubleValue];
    DECIMAL_NUMBER_NEGATIVE_INFINITY = [[[NSDecimalNumber alloc] initWithDouble:-INFINITY] doubleValue];
}

+(NSString *) writeGeometry: (SFGeometry *) geometry{
    SFWTGeometryWriter *writer = [[SFWTGeometryWriter alloc] init];
    [writer write:geometry];
    return writer.text;
}

-(instancetype) init{
    return [self initWithText:[NSMutableString string]];
}

-(instancetype) initWithText: (NSMutableString *) text{
    self = [super init];
    if(self != nil){
        _text = text;
    }
    return self;
}

-(NSMutableString *) text{
    return _text;
}

-(void) write: (SFGeometry *) geometry{
    
    NSString *name = [self name:geometry];
    
    // Write the geometry type
    [_text appendFormat:@"%@ ", name];

    BOOL hasZ = geometry.hasZ;
    BOOL hasM = geometry.hasM;

    if (hasZ || hasM) {
        if (hasZ) {
            [_text appendString:@"Z"];
        }
        if (hasM) {
            [_text appendString:@"M"];
        }
        [_text appendString:@" "];
    }
    
    enum SFGeometryType geometryType = geometry.geometryType;
    
    switch (geometryType) {
            
        case SF_GEOMETRY:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POINT:
            [self writeWrappedPoint:(SFPoint *)geometry];
            break;
        case SF_LINESTRING:
            [self writeLineString:(SFLineString *)geometry];
            break;
        case SF_POLYGON:
            [self writePolygon:(SFPolygon *)geometry];
            break;
        case SF_MULTIPOINT:
            [self writeMultiPoint:(SFMultiPoint *)geometry];
            break;
        case SF_MULTILINESTRING:
            [self writeMultiLineString:(SFMultiLineString *)geometry];
            break;
        case SF_MULTIPOLYGON:
            [self writeMultiPolygon:(SFMultiPolygon *)geometry];
            break;
        case SF_GEOMETRYCOLLECTION:
        case SF_MULTICURVE:
        case SF_MULTISURFACE:
            [self writeGeometryCollection:(SFGeometryCollection *)geometry];
            break;
        case SF_CIRCULARSTRING:
            [self writeCircularString:(SFCircularString *)geometry];
            break;
        case SF_COMPOUNDCURVE:
            [self writeCompoundCurve:(SFCompoundCurve *)geometry];
            break;
        case SF_CURVEPOLYGON:
            [self writeCurvePolygon:(SFCurvePolygon *)geometry];
            break;
        case SF_CURVE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_SURFACE:
            [NSException raise:@"Unexpected Geometry Type" format:@"Unexpected Geometry Type of %@ which is abstract", [SFGeometryTypes name:geometryType]];
        case SF_POLYHEDRALSURFACE:
            [self writePolyhedralSurface:(SFPolyhedralSurface *)geometry];
            break;
        case SF_TIN:
            [self writeTIN:(SFTIN *)geometry];
            break;
        case SF_TRIANGLE:
            [self writeTriangle:(SFTriangle *)geometry];
            break;
        default:
            [NSException raise:@"Geometry Not Supported" format:@"Geometry Type not supported: %d", geometryType];
    }
    
}

-(NSString *) name: (SFGeometry *) geometry{
    enum SFGeometryType type = geometry.geometryType;
    if(![geometry isEmpty]){
        switch (type){
            case SF_MULTILINESTRING:
                {
                    SFLineString *lineString = [((SFMultiLineString *) geometry) lineStringAtIndex:0];
                    if([lineString isKindOfClass:[SFCircularString class]]){
                        type = SF_MULTICURVE;
                    }
                }
                break;
            default:
                break;
        }
    }
    return [SFGeometryTypes name:type];
}

-(void) writeWrappedPoint: (SFPoint *) point{
    
    [_text appendString:@"("];
    [self writePoint:point];
    [_text appendString:@")"];
    
}

-(void) writePoint: (SFPoint *) point{

    [self writeValue:point.x];
    [_text appendString:@" "];
    [self writeValue:point.y];
    
    if([point hasZ]){
        [_text appendString:@" "];
        [self writeValue:point.z];
    }
    
    if([point hasM]){
        [_text appendString:@" "];
        [self writeValue:point.m];
    }
    
}

-(void) writeLineString: (SFLineString *) lineString{
    
    if([lineString isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [lineString numPoints]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writePoint:[lineString pointAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writePolygon: (SFPolygon *) polygon{
    
    if([polygon isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [polygon numRings]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writeLineString:[polygon ringAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeMultiPoint: (SFMultiPoint *) multiPoint{
    
    if([multiPoint isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [multiPoint numPoints]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writeWrappedPoint:[multiPoint pointAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeMultiLineString: (SFMultiLineString *) multiLineString{
    
    if([multiLineString isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [multiLineString numLineStrings]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            SFLineString *lineString = [multiLineString lineStringAtIndex:i];
            if([lineString isKindOfClass:[SFCircularString class]]){
                [self write:lineString];
            }else{
                [self writeLineString:lineString];
            }
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon{
    
    if([multiPolygon isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [multiPolygon numPolygons]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writePolygon:[multiPolygon polygonAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection{
    
    if([geometryCollection isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [geometryCollection numGeometries]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self write:[geometryCollection geometryAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeCircularString: (SFCircularString *) circularString{
    
    if([circularString isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [circularString numPoints]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writePoint:[circularString pointAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve{
    
    if([compoundCurve isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [compoundCurve numLineStrings]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self write:[compoundCurve lineStringAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon{
    
    if([curvePolygon isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [curvePolygon numRings]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self write:[curvePolygon ringAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    
    if([polyhedralSurface isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [polyhedralSurface numPolygons]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writePolygon:[polyhedralSurface polygonAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeTIN: (SFTIN *) tin{
    
    if([tin isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [tin numPolygons]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writePolygon:[tin polygonAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

-(void) writeTriangle: (SFTriangle *) triangle{
    
    if([triangle isEmpty]){
        [self writeEmpty];
    }else{
        [_text appendString:@"("];
        
        for(int i = 0; i < [triangle numRings]; i++){
            if(i > 0){
                [_text appendString:@", "];
            }
            [self writeLineString:[triangle ringAtIndex:i]];
        }
        
        [_text appendString:@")"];
    }
    
}

/**
 * Write the value
 *
 * @param value decimal number
 */
-(void) writeValue: (NSDecimalNumber *) value{
    [SFWTGeometryWriter writeValue:value toString:_text];
}

/**
 * Write the empty set
 */
-(void) writeEmpty{
    [SFWTGeometryWriter writeEmpty:_text];
}

+(void) writeGeometry: (SFGeometry *) geometry toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter write:geometry];
}

+(NSString *) writeWrappedPoint: (SFPoint *) point{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeWrappedPoint:point];
    return geometryWriter.text;
}

+(void) writeWrappedPoint: (SFPoint *) point toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeWrappedPoint:point];
}

+(NSString *) writePoint: (SFPoint *) point{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writePoint:point];
    return geometryWriter.text;
}

+(void) writePoint: (SFPoint *) point toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writePoint:point];
}

+(NSString *) writeLineString: (SFLineString *) lineString{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeLineString:lineString];
    return geometryWriter.text;
}

+(void) writeLineString: (SFLineString *) lineString toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeLineString:lineString];
}

+(NSString *) writePolygon: (SFPolygon *) polygon{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writePolygon:polygon];
    return geometryWriter.text;
}

+(void) writePolygon: (SFPolygon *) polygon toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writePolygon:polygon];
}

+(NSString *) writeMultiPoint: (SFMultiPoint *) multiPoint{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeMultiPoint:multiPoint];
    return geometryWriter.text;
}

+(void) writeMultiPoint: (SFMultiPoint *) multiPoint toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeMultiPoint:multiPoint];
}

+(NSString *) writeMultiLineString: (SFMultiLineString *) multiLineString{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeMultiLineString:multiLineString];
    return geometryWriter.text;
}

+(void) writeMultiLineString: (SFMultiLineString *) multiLineString toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeMultiLineString:multiLineString];
}

+(NSString *) writeMultiPolygon: (SFMultiPolygon *) multiPolygon{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeMultiPolygon:multiPolygon];
    return geometryWriter.text;
}

+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeMultiPolygon:multiPolygon];
}

+(NSString *) writeGeometryCollection: (SFGeometryCollection *) geometryCollection{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeGeometryCollection:geometryCollection];
    return geometryWriter.text;
}

+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeGeometryCollection:geometryCollection];
}

+(NSString *) writeCircularString: (SFCircularString *) circularString{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeCircularString:circularString];
    return geometryWriter.text;
}

+(void) writeCircularString: (SFCircularString *) circularString toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeCircularString:circularString];
}

+(NSString *) writeCompoundCurve: (SFCompoundCurve *) compoundCurve{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeCompoundCurve:compoundCurve];
    return geometryWriter.text;
}

+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeCompoundCurve:compoundCurve];
}

+(NSString *) writeCurvePolygon: (SFCurvePolygon *) curvePolygon{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeCurvePolygon:curvePolygon];
    return geometryWriter.text;
}

+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeCurvePolygon:curvePolygon];
}

+(NSString *) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writePolyhedralSurface:polyhedralSurface];
    return geometryWriter.text;
}

+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writePolyhedralSurface:polyhedralSurface];
}

+(NSString *) writeTIN: (SFTIN *) tin{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeTIN:tin];
    return geometryWriter.text;
}

+(void) writeTIN: (SFTIN *) tin toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeTIN:tin];
}

+(NSString *) writeTriangle: (SFTriangle *) triangle{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] init];
    [geometryWriter writeTriangle:triangle];
    return geometryWriter.text;
}

+(void) writeTriangle: (SFTriangle *) triangle toString: (NSMutableString *) string{
    SFWTGeometryWriter *geometryWriter = [[SFWTGeometryWriter alloc] initWithText:string];
    [geometryWriter writeTriangle:triangle];
}

/**
 * Write the value
 *
 * @param value decimal number
 * @param string mutable string
 */
+(void) writeValue: (NSDecimalNumber *) value toString: (NSMutableString *) string{
    if(value == nil){
        [string appendString:@"NaN"];
    }else{
        double doubleValue = [value doubleValue];
        if(isnan(doubleValue)){
            [string appendString:@"NaN"];
        }else if(doubleValue >= DECIMAL_NUMBER_INFINITY){
            [string appendString:@"infinity"];
        }else if(doubleValue <= DECIMAL_NUMBER_NEGATIVE_INFINITY){
            [string appendString:@"-infinity"];
        }else{
            [string appendFormat:@"%@", [NSNumber numberWithDouble:doubleValue]];
        }
    }
}

/**
 * Write the empty set
 *
 * @param string mutable string
 */
+(void) writeEmpty: (NSMutableString *) string{
    [string appendString:@"EMPTY"];
}

@end
