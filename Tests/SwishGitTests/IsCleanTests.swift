import XCTest
import SwishKit
@testable import SwishGit

final class IsCleanTests: XCTestCase {
  
  let git = Git()
  
  lazy var testDir = "/tmp/test-git"
  lazy var testFile = "/tmp/test-git/greeting.txt"
   
  func testStatusOfEmptyGitRepo() throws {
    XCTAssertTrue(try git.isClean(path: testDir))
  }
  
  func testStatusOfDirtyGitRepo() throws {
    try "Hello world!".data(using: .utf8)?.write(to: URL(fileURLWithPath: testFile))
    XCTAssertFalse(try git.isClean(path: testDir))
  }
  
  func testStatusOfCleanGitRepo() throws {
    try "Hello world!".data(using: .utf8)?.write(to: URL(fileURLWithPath: testFile))
    try sh(.terminal, "git add greeting.txt", workingDirectory: testDir)
    try sh(.terminal, "git commit -m \"greeting\"", workingDirectory: testDir)
    XCTAssertTrue(try git.isClean(path: testDir))
  }
  
  func testThrowErrorWhenNotInGitRepo() throws {
    XCTAssertThrowsError(try git.isClean(path: "/tmp"), "expected an error") { error in
      if let e = error as? Git.Errors {
        XCTAssertEqual(e, Git.Errors.notGitRepository)
      } else {
        XCTFail("unexpected error: \(error)")
      }
    }
  }
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    try sh(.terminal, "mkdir -p \(testDir)")
    try sh(.terminal, "git init -b main", workingDirectory: testDir)
    
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    
    try FileManager.default.removeItem(at: URL(fileURLWithPath: testDir))
  }
}
