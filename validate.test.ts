import { describe, it, expect } from "bun:test";
import { readFileSync } from "fs";

describe("swift-color project structure", () => {
  it("has Package.swift", () => {
    const content = readFileSync("Package.swift", "utf-8");
    expect(content).toContain("swift-color");
  });

  it("has source files", () => {
    const content = readFileSync("Sources/Color/Color.swift", "utf-8");
    expect(content).toContain("struct Color");
  });

  it("has test files", () => {
    const content = readFileSync("Tests/ColorTests/ColorTests.swift", "utf-8");
    expect(content).toContain("import Testing");
  });
});
