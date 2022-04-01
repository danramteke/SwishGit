import XCTest
import SwishKit
@testable import SwishGit

final class RootTests: XCTestCase {
  
  lazy var testDir = FileManager.default.temporaryDirectory.appendingPathComponent("swish/root-tests")
  
  func testInGitRoot() {
    let git = Git(workingDirectory: testDir.path)
    
#if os(Linux)
    XCTAssertEqual(try git.root(), testDir.path)
#else
    XCTAssertEqual(try git.root(), "/private" + testDir.path)
#endif
  }
  
  func testInSubfolders() {
    let git = Git(workingDirectory: testDir.appendingPathComponent("some/some/folders").path)
#if os(Linux)
    XCTAssertEqual(try git.root(), testDir.path)
#else
    XCTAssertEqual(try git.root(), "/private" + testDir.path)
#endif
  }
  
  func testThrowErrorWhenNotInGitRepo() {
    let git = Git(workingDirectory: "/tmp")
    
    XCTAssertThrowsError(try git.root(), "expected an error") { error in
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
