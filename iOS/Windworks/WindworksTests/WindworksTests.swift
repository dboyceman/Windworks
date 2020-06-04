//
//  LessonTests.swift
//  LessonTests
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import XCTest
@testable import Lesson

class LessonTests: XCTestCase {
    
    //MARK: Lesson Class Tests
    
    // Confirm that the Lesson initializer returns a Lesson object when passed valid parameters.
    func testLessonInitializationSucceeds() {
        
        let lession = Lesson.init(name: "Zero", photo: nil)
        XCTAssertNotNil(lesson)
    }
    
    // Confirm that the Lesson initialier returns nil when pased an empty name.
    func testLessonInitializationFails() {
        
        // Empty String
        let emptyStringLesson = Lesson.init(name: "", photo: nil)
        XCTAssertNil(emptyStringLesson)
        
    }
}
