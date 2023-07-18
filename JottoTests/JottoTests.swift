import XCTest
@testable import Jotto

final class JottoTests: XCTestCase {

    func testWordList() throws {
        for count in 4...6 {
            let wordList = WordList.load(count: count)
            XCTAssertNotNil(wordList)
            if count == 4 { XCTAssert(wordList.contains("able")) }
            else if count == 5 { XCTAssert(wordList.contains("gable")) }
            else if count == 6 { XCTAssert(wordList.contains("tables")) }
            for word in wordList.words {
                XCTAssert(word.count == count)
            }
        }
    }
}
