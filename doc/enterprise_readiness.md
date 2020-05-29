# Enterprise Readiness Checklist

1. Review [Azure Cognitive Search service limits](https://docs.microsoft.com/en-us/azure/search/search-limits-quotas-capacity).

1. Review [guidelines](https://docs.microsoft.com/en-us/azure/search/search-sku-tier) for choosing the right Azure Cognitive Search tier and SKU for your workload.

1. Review [Azure Cognitive Search pricing](https://azure.microsoft.com/en-us/pricing/details/search/). Use [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) to estimate running cost of Azure Cognitive Search and other Azure services.

1. Review definitions of [partitions](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#terminology-replicas-and-partitions) and [replicas](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#terminology-replicas-and-partitions) since they are the scale factors for Azure Cognitive Search. Understand the process for [scaling up/down partition and replica counts](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#how-to-allocate-replicas-and-partitions).

1. Understand how to estimate [replica](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#estimate-replicas) and [partition](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#estimate-partitions) counts.

1. Architect Azure Cognitive Search for [high availability](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#high-availability) and [disaster recovery](https://docs.microsoft.com/en-us/azure/search/search-capacity-planning#disaster-recovery).

1. Review [Azure Cognitive Search security features](https://docs.microsoft.com/en-us/azure/search/search-security-overview) (which includes, but not limited to, [private endpoint](https://docs.microsoft.com/en-us/azure/search/service-create-private-endpoint), encryption in transit, and encryption at rest with Microsoft/customer managed key)

1. Review [monitoring guidelines](https://docs.microsoft.com/en-us/azure/search/search-monitor-usage) for Azure Cognitive Search resource, queries, and indexing.

