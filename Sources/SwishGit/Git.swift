import SwishKit
import Foundation

public final class Git {

  public let workingDirectory: String?
  
  public init(workingDirectory: String? = nil) {
    self.workingDirectory = workingDirectory
  }

  /// Return `true` if the git repo is clean, `false` if not
  /// Throws a `notGitRepository` error if the path is not within a git repo
  ///
  public func isClean() throws -> Bool {
  
    let cmd = "git status --porcelain"

    let allOutput = try Process(cmd: cmd, workingDirectory: workingDirectory).runReturningAllOutput()
    let stdOut = allOutput.stdOut?.asTrimmedString(encoding: .utf8)
    let stdErr = allOutput.stdErr?.asTrimmedString(encoding: .utf8)

    if let stdErr = stdErr {
      throw Errors.interpretError(message: stdErr)
    } else {
      if let stdOut = stdOut, !stdOut.isEmpty {
        return false
      } else {
        return true
      }
    }
  }

  /// Returns the path to the root of the Git repo
  /// Throws a `notGitRepository` error if the path is not within a git repo
  public func root() throws -> String {
    let cmd = "git rev-parse --show-toplevel"

    let allOutput = try Process(cmd: cmd, workingDirectory: workingDirectory).runReturningAllOutput()
    let stdOut = allOutput.stdOut?.asTrimmedString(encoding: .utf8)
    let stdErr = allOutput.stdErr?.asTrimmedString(encoding: .utf8)

    if let stdErr = stdErr {
      throw Errors.interpretError(message: stdErr)
    } else if let stdOut = stdOut {
      return stdOut
    } else {
      throw Errors.unknownError
    }
  }

  public enum Errors: String, Error {
    case notGitRepository = "fatal: not a git repository (or any of the parent directories): .git"
    case unknownError

    static func interpretError(message: String) -> Self {
      if let e = Self.init(rawValue: message) {
        return e
      } else {
        return .unknownError
      }
    }
  }
}
