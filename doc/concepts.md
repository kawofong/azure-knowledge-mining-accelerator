# Azure Cognitive Search Concepts

- [Data source](https://docs.microsoft.com/en-us/rest/api/searchservice/create-data-source): provides connection information for [supported Azure data sources](https://docs.microsoft.com/en-us/azure/search/search-indexer-overview#supported-data-sources)

- [Skillsets](https://docs.microsoft.com/en-us/rest/api/searchservice/create-skillset): a collection of [cognitive skills](https://docs.microsoft.com/en-us/azure/search/cognitive-search-predefined-skills) used for natural language processing and other transformations

- [Index](https://docs.microsoft.com/en-us/rest/api/searchservice/Create-Index): logical container of searchable documents, similar to how a table organizes records in a database. Each index is defined by an index schema, suggesters, scoring profiles, and CORS that define its search behaviors.

- [Indexer](https://docs.microsoft.com/en-us/azure/search/search-indexer-overview): a crawler that extracts searchable data and metadata from an external Azure data source and populates an index for full-text search

- [Analyzer](https://docs.microsoft.com/en-us/azure/search/search-analyzers): a component of the full-text search engine that processes text in query strings and indexed documents. An analyzer can consist of char filters, tokenizers, and token filters.
  - [Char filter](https://docs.microsoft.com/en-us/azure/search/index-add-custom-analyzers#char-filters-reference): responsible for replacing certain characters or symbols before tokenization
  - [Tokenizer](https://docs.microsoft.com/en-us/azure/search/index-add-custom-analyzers#tokenizers-reference): responsible for breaking text into tokens
  - [Token filter](https://docs.microsoft.com/en-us/azure/search/index-add-custom-analyzers#token-filters-reference): responsible for modifying tokens created by the tokenizer

- [Synonyms](https://docs.microsoft.com/en-us/azure/search/search-synonyms): associate equivalent terms that implicitly expand the scope of a query, without the user having to actually provide the term. For example, given the term "dog" and synonym associations of "canine" and "puppy"

- [Partition](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#terminology-replicas-and-partitions): Provides index storage and I/O for read/write operations. Each partition has a share of the total index. If you allocate three partitions, your index is divided into thirds.

- [Replica](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#terminology-replicas-and-partitions): Instance of the search service, used primarily to load balance query operations. Each replica is one copy of an index.

# Azure Cognitive Search Features

- [Full-text search](https://docs.microsoft.com/en-us/azure/search/search-lucene-query-architecture)

- [Relevance/Scoring](https://docs.microsoft.com/en-us/azure/search/index-add-scoring-profiles): computes a search score for each item in a rank ordered result set

- Geo-search: Azure Cognitive Search processes, filters, and displays geographic locations. It enables users to explore data based on the proximity of a search result to a physical location

- [Filters](https://docs.microsoft.com/en-us/azure/search/query-odata-filter-orderby-syntax)

- [Facets](https://docs.microsoft.com/en-us/azure/search/search-faceted-navigation): a filtering mechanism that provides self-directed drilldown navigation in search applications

- [Autocomplete](https://docs.microsoft.com/en-us/rest/api/searchservice/autocomplete): helps users issue better search queries by completing partial search terms based on terms from an index

- [Search suggestion](https://docs.microsoft.com/en-us/rest/api/searchservice/suggestions): a "search-as-you-type" query consisting of a partial string input (three character minimum). It returns matching text found in suggester-aware fields

- [Hit highlighting](https://docs.microsoft.com/en-us/rest/api/searchservice/Search-Documents#highlightstring-optional): applies text formatting to matching keywords in search results

- [AI enrichment](https://docs.microsoft.com/en-us/azure/search/cognitive-search-concept-intro): used to extract text from images, blobs, and other unstructured data sources

- [Knowledge Store (preview)](https://docs.microsoft.com/en-us/azure/search/knowledge-store-concept-intro): persists output from an AI enrichment pipeline for independent analysis or downstream processing

- [Incremental enrichment (preview)](https://docs.microsoft.com/en-us/azure/search/cognitive-search-incremental-indexing-conceptual)

- [Create Search App (preview)](https://docs.microsoft.com/en-us/azure/search/search-create-app-portal): generate a downloadable, "localhost"-style search engine that runs in a browser

- [Debug session (preview)](https://docs.microsoft.com/en-us/azure/search/cognitive-search-debug-session): a visual editor that works with an existing skillset in the Azure portal