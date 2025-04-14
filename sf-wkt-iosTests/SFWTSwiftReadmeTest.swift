//
//  SFWTSwiftReadmeTest.swift
//  sf-wkt-iosTests
//
//  Created by Brian Osborn on 8/7/20.
//  Copyright © 2020 NGA. All rights reserved.
//

import XCTest
import sf_ios
import sf_wkt_ios
/**
* README example tests
*/
class SFWTSwiftReadmeTest: XCTestCase{
    
    static var TEST_GEOMETRY : SFGeometry = SFPoint(xValue: 1.0, andYValue: 1.0)
    static var TEST_TEXT : String = "POINT (1.0 1.0)"
    
    /**
     * Test read
     */
    func testRead(){
        
        let geometry: SFGeometry = readTester(SFWTSwiftReadmeTest.TEST_TEXT)
        
        SFWTTestUtils.assertEqual(withValue: SFWTSwiftReadmeTest.TEST_GEOMETRY, andValue2: geometry)
        
    }
    
    /**
     * Test read
     *
     * @param text
     *            text
     * @return geometry
     */
    func readTester(_ text: String) -> SFGeometry{
    
        // var text: String = ...
        
        let geometry: SFGeometry = SFWTGeometryReader.readGeometry(withText: text)
//        let geometryType: SFGeometryType = geometry.geometryType
        
        return geometry
    }
    
    /**
     * Test write
     */
    func testWrite(){
        
        let text: String = writeTester(SFWTSwiftReadmeTest.TEST_GEOMETRY)
        
        SFWTGeometryTestUtils.compareText(withExpected: SFWTSwiftReadmeTest.TEST_TEXT, andActual: text)
        
    }
    
    /**
     * Test write
     *
     * @param geometry
     *            geometry
     * @return text
     */
    func writeTester(_ geometry: SFGeometry) -> String{
        
        // let geometry: SFGeometry = ...
        
        let text: String = SFWTGeometryWriter.write(geometry)
        
        return text
    }
    
}
