# Autotransparent

Trying to assess the transparency of research of a field or institution.

The folders are structured as follows:
- `Institutions` is where you'll find approaches to mapping institutional tranpsarency and code that may be more specific to those
-- `karolinska` has an in depth mapping of the institutional publications
- `Fields` is where you'll find my previous attempts in mapping specific fields.

To get the original raw data for a specific institution you use PubMed and perform a search with the filter `(pubmed pmc open access[filter])` before the query. Then you search `X[Affiliation]`. You then proceed in getting the output from PubMed as a `.csv` file which is needed to get the PMCs for downloading the data.

The autotransparent.R file runs the regex to get the transparency assessment, whilst the jupyter notebooks are just used to shape the data into more workable dataframes and summaries.

You can obviouslyt use this approach to any PubMed search to get the same information.




 
