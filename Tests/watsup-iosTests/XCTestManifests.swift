import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(watsup_iosTests.allTests),
    ]
}
#endif
