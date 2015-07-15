

/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/

import XCTest
import Foundation
import UIKit


class SyntaxCheckerTests: XCTestCase {
        
    func testCheckEmail(){
        XCTAssertTrue(SyntaxChecker.checkEmail("feltonjammer@us.ibm.com"), "Good Email")
        XCTAssertFalse(SyntaxChecker.checkEmail("@com"), "Bad Email")
        XCTAssertFalse(SyntaxChecker.checkEmail("sdfsdfgsdfgmail.com"), "Bad Email")
        XCTAssertFalse(SyntaxChecker.checkEmail("gmail.com.com"), "Bad Email")
        XCTAssertFalse(SyntaxChecker.checkEmail(""), "Bad Email")
    }
    
    func testcheckFullName(){
        XCTAssertTrue(SyntaxChecker.checkFullName("Felton Jammer"), "Good Name")
        XCTAssertFalse(SyntaxChecker.checkFullName("F3170n J4MM3r"), "Bad Name")
        XCTAssertFalse(SyntaxChecker.checkFullName("235435"), "Bad Name")
        XCTAssertFalse(SyntaxChecker.checkFullName(""), "Bad Name")
    }
    
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
    
    func testcheckZipCode(){
        XCTAssertTrue(SyntaxChecker.checkZipCode("78702"), "Good Zipcode")
        XCTAssertFalse(SyntaxChecker.checkZipCode("829347234987"), "Bad Zipcode")
        XCTAssertFalse(SyntaxChecker.checkZipCode("dfsd34"), "Bad Zipcode")
        XCTAssertFalse(SyntaxChecker.checkZipCode(""), "Bad zipcode")
    }
    
    func testcheckBio(){
        XCTAssertTrue(SyntaxChecker.checkBio("My name is Felton Jammer"), "Good Bio")
        XCTAssertTrue(SyntaxChecker.checkBio(""), "Good Bio")
        XCTAssertTrue(SyntaxChecker.checkBio("Hello my name is 1@%$^&*#"), "Good Bio")
        XCTAssertFalse(SyntaxChecker.checkBio("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"), "Bad Bio") //31 a's
    }
    
    func testcheckWebsite(){
        XCTAssertTrue(SyntaxChecker.checkWebsite("www.aaaaaaaaaaaaa.com"), "Good Website")
         XCTAssertTrue(SyntaxChecker.checkWebsite(""), "Good Website")
        XCTAssertTrue(SyntaxChecker.checkWebsite("My Blog is on Tumblr"), "Good Website")
        XCTAssertFalse(SyntaxChecker.checkWebsite("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"), "Bad Bio") //31 a's
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