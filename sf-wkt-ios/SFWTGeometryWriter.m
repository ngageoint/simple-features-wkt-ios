//
//  SFWTGeometryWriter.m
//  sf-wkt-ios
//
//  Created by Brian Osborn on 8/4/20.
//  Copyright © 2020 NGA. All rights reserved.
//

#import "SFWTGeometryWriter.h"

@implementation SFWTGeometryWriter

+(NSString *) writeGeometry: (SFGeometry *) geometry{
    NSMutableString *text = [NSMutableString string];
    [self writeGeometry:geometry toString:text];
    return text;
}

+(void) writeGeometry: (SFGeometry *) geometry toString: (NSMutableString *) string{
    
}

+(NSString *) writeWrappedPoint: (SFPoint *) point{
    NSMutableString *text = [NSMutableString string];
    [self writeWrappedPoint:point toString:text];
    return text;
}

+(void) writeWrappedPoint: (SFPoint *) point toString: (NSMutableString *) string{
    
    [string appendString:@"("];
    [self writePoint:point toString:string];
    [string appendString:@")"];
    
}

+(NSString *) writePoint: (SFPoint *) point{
    NSMutableString *text = [NSMutableString string];
    [self writePoint:point toString:text];
    return text;
}

+(void) writePoint: (SFPoint *) point toString: (NSMutableString *) string{
    
    [string appendFormat:@"%f", [point.x doubleValue]];
    [string appendString:@" "];
    [string appendFormat:@"%f", [point.y doubleValue]];
    
    if([point hasZ]){
        [string appendFormat:@" %f", [point.z doubleValue]];
    }
    
    if([point hasM]){
        [string appendFormat:@" %f", [point.m doubleValue]];
    }
    
}

+(NSString *) writeLineString: (SFLineString *) lineString{
    NSMutableString *text = [NSMutableString string];
    [self writeLineString:lineString toString:text];
    return text;
}

+(void) writeLineString: (SFLineString *) lineString toString: (NSMutableString *) string{
    
    if([lineString isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [lineString numPoints]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writePoint:[lineString pointAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writePolygon: (SFPolygon *) polygon{
    NSMutableString *text = [NSMutableString string];
    [self writePolygon:polygon toString:text];
    return text;
}

+(void) writePolygon: (SFPolygon *) polygon toString: (NSMutableString *) string{
    
    if([polygon isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [polygon numRings]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeLineString:[polygon ringAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeMultiPoint: (SFMultiPoint *) multiPoint{
    NSMutableString *text = [NSMutableString string];
    [self writeMultiPoint:multiPoint toString:text];
    return text;
}

+(void) writeMultiPoint: (SFMultiPoint *) multiPoint toString: (NSMutableString *) string{
    
    if([multiPoint isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [multiPoint numPoints]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeWrappedPoint:[multiPoint pointAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeMultiLineString: (SFMultiLineString *) multiLineString{
    NSMutableString *text = [NSMutableString string];
    [self writeMultiLineString:multiLineString toString:text];
    return text;
}

+(void) writeMultiLineString: (SFMultiLineString *) multiLineString toString: (NSMutableString *) string{
    
    if([multiLineString isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [multiLineString numLineStrings]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeLineString:[multiLineString lineStringAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeMultiPolygon: (SFMultiPolygon *) multiPolygon{
    NSMutableString *text = [NSMutableString string];
    [self writeMultiPolygon:multiPolygon toString:text];
    return text;
}

+(void) writeMultiPolygon: (SFMultiPolygon *) multiPolygon toString: (NSMutableString *) string{
    
    if([multiPolygon isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [multiPolygon numPolygons]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writePolygon:[multiPolygon polygonAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeGeometryCollection: (SFGeometryCollection *) geometryCollection{
    NSMutableString *text = [NSMutableString string];
    [self writeGeometryCollection:geometryCollection toString:text];
    return text;
}

+(void) writeGeometryCollection: (SFGeometryCollection *) geometryCollection toString: (NSMutableString *) string{
    
    if([geometryCollection isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [geometryCollection numGeometries]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeGeometry:[geometryCollection geometryAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeCircularString: (SFCircularString *) circularString{
    NSMutableString *text = [NSMutableString string];
    [self writeCircularString:circularString toString:text];
    return text;
}

+(void) writeCircularString: (SFCircularString *) circularString toString: (NSMutableString *) string{
    
    if([circularString isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [circularString numPoints]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writePoint:[circularString pointAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeCompoundCurve: (SFCompoundCurve *) compoundCurve{
    NSMutableString *text = [NSMutableString string];
    [self writeCompoundCurve:compoundCurve toString:text];
    return text;
}

+(void) writeCompoundCurve: (SFCompoundCurve *) compoundCurve toString: (NSMutableString *) string{
    
    if([compoundCurve isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [compoundCurve numLineStrings]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeGeometry:[compoundCurve lineStringAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeCurvePolygon: (SFCurvePolygon *) curvePolygon{
    NSMutableString *text = [NSMutableString string];
    [self writeCurvePolygon:curvePolygon toString:text];
    return text;
}

+(void) writeCurvePolygon: (SFCurvePolygon *) curvePolygon toString: (NSMutableString *) string{
    
    if([curvePolygon isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [curvePolygon numRings]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeGeometry:[curvePolygon ringAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface{
    NSMutableString *text = [NSMutableString string];
    [self writePolyhedralSurface:polyhedralSurface toString:text];
    return text;
}

+(void) writePolyhedralSurface: (SFPolyhedralSurface *) polyhedralSurface toString: (NSMutableString *) string{
    
    if([polyhedralSurface isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [polyhedralSurface numPolygons]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writePolygon:[polyhedralSurface polygonAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeTIN: (SFTIN *) tin{
    NSMutableString *text = [NSMutableString string];
    [self writeTIN:tin toString:text];
    return text;
}

+(void) writeTIN: (SFTIN *) tin toString: (NSMutableString *) string{
    
    if([tin isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [tin numPolygons]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writePolygon:[tin polygonAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
    }
    
}

+(NSString *) writeTriangle: (SFTriangle *) triangle{
    NSMutableString *text = [NSMutableString string];
    [self writeTriangle:triangle toString:text];
    return text;
}

+(void) writeTriangle: (SFTriangle *) triangle toString: (NSMutableString *) string{
    
    if([triangle isEmpty]){
        [self writeEmpty:string];
    }else{
        [string appendString:@"("];
        
        for(int i = 0; i < [triangle numRings]; i++){
            if(i > 0){
                [string appendString:@", "];
            }
            [self writeLineString:[triangle ringAtIndex:i] toString:string];
        }
        
        [string appendString:@")"];
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
