//
//  ContentView.swift
//  cairongquan
//
//  Created by Macintosh HD on 2023/7/15.
//

import SwiftUI

struct NewsObject: Decodable {
  let items: [NewItem]
  struct NewItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let created_at: Double
    let cover: String
  }
}

struct ContentView: View {
  @State private var newsData: Data?
  @State private var newsArray: [NewsObject.NewItem]?

  func getNewsData() {
    let requireNewsUrl = URL(string: "https://opser.api.dgtle.com/v2/news/index")!
    let session = URLSession.shared
    let request = URLRequest(url: requireNewsUrl)

    let task = session.dataTask(with: request as URLRequest) { data, _, _ in
      if data != nil {
        newsData = data
      }
    }
    task.resume()
  }

  var body: some View {
    List {
      if let newsArray = self.newsArray {
        ForEach(newsArray, id: \.id) { newsItem in
          HStack(spacing: 10.0) {
            AsyncImage(url: URL(string: newsItem.cover)) { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
            } placeholder: {
              ProgressView()
            }
            .frame(width: 60, height: 60, alignment: .center)
            .cornerRadius(10)

            VStack(alignment: .leading, spacing: 10.0) {
              Text(newsItem.title)
                .font(.headline)
                .lineLimit(2)
              Text(Date(timeIntervalSince1970: newsItem.created_at).formatted())
                .foregroundColor(.gray)
                .font(.body)
            }
          }
        }
      } else {
        Text("网络请求错误")
      }
    }
    .refreshable {
      getNewsData()
    }
    .onAppear {
      getNewsData()
    }
    .onChange(of: newsData) { newData in
      if let news = try? JSONDecoder().decode(NewsObject.self, from: newData ?? Data()) {
        DispatchQueue.main.async {
          newsArray = news.items
        }
      } else {
        print("JSON Parse Error!")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
