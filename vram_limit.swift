import Foundation
import Metal

func formatBytes(_ bytes: UInt64) -> String {
    let gb = Double(bytes) / 1024 / 1024 / 1024
    return String(format: "%.2f GB", gb)
}

guard let device = MTLCreateSystemDefaultDevice() else {
    fputs("No Metal device found.\n", stderr)
    exit(1)
}

let workingSet = device.recommendedMaxWorkingSetSize
let currentAllocated = UInt64(device.currentAllocatedSize)

print("Metal Device")
print("------------")
print("Name: \(device.name)")
print("Registry ID: \(device.registryID)")
print()

print("GPU Memory")
print("----------")
print("Recommended Max Working Set Size:")
print("  \(formatBytes(workingSet)) (\(workingSet / 1024 / 1024) MB)")
print()

print("Currently Allocated by This Process:")
print("  \(formatBytes(currentAllocated)) (\(currentAllocated / 1024 / 1024) MB)")
print()

#if os(macOS)
if #available(macOS 13.0, *) {
    print("Architecture:")
    print("  Apple Silicon Unified Memory")
    print()
}
#endif

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/sbin/sysctl")
process.arguments = ["iogpu.wired_limit_mb"]

let pipe = Pipe()
process.standardOutput = pipe

do {
    try process.run()
    process.waitUntilExit()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    if let output = String(data: data, encoding: .utf8)?
        .trimmingCharacters(in: .whitespacesAndNewlines) {

        print("iogpu.wired_limit_mb")
        print("---------------------")
        print(output)
    }
} catch {
    print("Could not read iogpu.wired_limit_mb")
}
