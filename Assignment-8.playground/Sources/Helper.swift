import Foundation

public func task(for number: Int, exercise: String, action: () -> Void) {
    print("ამოცანა N\(number): \(exercise)")
    print("------------------------------")
    action()
    print("\n")
    print()
}
