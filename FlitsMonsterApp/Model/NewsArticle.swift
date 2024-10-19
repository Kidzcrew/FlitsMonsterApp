import Foundation

struct NewsArticle: Identifiable {
    let id = UUID() // Provides a unique identifier for each article
    let title: String
    let image: String // The image name (stored in Assets.xcassets)
    let fileName: String // The markdown file name without the .md extension
}
