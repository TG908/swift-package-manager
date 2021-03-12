/*
 This source file is part of the Swift.org open source project

 Copyright (c) 2021 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
 */

/// Provides information about the target being built, as well as contextual
/// information such as the paths of the directories to which commands should
/// be configured to write their outputs. This information should be used as
/// part of generating the commands to be run during the build.
public final class TargetBuildContext: Decodable {
    /// The name of the target being built.
    public let targetName: String

    /// The module name of the target. This is usually derived from the name,
    /// but is possibly be customizable in the package manifest in some future
    /// SwiftPM version).
    public let moduleName: String

    /// The path of the target directory.
    public let targetDir: Path

    /// That path of the package that contains the target.
    public let packageDir: Path

    /// Absolute paths of the source files in the target. This might include
    /// derived source files generated by other plugins).
    public let sourceFiles: [Path]

    /// Absolute paths of the resource files in the target.
    public let resourceFiles: [Path]

    /// Absolute paths of any other files (not sources or resources) in the target.
    public let otherFiles: [Path]

    /// Information about all targets on which the target for which the exten-
    /// sion is being invoked either directly or indirectly depends. This list
    /// is in topologically sorted order, with immediate dependencies appearing
    /// earlier and more distant dependencies later in the list. This is mainly
    /// intended for generating lists of search path arguments, etc.
    public let dependencies: [DependencyTargetInfo]

    /// Provides information about a target on which the target being built depends.
    public struct DependencyTargetInfo: Decodable {
        /// The name of the target.
        public let targetName: String

        /// The module name of the target. This is usually derived from the name,
        /// but is possibly be customizable in the package manifest in some future
        /// SwiftPM version).
        public let moduleName: String

        /// The path of the target directory.
        public let targetDir: Path
    }

    /// The path of an output directory into which files generated by the build
    /// commands that are set up by the package plugin can be written.  The
    /// package plugin itself may also write to this directory.
    public let outputDir: Path

    /// Looks up and returns the path of a named command line executable tool.
    /// The executable must be either in the toolchain or in the system search
    /// path for executables, or be provided by an executable target or binary
    /// target on which the package plugin target depends. Returns nil, but
    /// does not throw an error, if the tool isn't found. Plugins that re-
    /// quire the tool should emit an error diagnostic if it cannot be found.
    public func lookupTool(named name: String) throws -> Path {
        // TODO: Rather than just appending the name, this should instead use
        // a mapping of tool names to paths (passed in from the context).
        return self.toolsDir.appending(name)
    }

    /// A directory in which any built or provided command line tools will be
    /// available to the extension.
    // TODO: This should instead be a mapping of tool names to paths (passed
    // in from the context).
    private let toolsDir: Path
}
