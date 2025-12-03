import Foundation
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

// MARK: - Additional Tests

@Suite("CSS Format")
struct CSSTests {
    @Test("CSS output for opaque color")
    func cssOpaque() {
        #expect(Color.red.css == "rgb(255, 0, 0)")
        #expect(Color.blue.css == "rgb(0, 0, 255)")
    }

    @Test("CSS output with alpha")
    func cssWithAlpha() {
        let color = Color.red.withAlpha(0.5)
        #expect(color.css.contains("rgba"))
        #expect(color.css.contains("0.50"))
    }

    @Test("Parse CSS rgb()")
    func parseRGB() {
        let color = Color(css: "rgb(255, 128, 0)")
        #expect(color?.red == 1.0)
        #expect(abs((color?.green ?? 0) - 0.502) < 0.01)
        #expect(color?.blue == 0.0)
    }

    @Test("Parse CSS rgba()")
    func parseRGBA() {
        let color = Color(css: "rgba(255, 0, 0, 0.5)")
        #expect(color?.red == 1.0)
        #expect(abs((color?.alpha ?? 0) - 0.5) < 0.01)
    }

    @Test("Parse CSS with spaces")
    func parseWithSpaces() {
        let color = Color(css: "  rgb( 255 , 0 , 0 )  ")
        #expect(color != nil)
        #expect(color?.red == 1.0)
    }

    @Test("Invalid CSS returns nil")
    func invalidCSS() {
        #expect(Color(css: "not-a-color") == nil)
        #expect(Color(css: "rgb(abc, 0, 0)") == nil)
    }
}

@Suite("Gradients Extended")
struct GradientExtendedTests {
    @Test("Multi-gradient through colors")
    func multiGradient() {
        let colors = Color.red.multiGradient(through: [.yellow, .blue], stepsPerSegment: 5)
        #expect(colors.count == 9) // 5 + 5 - 1 (no duplicate at junction)
    }

    @Test("Gradient with perceptual false")
    func nonPerceptualGradient() {
        let perceptual = Color.red.gradient(to: .blue, steps: 5, perceptual: true)
        let linear = Color.red.gradient(to: .blue, steps: 5, perceptual: false)
        // Both should have 5 colors but potentially different middle values
        #expect(perceptual.count == 5)
        #expect(linear.count == 5)
    }

    @Test("Gradient single step returns self")
    func gradientSingleStep() {
        let colors = Color.red.gradient(to: .blue, steps: 1)
        #expect(colors.count == 1)
        #expect(colors[0].red == 1.0)
    }

    @Test("Tints go toward white")
    func tints() {
        let tints = Color.red.tints(count: 5)
        #expect(tints.count == 5)
        // First should be red
        #expect(tints.first!.red > 0.9)
        // Last should be white
        #expect(tints.last!.red == 1.0)
        #expect(tints.last!.green == 1.0)
        #expect(tints.last!.blue == 1.0)
    }

    @Test("Shades go toward black")
    func shades() {
        let shades = Color.red.shades(count: 5)
        #expect(shades.count == 5)
        // First should be red
        #expect(shades.first!.red > 0.9)
        // Last should be black
        #expect(shades.last!.red == 0.0)
        #expect(shades.last!.green == 0.0)
        #expect(shades.last!.blue == 0.0)
    }

    @Test("Tonal scale")
    func tonalScale() {
        let scale = Color.red.tonalScale(count: 9)
        #expect(scale.count == 9)
        // First should be near black
        #expect(scale.first!.luminance < 0.1)
        // Last should be near white
        #expect(scale.last!.luminance > 0.9)
    }
}

@Suite("Color Harmonies Extended")
struct HarmonyExtendedTests {
    @Test("Tetradic returns four colors")
    func tetradic() {
        let colors = Color.red.tetradic
        #expect(colors.count == 4)
        // First should be the original
        #expect(colors[0].red == 1.0)
    }

    @Test("Split complementary")
    func splitComplementary() {
        let colors = Color.red.splitComplementary
        #expect(colors.count == 3)
        // First is original
        #expect(colors[0].red == 1.0)
    }

    @Test("Analogous default")
    func analogousDefault() {
        let colors = Color.red.analogous()
        #expect(colors.count == 3)
    }

    @Test("Analogous custom count")
    func analogousCustom() {
        let colors = Color.red.analogous(count: 5, angle: 15)
        #expect(colors.count == 5)
    }
}

@Suite("Color Blindness Simulation")
struct ColorBlindnessTests {
    @Test("Protanopia simulation")
    func protanopia() {
        let simulated = Color.red.simulatedProtanopia
        // Red should look more yellowish/brownish
        #expect(simulated.green > 0)
    }

    @Test("Deuteranopia simulation")
    func deuteranopia() {
        let simulated = Color.green.simulatedDeuteranopia
        // Green appears different
        #expect(simulated.red > 0)
    }

    @Test("Tritanopia simulation")
    func tritanopia() {
        let simulated = Color.blue.simulatedTritanopia
        // Blue appears different
        #expect(simulated != Color.blue)
    }

    @Test("White unchanged by simulations")
    func whiteUnchanged() {
        // White should remain approximately white
        let proto = Color.white.simulatedProtanopia
        let deut = Color.white.simulatedDeuteranopia
        let trit = Color.white.simulatedTritanopia
        #expect(proto.red > 0.9)
        #expect(deut.red > 0.9)
        #expect(trit.red > 0.9)
    }
}

@Suite("Blend Modes")
struct BlendModeTests {
    @Test("Multiply darkens")
    func multiply() {
        let result = Color.red.multiply(with: .blue)
        // Red (1,0,0) * Blue (0,0,1) = Black (0,0,0)
        #expect(result.red == 0)
        #expect(result.green == 0)
        #expect(result.blue == 0)
    }

    @Test("Screen lightens")
    func screen() {
        let result = Color.red.screen(with: .blue)
        // Screen produces magenta
        #expect(result.red == 1.0)
        #expect(result.blue == 1.0)
    }

    @Test("Overlay blend")
    func overlay() {
        let result = Color.gray.overlay(with: .red)
        // Overlay should produce a blended result
        #expect(result.red > 0)
    }

    @Test("Multiply with white is identity")
    func multiplyWhite() {
        let result = Color.red.multiply(with: .white)
        #expect(result.red == 1.0)
        #expect(result.green == 0.0)
        #expect(result.blue == 0.0)
    }

    @Test("Screen with black is identity")
    func screenBlack() {
        let result = Color.red.screen(with: .black)
        #expect(result.red == 1.0)
        #expect(result.green == 0.0)
        #expect(result.blue == 0.0)
    }
}

@Suite("Random Colors")
struct RandomColorTests {
    @Test("Random produces valid color")
    func random() {
        let color = Color.random()
        #expect(color.red >= 0 && color.red <= 1)
        #expect(color.green >= 0 && color.green <= 1)
        #expect(color.blue >= 0 && color.blue <= 1)
        #expect(color.alpha == 1.0)
    }

    @Test("Random with custom alpha")
    func randomWithAlpha() {
        let color = Color.random(alpha: 0.5)
        #expect(color.alpha == 0.5)
    }

    @Test("Random with hue")
    func randomWithHue() {
        let color = Color.randomWithHue(0) // red hue
        let hsl = color.hsl
        #expect(hsl.hue < 10 || hsl.hue > 350) // Near 0 degrees
    }

    @Test("Distinct palette produces unique colors")
    func distinctPalette() {
        let colors = Color.distinctPalette(count: 5)
        #expect(colors.count == 5)
        // Check that colors are reasonably different
        for i in 0..<colors.count {
            for j in (i+1)..<colors.count {
                #expect(colors[i] != colors[j])
            }
        }
    }
}

@Suite("Codable & Hashable")
struct CodableHashableTests {
    @Test("Codable round trip")
    func codableRoundTrip() throws {
        let original = Color(r: 0.5, g: 0.25, b: 0.75, a: 0.9)
        let encoded = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Color.self, from: encoded)
        #expect(decoded.red == original.red)
        #expect(decoded.green == original.green)
        #expect(decoded.blue == original.blue)
        #expect(decoded.alpha == original.alpha)
    }

    @Test("Hashable conforms")
    func hashable() {
        // Just test that Color conforms to Hashable and can be used as dictionary key
        var dict: [Color: String] = [:]
        dict[.red] = "red"
        dict[.blue] = "blue"
        #expect(dict.count == 2)
        #expect(dict[.red] == "red")
    }

    @Test("Set with distinct colors")
    func setDedup() {
        var set = Set<Color>()
        set.insert(.red)
        set.insert(.blue)
        set.insert(.green)
        #expect(set.count == 3)
    }
}

@Suite("Edge Cases")
struct EdgeCaseTests {
    @Test("Grayscale conversion")
    func grayscale() {
        let gray = Color.red.grayscale
        #expect(gray.red == gray.green)
        #expect(gray.green == gray.blue)
    }

    @Test("Tint and shade")
    func tintAndShade() {
        let tinted = Color.red.tint(by: 0.5)
        let shaded = Color.red.shade(by: 0.5)
        #expect(tinted.luminance > Color.red.luminance)
        #expect(shaded.luminance < Color.red.luminance)
    }

    @Test("Adjust for accessibility")
    func adjustForAccessibility() {
        let color = Color(hex: "#777777")!
        let adjusted = color.adjustedForAccessibility(on: .white, level: .aa)
        #expect(adjusted != nil)
        #expect(adjusted!.isAccessible(on: .white, level: .aa))
    }

    @Test("Large text accessibility")
    func largeTextAccessibility() {
        // Weaker contrast might pass for large text
        let color = Color(hex: "#888888")!
        let passesNormal = color.isAccessible(on: .white, level: .aa, largeText: false)
        let passesLarge = color.isAccessible(on: .white, level: .aa, largeText: true)
        // Large text has lower requirements
        #expect(passesLarge || !passesNormal)
    }

    @Test("WCAG AAA level")
    func wcagAAA() {
        #expect(Color.black.isAccessible(on: .white, level: .aaa))
        // AAA is stricter than AA
        #expect(WCAGLevel.aaa.normalTextRatio > WCAGLevel.aa.normalTextRatio)
    }

    @Test("Clear color")
    func clearColor() {
        #expect(Color.clear.alpha == 0.0)
    }

    @Test("Description format")
    func description() {
        let desc = Color.red.description
        #expect(desc.contains("Color"))
        #expect(desc.contains("1.0"))
    }

    @Test("Description with alpha")
    func descriptionWithAlpha() {
        let desc = Color.red.withAlpha(0.5).description
        #expect(desc.contains("a:"))
    }
}
