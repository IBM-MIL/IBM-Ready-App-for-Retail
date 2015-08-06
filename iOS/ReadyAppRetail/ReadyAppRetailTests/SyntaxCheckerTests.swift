

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import XCTest
import Foundation
import UIKit


class SyntaxCheckerTests: XCTestCase {
    
    func testcheckPassword(){
        XCTAssertTrue(SyntaxChecker.checkPassword("59$#fkjk&"), "Good Password")
        XCTAssertFalse(SyntaxChecker.checkPassword("][]["), "Bad Password")
        XCTAssertFalse(SyntaxChecker.checkPassword("]sd[f.=-"), "Bad Password")
        XCTAssertFalse(SyntaxChecker.checkPassword("?><+_>()"), "Bad Password")
        
    }
    
    func testcheckUserName(){
        XCTAssertTrue(SyntaxChecker.checkUserName("Felton_Jammer123"), "Good username")
        XCTAssertFalse(SyntaxChecker.checkUserName("F3170n J4MM3r"), "Bad username")
        XCTAssertFalse(SyntaxChecker.checkUserName("@#@$Felton"), "Bad username")
        XCTAssertFalse(SyntaxChecker.checkUserName(""), "Bad username")
    }
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
}