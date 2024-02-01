
import Foundation
import CoreGraphics
import CoreText

public class SmilesFontsManager {
    
    public static var defaultAppFont: SmilesFonts = SmilesFonts.circular
    
    public static func registerFonts() {
        let fonts = getAvailableFontsList()
        fonts.forEach {
            registerFont(bundle: .module, fontName: $0, fontExtension: "ttf")
        }
    }
    
    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {
        
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let font = CGFont(fontDataProvider) else {
                fatalError("Couldn't create font from filename: \(fontName) with extension \(fontExtension)")
        }
        var error: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(font, &error)
        
    }
    
    private static func getAvailableFontsList() -> [String] {
        
        var fonts = [String]()
        let circular: [String] = [SmilesFonts.circular.getFontName(fontStyle: .bold), SmilesFonts.circular.getFontName(fontStyle: .book), SmilesFonts.circular.getFontName(fontStyle: .light), SmilesFonts.circular.getFontName(fontStyle: .medium), SmilesFonts.circular.getFontName(fontStyle: .regular)]
        let lato: [String] = [SmilesFonts.lato.getFontName(fontStyle: .black), SmilesFonts.lato.getFontName(fontStyle: .blackItalic), SmilesFonts.lato.getFontName(fontStyle: .bold), SmilesFonts.lato.getFontName(fontStyle: .boldItalic), SmilesFonts.lato.getFontName(fontStyle: .hairLine), SmilesFonts.lato.getFontName(fontStyle: .italic), SmilesFonts.lato.getFontName(fontStyle: .light), SmilesFonts.lato.getFontName(fontStyle: .lightItalic), SmilesFonts.lato.getFontName(fontStyle: .medium), SmilesFonts.lato.getFontName(fontStyle: .regular), SmilesFonts.lato.getFontName(fontStyle: .semiBold)]
        let montserrat: [String] = [SmilesFonts.montserrat.getFontName(fontStyle: .bold), SmilesFonts.montserrat.getFontName(fontStyle: .extraBold), SmilesFonts.montserrat.getFontName(fontStyle: .medium), SmilesFonts.montserrat.getFontName(fontStyle: .regular), SmilesFonts.montserrat.getFontName(fontStyle: .semiBold)]
        fonts.append(contentsOf: circular)
        fonts.append(contentsOf: lato)
        fonts.append(contentsOf: montserrat)
        return fonts
        
    }
    
}

private class BundleFinder {}
extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static let module: Bundle = {
        let bundleName = "SmilesFontsManager_SmilesFontsManager"

        let overrides: [URL]
        #if DEBUG
        // The 'PACKAGE_RESOURCE_BUNDLE_PATH' name is preferred since the expected value is a path. The
        // check for 'PACKAGE_RESOURCE_BUNDLE_URL' will be removed when all clients have switched over.
        // This removal is tracked by rdar://107766372.
        if let override = ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_PATH"]
                       ?? ProcessInfo.processInfo.environment["PACKAGE_RESOURCE_BUNDLE_URL"] {
            overrides = [URL(fileURLWithPath: override)]
        } else {
            overrides = []
        }
        #else
        overrides = []
        #endif

        let candidates = overrides + [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named SmilesFontsManager_SmilesFontsManager")
    }()
}
