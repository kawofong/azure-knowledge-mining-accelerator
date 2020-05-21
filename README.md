# Azure Knowledge Mining Solution Accelerator

Solution accelerator for Azure knowledge mining use cases using [Azure Cognitive Search](https://docs.microsoft.com/en-us/azure/search/search-what-is-azure-search).

---

## Getting Started

TODO

WARNING: Please do not commit the Azure secrets to GitHub

## References

- [Azure Cognitive Search concepts and features](./doc/concepts.md)

- [Azure Cognitive Search: Built-in Skills](https://docs.microsoft.com/en-us/azure/search/cognitive-search-predefined-skills)

- [Azure Cognitive Search: Debug sessions](https://docs.microsoft.com/en-us/azure/search/cognitive-search-tutorial-debug-sessions)
  - At the time of writing, the debug sessions feature is in preview. For more information on how to request for this feature, see this [doc](https://docs.microsoft.com/en-us/azure/search/whats-new#may-2020-microsoft-build)

## Demos

- [COVID-19 Medical Research Search](https://covid19search.azurewebsites.net/): Search engine for COVID-19 related research papers

- [Wolters Kluwer](https://wolterskluwereap.azurewebsites.net/): Empowers attorneys to search across Securities and Exchange Commission (SEC) filings and correspondence between public companies and the SEC

- [JFK Files](https://jfk-demo.azurewebsites.net/): Enable people to search through multi-media and handwritten contents related to JFK assassination and explore the relationship between different entites ([video link](https://www.youtube.com/watch?v=XRI0DnjAgmo))

- [Job Portal](https://azjobsdemo.azurewebsites.net/): Enable people to search for NYC jobs based on titles, geo-locations, and salary

## TODO

- Gather data (healthcare research paper, media image, FSI invoice, manufacturing field note)
- build pipeline for each type of data
- Instructions on getting started
- IaC (ARM)
- include suggester in demo
