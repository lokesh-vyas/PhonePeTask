//
//  TopHeadlineModel.swift
//  MachineTest
//
//  Created by Lokesh Vyas on 10/03/22.
//

import Foundation

// MARK: - TopHeadline
struct TopHeadline: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: TopHeadline convenience initializers and mutators

extension TopHeadline {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TopHeadline.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        status: String? = nil,
        totalResults: Int? = nil,
        articles: [Article]? = nil
    ) -> TopHeadline {
        return TopHeadline(
            status: status ?? self.status,
            totalResults: totalResults ?? self.totalResults,
            articles: articles ?? self.articles
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription
        case url, urlToImage, publishedAt, content
    }
}

// MARK: Article convenience initializers and mutators

extension Article {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Article.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        source: Source? = nil,
        author: String?? = nil,
        title: String? = nil,
        articleDescription: String?? = nil,
        url: String? = nil,
        urlToImage: String?? = nil,
        publishedAt: Date? = nil,
        content: String?? = nil
    ) -> Article {
        return Article(
            source: source ?? self.source,
            author: author ?? self.author,
            title: title ?? self.title,
            articleDescription: articleDescription ?? self.articleDescription,
            url: url ?? self.url,
            urlToImage: urlToImage ?? self.urlToImage,
            publishedAt: publishedAt ?? self.publishedAt,
            content: content ?? self.content
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

// MARK: Source convenience initializers and mutators

extension Source {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Source.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        name: String? = nil
    ) -> Source {
        return Source(
            id: id ?? self.id,
            name: name ?? self.name
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
