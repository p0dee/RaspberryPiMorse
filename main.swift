import Glibc
import SwiftyGPIO

let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPi3)

var gp = gpios[.P17]!
gp.direction = .OUT
gp.value = 1

var flashNumber = 100

enum MorseCode: String {

   case a, b, c, d, e

   func pattern() -> [Int] {
      switch self {
      case .a: return [0, 1]
      case .b: return [1, 0, 0, 0]
      case .c: return [1, 0, 1, 0]     
      case .d: return [1, 0, 0]
      case .e: return [0]
      }
   }

   static func codes(with string: String) -> [MorseCode] {
      return string.map {
         return MorseCode(rawValue: String($0))!
      }
   }
}

let message = "add"
let codes = MorseCode.codes(with: message)
let patterns = codes.map { $0.pattern() }.reduce ([]) { return $0 + $1  }
print(patterns)

patterns.forEach {
  let io = $0 == 1
  
  gp.value = 1
  usleep(io ? 500 * 1000 : 250 * 1000)

  gp.value = 0
  usleep(100 * 1000)
}
