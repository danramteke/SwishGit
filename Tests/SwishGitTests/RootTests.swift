import XCTest
import SwishKit
@testable import SwishGit

final class RootTests: XCTestCase {
  
  let git = Git()
  
  lazy var testDir = FileManager.default.temporaryDirectory.appendingPathComponent("swish/root-tests")
  
  func testInGitRoot() {
#if os(Linux)
    XCTAssertEqual(try git.root(path: testDir.path), testDir.path)
#else
    XCTAssertEqual(try git.root(path: testDir.path), "/private" + testDir.path)
#endif
  }
  
  func testInSubfolders() {
#if os(Linux)
    XCTAssertEqual(try git.root(path: testDir.appendingPathComponent("some/some/folders").path), testDir.path)
#else
    XCTAssertEqual(try git.root(path: testDir.appendingPathComponent("some/some/folders").path), "/private" + testDir.path)
#endif
  }
  
  func testThrowErrorWhenNotInGitRepo() {
    XCTAssertThrowsError(try git.root(path: "/tmp"), "expected an error") { error in
      if let e = error as? Git.Errors {
        XCTAssertEqual(e, Git.Errors.notGitRepository)
      } else {
        XCTFail("unexpected error: \(error)")
      }
    }
  }
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    
    try FileManager.default.createDirectory(at: testDir.appendingPathComponent("some/some/folders"), withIntermediateDirectories: true)
    try sh(.terminal, "git init -b main", workingDirectory: testDir.absoluteString)
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    
    try FileManager.default.removeItem(at: testDir)
  }
}
