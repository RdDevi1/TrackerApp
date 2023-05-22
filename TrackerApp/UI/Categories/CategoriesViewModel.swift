
import Foundation


protocol CategoriesViewModelDelegate: AnyObject {
    func updateCategories()
    func didSelectCategories(category: TrackerCategory)
}

final class CategoriesViewModel {
    // MARK: - Properties
    private let trackerCategoryStore = TrackerCategoryStore()
    
    weak var delegate: CategoriesViewModelDelegate?
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            delegate?.updateCategories()
        }
    }
    
    private(set) var selectedCategory: TrackerCategory? = nil {
        didSet {
            guard let selectedCategory else { return }
            delegate?.didSelectCategories(category: selectedCategory)
        }
    }
    
    init(selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
    }
    
    //    MARK: - Methods
    func loadCategories() {
        categories = getCategoriesFromStore()
    }
    
    func selectCategory(indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
    }
    
    func deleteCategory(_ category: TrackerCategory) {
        do {
            try trackerCategoryStore.deleteCategory(category: category)
            categories = getCategoriesFromStore()
            if category == selectedCategory {
                selectedCategory = nil
            }
        } catch {}
    }
    
    func checkRewriteCategory(with label: String) {
        if categories.contains(where: { $0.label == label }) {
            updateCategory(with: label)
        } else {
            addCategory(with: label)
        }
    }
    
    private func getCategoriesFromStore() -> [TrackerCategory] {
        do {
            let categories = try trackerCategoryStore.categoriesCoreData.map {
                try trackerCategoryStore.makeCategory(from: $0)
            }
            return categories
        } catch  {
            return []
        }
    }
    
    private func addCategory(with label: String) {
        do {
            try trackerCategoryStore.makeCategory(with: label)
            loadCategories()
        } catch {}
    }
    
    private func updateCategory(with label: String) {
        
    }
}

// MARK: - TrackerCategoryStoreDelegate

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func didUpdate() {
        categories = getCategoriesFromStore()
    }
}

