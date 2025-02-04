// Copyright © 2022 Mapbox. All rights reserved.

import XCTest
@testable import MapboxSearch

final class AddressAutofillTests: XCTestCase {
    private var searchEngine: CoreSearchEngineStub!
    private var addressAutofill: AddressAutofill!
    
    override func setUp() {
        super.setUp()
        
        searchEngine = CoreSearchEngineStub(accessToken: "test", location: nil)
        searchEngine.searchResponse = CoreSearchResponseStub.successSample(results: [])
        
        addressAutofill = AddressAutofill(searchEngine: searchEngine)
    }
    
    override func tearDown() {
        super.tearDown()
        
        searchEngine = nil
        addressAutofill = nil
    }
    
    // MARK: - Options for query
    
    func testThatCorrectAcceptedTypesAreUsedForSuggestionsByQuery() {
        addressAutofill.suggestions(for: .init(value: "query")!) { _ in }
        
        let acceptedTypes: [SearchQueryType] = [.country, .region, .postcode, .district, .place, .locality, .neighborhood, .address, .street, .poi]
        
        XCTAssertEqual(searchEngine.searchOptions?.types, acceptedTypes.map { NSNumber(value: $0.coreValue.rawValue) })
    }
    
    func testThatDefaultOptionsArePassedForSuggestionsByQuery() {
        addressAutofill.suggestions(for: .init(value: "query")!) { _ in }
        
        XCTAssertNil(searchEngine.searchOptions?.countries)
        XCTAssertEqual(searchEngine.searchOptions?.language, [Language.default.languageCode])
    }
    
    func testThatCustomOptionsArePassedForSuggestionsByQuery() {
        let countries: [Country] = [
            .init(countryCode: Country.ISO3166_1_alpha1.au.rawValue)!,
            .init(countryCode: Country.ISO3166_1_alpha1.ca.rawValue)!,
            .init(countryCode: Country.ISO3166_1_alpha1.de.rawValue)!
        ]
        let language = Language(languageCode: Language.ISO639_1.ja.rawValue)!
        
        let autofillOptions = AddressAutofill.Options(countries: countries, language: language)
        addressAutofill.suggestions(for: .init(value: "query")!, with: autofillOptions) { _ in }
        
        XCTAssertEqual(searchEngine.searchOptions?.countries, countries.map { $0.countryCode })
        XCTAssertEqual(searchEngine.searchOptions?.language, [language.languageCode])
    }
    
    // MARK: - Options for coordinate
    
    func testThatCorrectAcceptedTypesAreUsedForSuggestionsByCoordinate() {
        addressAutofill.suggestions(for: kCLLocationCoordinate2DInvalid) { _ in }
        
        let acceptedTypes: [SearchQueryType] = [.country, .region, .postcode, .district, .place, .locality, .neighborhood, .address, .street, .poi]
        
        XCTAssertEqual(searchEngine.reverseGeocodingOptions?.types, acceptedTypes.map { NSNumber(value: $0.coreValue.rawValue) })
    }
    
    func testThatDefaultOptionsArePassedForSuggestionsByCoordinate() {
        addressAutofill.suggestions(for: kCLLocationCoordinate2DInvalid) { _ in }
        
        XCTAssertNil(searchEngine.reverseGeocodingOptions?.countries)
        XCTAssertEqual(searchEngine.reverseGeocodingOptions?.language, [Language.default.languageCode])
    }
    
    func testThatCustomOptionsArePassedForSuggestionsByCoordinate() {
        let countries: [Country] = [
            .init(countryCode: Country.ISO3166_1_alpha1.au.rawValue)!,
            .init(countryCode: Country.ISO3166_1_alpha1.ca.rawValue)!,
            .init(countryCode: Country.ISO3166_1_alpha1.de.rawValue)!
        ]
        let language = Language(languageCode: Language.ISO639_1.ja.rawValue)!
        
        let autofillOptions = AddressAutofill.Options(countries: countries, language: language)
        addressAutofill.suggestions(for: kCLLocationCoordinate2DInvalid, with: autofillOptions) { _ in }
        
        XCTAssertEqual(searchEngine.reverseGeocodingOptions?.countries, countries.map { $0.countryCode })
        XCTAssertEqual(searchEngine.reverseGeocodingOptions?.language, [language.languageCode])
    }
}
