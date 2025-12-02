import Testing
@testable import Color

@Suite("Color Core")
struct ColorCoreTests {
    @Test("RGB initialization")
    func rgbInit() {
        let color = Color(r: 1.0, g: 0.5, b: 0.0)
        #expect(color.red == 1.0)
        #expect(color.green == 0.5)
        #expect(color.blue == 0.0)
        #expect(color.alpha == 1.0)
    }

    @Test("8-bit RGB initialization")
    func rgb8Init() {
        let color = Color(r: 255, g: 128, b: 0)
        #expect(color.red == 1.0)
        #expect(abs(color.green - 0.502) < 0.01)
        #expect(color.blue == 0.0)
    }

    @Test("Clamping values")
    func clamping() {
        let color = Color(r: 1.5, g: -0.5, b: 0.5)
        #expect(color.red == 1.0)
        #expect(color.green == 0.0)
        #expect(color.blue == 0.5)
    }

    @Test("8-bit components")
    func components8Bit() {
        let color = Color(r: 1.0, g: 0.5, b: 0.0)
        #expect(color.red8 == 255)
        #expect(color.green8 == 128)
        #expect(color.blue8 == 0)
    }

    @Test("Static colors")
    func staticColors() {
        #expect(Color.black.hex == "#000000")
        #expect(Color.white.hex == "#FFFFFF")
        #expect(Color.red.hex == "#FF0000")
        #expect(Color.green.hex == "#00FF00")
        #expect(Color.blue.hex == "#0000FF")
    }

    @Test("With alpha")
    func withAlpha() {
        let red = Color.red.withAlpha(0.5)
        #expect(red.alpha == 0.5)
        #expect(red.red == 1.0)
    }
}

@Suite("Hex Parsing")
struct HexTests {
    @Test("6-character hex")
    func hex6() {
        let color = Color(hex: "#FF0000")
        #expect(color?.red == 1.0)
        #expect(color?.green == 0.0)
        #expect(color?.blue == 0.0)
    }

    @Test("3-character shorthand")
    func hex3() {
        let color = Color(hex: "#F00")
        #expect(color?.red == 1.0)
        #expect(color?.green == 0.0)
        #expect(color?.blue == 0.0)
    }

    @Test("8-character with alpha")
    func hex8() {
        let color = Color(hex: "#FF000080")
        #expect(color?.red == 1.0)
        #expect(abs((color?.alpha ?? 0) - 0.502) < 0.01)
    }

    @Test("Without hash prefix")
    func noHash() {
        let color = Color(hex: "FF0000")
        #expect(color?.hex == "#FF0000")
    }

    @Test("0x prefix")
    func zeroX() {
        let color = Color(hex: "0xFF0000")
        #expect(color?.hex == "#FF0000")
    }

    @Test("Invalid hex returns nil")
    func invalid() {
        #expect(Color(hex: "invalid") == nil)
        #expect(Color(hex: "#GG0000") == nil)
        #expect(Color(hex: "#FF") == nil)  // 2 chars is invalid
    }

    @Test("4-character shorthand with alpha")
    func hex4() {
        let color = Color(hex: "#F00F")  // red with full alpha
        #expect(color?.red == 1.0)
        #expect(color?.alpha == 1.0)
    }

    @Test("Hex output")
    func hexOutput() {
        #expect(Color.red.hex == "#FF0000")
        #expect(Color.red.withAlpha(0.5).hex == "#FF000080")
        #expect(Color.red.hexValue == "FF0000")
    }
}

@Suite("HSL Conversion")
struct HSLTests {
    @Test("Red to HSL")
    func redToHSL() {
        let hsl = Color.red.hsl
        #expect(hsl.hue == 0)
        #expect(hsl.saturation == 1.0)
        #expect(hsl.lightness == 0.5)
    }

    @Test("HSL to Color")
    func hslToColor() {
        let color = Color(h: 0, s: 1, l: 0.5)
        #expect(abs(color.red - 1.0) < 0.01)
        #expect(abs(color.green) < 0.01)
        #expect(abs(color.blue) < 0.01)
    }

    @Test("Gray has zero saturation")
    func grayHSL() {
        let hsl = Color.gray.hsl
        #expect(hsl.saturation == 0)
    }
}

@Suite("HSV Conversion")
struct HSVTests {
    @Test("Red to HSV")
    func redToHSV() {
        let hsv = Color.red.hsv
        #expect(hsv.hue == 0)
        #expect(hsv.saturation == 1.0)
        #expect(hsv.value == 1.0)
    }

    @Test("HSV to Color")
    func hsvToColor() {
        let color = Color(h: 0, s: 1, v: 1)
        #expect(abs(color.red - 1.0) < 0.01)
    }
}

@Suite("Manipulation")
struct ManipulationTests {
    @Test("Lighten")
    func lighten() {
        let light = Color.red.lighten(by: 0.2)
        #expect(light.hsl.lightness > Color.red.hsl.lightness)
    }

    @Test("Darken")
    func darken() {
        let dark = Color.red.darken(by: 0.2)
        #expect(dark.hsl.lightness < Color.red.hsl.lightness)
    }

    @Test("Saturate")
    func saturate() {
        let muted = Color(h: 0, s: 0.5, l: 0.5)
        let vivid = muted.saturate(by: 0.3)
        #expect(vivid.hsl.saturation > muted.hsl.saturation)
    }

    @Test("Desaturate")
    func desaturate() {
        let muted = Color.red.desaturate(by: 0.3)
        #expect(muted.hsl.saturation < Color.red.hsl.saturation)
    }

    @Test("Invert")
    func invert() {
        let inverted = Color.red.inverted
        #expect(inverted.red == 0)
        #expect(inverted.green == 1.0)
        #expect(inverted.blue == 1.0)
    }

    @Test("Complement")
    func complement() {
        let comp = Color.red.complement
        #expect(abs(comp.hsl.hue - 180) < 1)
    }

    @Test("Mix")
    func mix() {
        let purple = Color.red.mix(with: .blue, ratio: 0.5)
        #expect(abs(purple.red - 0.5) < 0.01)
        #expect(abs(purple.blue - 0.5) < 0.01)
    }

    @Test("Adjust hue")
    func adjustHue() {
        let green = Color.red.adjustHue(by: 120)
        #expect(abs(green.hsl.hue - 120) < 1)
    }
}

@Suite("Accessibility")
struct AccessibilityTests {
    @Test("Luminance")
    func luminance() {
        #expect(Color.white.luminance == 1.0)
        #expect(Color.black.luminance == 0.0)
        #expect(Color.red.luminance > 0 && Color.red.luminance < 1)
    }

    @Test("Contrast ratio")
    func contrastRatio() {
        let ratio = Color.black.contrastRatio(with: .white)
        #expect(abs(ratio - 21.0) < 0.1)
    }

    @Test("WCAG AA check")
    func wcagAA() {
        #expect(Color.black.isAccessible(on: .white, level: .aa))
        #expect(!Color(hex: "#777777")!.isAccessible(on: .white, level: .aa))
    }

    @Test("Contrasting text color")
    func contrastingText() {
        #expect(Color.white.contrastingTextColor == .black)
        #expect(Color.black.contrastingTextColor == .white)
    }
}

@Suite("LAB Color Space")
struct LABTests {
    @Test("RGB to LAB")
    func rgbToLAB() {
        let lab = Color.red.lab
        #expect(lab.lightness > 50)
        #expect(lab.a > 0)  // Red is positive on a axis
    }

    @Test("LAB round trip")
    func labRoundTrip() {
        let original = Color.red
        let lab = original.lab
        let restored = Color(lab: lab)
        #expect(abs(original.red - restored.red) < 0.01)
        #expect(abs(original.green - restored.green) < 0.01)
        #expect(abs(original.blue - restored.blue) < 0.01)
    }

    @Test("Delta E")
    func deltaE() {
        let de = Color.red.deltaE(from: .blue)
        #expect(de > 100)  // Very different colors

        let smallDE = Color.red.deltaE(from: Color.red.lighten(by: 0.01))
        #expect(smallDE < 10)  // Similar colors
    }
}

@Suite("Palettes")
struct PaletteTests {
    @Test("Complementary")
    func complementary() {
        let colors = Color.red.complementary
        #expect(colors.count == 2)
    }

    @Test("Triadic")
    func triadic() {
        let colors = Color.red.triadic
        #expect(colors.count == 3)
    }

    @Test("Gradient")
    func gradient() {
        let colors = Color.red.gradient(to: .blue, steps: 5)
        #expect(colors.count == 5)
        // Check first color is approximately red (LAB interpolation may have small variations)
        #expect(colors.first!.red > 0.9)
        #expect(colors.first!.blue < 0.1)
    }

    @Test("Distinct palette")
    func distinctPalette() {
        let colors = Color.distinctPalette(count: 10)
        #expect(colors.count == 10)
    }
}

@Suite("Named Colors")
struct NamedColorTests {
    @Test("Named color creation")
    func namedColor() {
        let coral = Color.named(.coral)
        #expect(coral.hex == "#FF7F50")
    }

    @Test("Name string lookup")
    func nameString() {
        let coral = Color(name: "coral")
        #expect(coral?.hex == "#FF7F50")
    }

    @Test("Case insensitive")
    func caseInsensitive() {
        let coral = Color(name: "CORAL")
        #expect(coral?.hex == "#FF7F50")
    }

    @Test("Invalid name returns nil")
    func invalidName() {
        #expect(Color(name: "notacolor") == nil)
    }

    @Test("All named colors have values")
    func allNamed() {
        for named in NamedColor.allCases {
            #expect(Color(hex: named.hex) != nil)
        }
    }
}
