import SwiftUI
import Foundation
import SwiftData

// Function to load the markdown content from the app bundle and return it as LocalizedStringKey
func loadMarkdownFileAsLocalizedString(_ fileName: String) -> LocalizedStringKey {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "md"),
       let markdownContent = try? String(contentsOf: url, encoding: .utf8) {
        return LocalizedStringKey(markdownContent)
    }
    return LocalizedStringKey("Failed to load article.")
}

struct NewsDetailView: View {
    var article: NewsArticle
    @State private var articleContent: LocalizedStringKey = LocalizedStringKey("")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(article.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                
                Text(article.title)
                    .font(.largeTitle)
                    .padding(.top)
                
                // Display the markdown content using LocalizedStringKey
                Text(articleContent) // Displays the loaded markdown content formatted
                    .padding(.top)
                    .font(.body)
            }
            .padding()
            .onAppear {
                loadArticleContent() // Load the markdown content when the view appears
            }
        }
        .navigationTitle(article.title)
    }
    
    private func loadArticleContent() {
        // Load the markdown content as LocalizedStringKey
        articleContent = loadMarkdownFileAsLocalizedString(article.fileName)
    }
}

// Define sample data for use in previews or testing
let sampleArticles = [
    NewsArticle(title: "The Joy of Reading", image: "monster1", fileName: "article1"),
    NewsArticle(title: "Why Books Are Important", image: "monster22", fileName: "article2"),
    NewsArticle(title: "Stories That Inspire", image: "monster33", fileName: "article3")
]

// Use the sample data in the preview
struct FullArticleView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleArticle = sampleArticles[0]
        NavigationView {
            NewsDetailView(article: sampleArticle)
        }
    }
}
