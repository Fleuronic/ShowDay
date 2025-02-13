import AppKit
import enum Root.Root

private import struct DrumCorpsAPI.API
private import struct DrumCorpsDatabase.Database
private import struct DrumCorpsService.Service

@objc(Application) final class Application: NSApplication {}

private let delegate = RootApp.Delegate()
Application.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
