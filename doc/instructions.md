# Setup instructions (Azure Portal)

- Create Azure **resource group**, **storage account**, **cognitive search**, and **cognitive service (all-in-one)** to the same Azure region (e.g. East US)
  - For the rest of the instructions, the following names mapping will be assumed

| Resource                    | Name       |
|-----------------------------|------------|
| Resource group              | akm-rg     |
| Storage account (GPv2, LRS) | akmsa      |
| Cognitive Search (F)        | akm-search |
| Cognitive Service (S0)      | akm-cogsrv |

- Navigate to storage account -> **Storage Explorer (preview)**
  - Right click **BLOB CONTAINERS** -> **Create blob container** -> create a container named **raw** with **Private** access level (this will be the landing zone for raw data)
  - Repeat above step to create a new container named **enriched** (this will contain AI-enriched data and metadata from raw container)
  - Click **raw** container under **BLOB CONTAINERS** -> click **Upload** -> upload data from `./data` to **raw** container (enable **overwrite if files already exist**)
  - TODO: storage explorer (preview) does NOT support upload of folders for neither blob nor ADLSG2

- Create data source, index, and indexer in Azure Cognitive Search
  - Navigate to Azure Cognitive Search resource -> **Import data**
  - From **Data Source** dropdown, choose **Azure Blob Storage** and input the below values to the form -> **Next: Add cognitive skills (Optional)**

| Field name        | Value                |
|-------------------|----------------------|
| Data source name  | ds-blob-collateral   |
| Data to extract   | Content and metadata |
| Parsing mode      | Default              |
| Connection string | <sanitized>          |
| Container name    | raw                  |
| Blob folder       | travel_collateral/   |

  - Expand **Attach Cognitive Services** -> choose **akm-cogsrv** -> expand **Add enrichments** -> input below values to the form

| Field name                       | Value                          |
|----------------------------------|--------------------------------|
| Skillset name                    | ss-blob-collateral             |
| Enable OCR and merge all text... | Enable                         |
| Source data field                | merged_content                 |
| Enrichment granularity level     | Pages (5000 characters chunks) |
| Text Cognitive Skills            | Select all (except for PII)    |
| Image Cognitive Skills           | Select all                     |

  - Expand **Save enrichments to a knowledge store (Preview)** -> enable **Azure blob projections** -> input **Storage account connection string** with the connection string for storage account **akmsa** -> **Next: Customize target index**

  - Change **Index name** to **ix-blob-collateral** -> enable **Retrievable**, **Filterable**, **Sortable**, **Facetable**, **Searchable** for all fields (for demo purposes) -> **Next: Create an indexer**

  - Change **Name** to **ixer-blob-collateral** -> **Submit**

  - Navigate to **Search explorer** -> click **Search** -> explore enriched document

  - Navigate to storage account -> **Storage Explorer (preview)** -> expand **BLOB CONTAINERS** -> select **enriched** container -> examine files outputed by knowledge store