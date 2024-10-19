//
//  NewsOverviewView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 18/10/2024.
//


//
//  NewsOverviewView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 18/10/2024.
//

//
//  NewsOverviewView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 18/10/2024.
//

import SwiftUI
import SwiftData

struct NewsOverviewView: View { // This should match how you call it elsewhere
    var articles: [NewsArticle] = NewsData.newsArticles
    
    var body: some View {
        NavigationView {
            List(articles) { article in
                NavigationLink(destination: NewsDetailView(article: article)) {
                    HStack {
                        Image(article.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipped()
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Nieuws")
        }
    }
}

struct NewsOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewsOverviewView(articles: NewsData.newsArticles) // Ensure this matches the struct name
        }
    }
}

struct NewsCardView: View {
    let article: NewsArticle
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(article.image)
                .resizable()
                .clipped()
                .cornerRadius(10)
            Text(article.title)
                .font(.headline)
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 10)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
