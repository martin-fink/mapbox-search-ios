import Foundation

/// Default categories for horizontal categories and vertical list.
public class DefaultCategoryDataProvider: CategoryDataProvider {
    /// Minimal count of categories.
    public static let minCategoriesCount = 4
    
    /// Horizontal categories.
    public var categorySlots: [Category] {
        [.gas, .parking, .food, .cafe]
    }
    
    /// Vertical list of categories.
    public var categoryList: [Category] = CategoriesProvider.shared.categories
    
    /// Make your default categories provider.
    public init() { }
}