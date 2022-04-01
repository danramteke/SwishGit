import SwishKit
import Foundation

public final class Git {

  public init() {}

  public func isClean(path: String? = nil) throws -> Bool {
    let allOutput = try Process(cmd: "git status --porcelain", workingDirectory: path).runReturningAllOutput()

    let stdout = allOutput.stdOut?.asTrimmedString(encoding: .utf8)
    let stderr = allOutput.stdErr?.asTrimmedString(encoding: .utf8)
    print("stdout:", stdout ?? "<nil>")
    print("stderr:", stderr ?? "<nil>")
    
    if let stderr = stderr {
      throw Errors.interpretError(message: stderr)
    } else {
      if let stdout = stdout, !stdout.isEmpty {
        return false
      } else {
        return true
      }
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
