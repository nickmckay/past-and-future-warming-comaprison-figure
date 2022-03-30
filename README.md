This repository contains the code and data needed to reproduce Figure 1 from ****Kaufman, Darrell S. and McKay, Nicholas P, 2022, Technical Note: Past and future warming – Direct comparison on multi-century timescales. Climate of the Past.****. The article is open and [available here](https://cp.copernicus.org/preprints/cp-2021-146/). 

![Figure 1](figures/WarmingTimescale.png)

# Code

The code to reproduce this figure is written in R, and available in `figure1.R`. Several packages are required to run the code, and will need to be installed for the code to run. 


# Data

The time series data in figure 1 are included in data/TemperatureData.xlsx.
The data are available from publicaly accessible sources, and have been modified relative to the 1950-1900 baseline as follows:


## Hansen et al. (2013)

**Data set:** Late Quaternary global temperature according to equations by Hansen et al. (2013) applied to benthic marine oxygen isotope stack of Zachos et al. (2008).

**Available:** http://www.columbia.edu/~mhs119/Sensitivity+SL+CO2/Table.txt (last access: 21 March 2022).

**Modified:** Subtracted 14.15° C to adjust temperature relative to 1961-1990 and added 0.36°C to adjust to 1850-1900 reference period, based on the AR6 assessed four data set mean (Trewin, 2022; GMST-component_data_sets.csv).


## Snyder (2016)

**Data set:** Late Quaternary multi-proxy sea surface temperature stack converted to global temperature by Snyder (2016).

**Available:** https://static-content.springer.com/esm/art%3A10.1038%2Fnature19798/MediaObjects/41586_2016_BFnature19798_MOESM258_ESM.xlsx (last access: 21 March 2022).

**Modified:** Added 0.23° C to adjust late Holocene temperature to the 1850-1900 reference period, based on the reconstruction of Kaufman et al. (2020a).


## Kaufman et al. (2020)

**Data set:**  Holocene multi-method ensemble global temperature of Kaufman et al. (2020b), based on multi-proxy marine and terrestrial paleotemperature data (Temp12k; Kaufman et al., 2020a), using code of Routson et al. (2020).

**Available:** https://www.ncei.noaa.gov/access/paleo-search/study/29712 (Kaufman et al., 2020c; temp12k_allmethods_percentiles).

**Modified:** Subtracted 0.03° C to adjust 19th century mean temperature to 1850-1900 reference period based on PAGES 2k Consortium (2019) 10-year smoothed multi-method reconstruction (Gilbert et al., 2021; SPM1_1-2000.csv).


## Osman et al. (2021)

**Data set:**  Last Glacial Maximum reanalysis (LGMR) of Osman et al. (2021a) based on marine paleotemperature data (Osman et al., 2021b; proxyDatabase.nc) assimilated using climate model (iCESM) priors and code from https://github.com/JonKing93/DASH, v.3.6.1.

**Available:** https://www.ncei.noaa.gov/access/paleo-search/study/33112 (Osman et al., 2021b; LGMR_GMST_ens.nc).

**Modified:** Subtracted 13.49°C (median of the most recent bin) to adjust temperature relative to 1750-1950 and added 0.03° C to adjust to 1850-1900 reference period based on PAGES 2k Consortium (2019) 10-year smoothed multi-method reconstruction (Gilbert et al., 2021; SPM1_1-2000.csv).


## Gulev et al. (2021)

**Data set:**  1850-2020 global temperature of Gulev et al. (2021) based on mean of four instrumental data sets (HadCRUT, NOAA, Berkeley Earth, Kadow) assessed by IPCC-AR6-WGI and shown in Fig. 2.11c.

**Available:** https://doi.org/10.5281/zenodo.6321535 (Trewin, 2022; GMST-component_data_sets.csv).

**Modified:** None (1850-1900 reference period).


## Lee et al. (2021)

**Data set:**  Global temperature projections to 2300 of Lee et al. (2021) based on the MAGICC (v.7.5.0) emulator (Meinshausen et al., 2020) calibrated against the IPCC-AR6 assessed temperature to 2100 and shown in Fig. 4.40a.

**Available:** https://zenodo.org/record/6386979 (Nicholls et al., 2022; files with titles containing “fig-4-40” and respective SSP identifiers).

**Modified:** None (1850-1900 reference period).


# References

Gillett, N. P., Malinina, E., Kaufman, D., Neukom, R.: Summary for Policymakers of the Working Group I contribution to the IPCC Sixth Assessment Report - data for Figure SPM.1 (v20210809). NERC EDS Centre for Environmental Data Analysis [data set], http://dx.doi.org/10.5285/76cad0b4f6f141ada1c44a4ce9e7d4bd, 2021.

Gulev, S. K., Thorne, P. W., Ahn, J., Dentener, F. J., Domingues, C. M., Gerland, S., Gong, D., Kaufman, D. S., Nnamchi, H.C., Quaas, J., Rivera, J. A., Sathyendranath, S., Smith, S.L., Trewin, B., von Shuckmann, K., and Vose, R. S.: Changing State of the Climate System, in: Climate Change 2021: 85 The Physical Science Basis. Contribution of Working Group I to the Sixth Assessment Report of the Intergovernmental Panel on Climate Change, edited by: Masson-Delmotte, V., Zhai, P., Pirani, A., Connors, S. L., Péan, C., Berger, S., Caud, N., Chen, Y., Goldfarb, L., Gomis, M. I., Huang, M., Leitzell, K., Lonnoy, E., Matthews, J. B. R., Maycock, T.K., Waterfield, T., Yelekçi, O., Yu, R., and Zhou, B., Cambridge University Press, https://www.ipcc.ch/report/ar6/wg1/ downloads/report/IPCC_AR6_WGI_Chapter_02.pdf, 2021.

Hansen J., Sato, M., Russell, G., and Kharecha, P.: Climate sensitivity, sea level and atmospheric carbon dioxide, Philos. T. Roy. Soc. A, 371, 20120294, https://doi.org/10.1098/rsta.2012.0294, 2013.

Kaufman, D., McKay, N., Routson, C., Erb, M., Davis, B., Heiri, O., Jaccard, S., Tierney, J., Dätwyler, C., Axford, Y., Brussel, T., Cartapanis, O., Chase, B., Dawson, A., de Vernal, A., Engels, S., Jonkers, L., Marsicek, J., Moffa-Sánchez, P., Morrill, C., Orsi, A., Rehfeld, K., Saunders, K., Sommer, P., Thomas, E., Tonello, M., Tóth, M., Vachula, R., Andreev, A., Bertrand, S., Biskaborn, B., Bringué, M., Brooks, S., Caniupán, M., Chevalier, M., Cwynar, L., Emile-Geay, J., Fegyveresi, J., Feurdean, A., Finsinger, W., Fortin, M., Foster, L., Fox, M., Gajewski, K., Grosjean, M., Hausmann, S., Heinrichs, M., Holmes, N., Ilyashuk, B., Ilyashuk, E., Juggins, S., Khider, D., Koinig, K., Langdon, P., Larocque-Tobler, I., Li, J., Lotter, A., Luoto, T., Mackay, A., Magyari, E., Malevich, S., Mark, B., Massaferro, J.,Montade,V.,Nazarova,L.,Novenko,E.,Paril,P.,Pearson,E., Peros, M., Pienitz, R., Płóciennik, M., Porinchu, D., Potito, A., Rees, A., Reinemann, S., Roberts, S., Rolland, N., Salonen, S., Self, A., Seppä, H., Shala, S., St-Jacques, J., Stenni, B., Syrykh, L., Tarrats, P., Taylor, K., van den Bos, V., Velle, G., Wahl, E., Walker, I., Wilmshurst, J., Zhang, E., and Zhilich, S.: A global database of Holocene paleo-temperature, Scientific Data, 7, 115, https://doi.org/10.1038/s41597-020-0445-3, 2020a.

Kaufman, D., McKay, N., Routson, C., Erb, M., Dätwyler, C., Sommer, P., Heiri, O., and Davis, B.: Holocene global surface temperature: A multi-method reconstruction approach, Scientific Data, 7, 201, https://doi.org/10.1038/s41597-020-0530-7, 2020b.

Kaufman, D., McKay, N., Routson, C., Erb, M., Dätwyler, C., Sommer, P., Heiri, O., and Davis, B.: NOAA/WDS Paleoclimatology – Holocene global surface temperature: A multi-method reconstruction approach, NOAA National Centers for Environmental Information [data set], https://doi.org/10.25921/vzys-1280, 2020c.

Lee, J. Y., Marotzke, J., Bala, G., Cao, L., Corti, S., Dunne, J. P., Engelbrecht, F., Fischer, E., Fyfe, J. C., Jones, C., Maycock, A., Mutemi, J., Ndiaye, O., Panickal, S., and Zhou, T.: Future Global Climate: Scenario-Based Projections and Near-Term Information, in: Climate Change 2021: The Physical Science Basis. Contribution of Working Group I to the Sixth Assessment Report of the Intergovernmental Panel on Climate Change, edited by: Masson-Delmotte, V., Zhai, P., Pirani, A., Connors, S. L., Péan, C., Berger, S., Caud, N., Chen, Y., Goldfarb, L., Gomis, M. I., Huang, M., Leitzell, K., Lonnoy, E., Matthews, J. B. R., Maycock, T. K., Waterfield, T., Yelekçi, O., Yu, R., and Zhou, B., Cambridge University Press, https://www.ipcc.ch/report/ar6/wg1/downloads/ report/IPCC_AR6_WGI_Chapter_04.pdf, 2021.

Meinshausen, M., Nicholls, Z. R. J., Lewis, J., Gidden, M. J., Vogel, E., Freund, M., Beyerle, U., Gessner, C., Nauels, A., Bauer, N., Canadell, J. G., Daniel, J. S., John, A., Krummel, P. B., Luderer, G., Meinshausen, N., Montzka, S. A., Rayner, P. J., Reimann, S., Smith, S. J., van den Berg, M., Velders, G. J. M., Vollmer, M. K., and Wang, R. H. J.: The shared socio-economic pathway (SSP) greenhouse gas concentrations and their extensions to 2500, Geosci. Model Dev., 13, 3571–3605, https://doi.org/10.5194/gmd-13-3571-2020, 2020.

McKay, N.: nickmckay/past-and-future-warming-comparison-figure, Zenodo [code and data set], https://doi.org/10.5281/zenodo.5842209, 85 2022.

Nicholls, Z., Meinshausen, M., and Lewis, J.: AR6 WG1 plots and processing (v1.0.0), Zenodo [data set], https://doi.org/10.5281/zenodo.6386979, 2022.

Osmann, M. B., Tierney, J. E., Zhu, J., Tardif, R., Halkim, G. J., King, J., and Poulsen, C. J.: Globally resolved surface temperatures since the Last Glacial Maximum, Nature, 599, 239–244, https://doi.org/10.1038/s41586-021-03984-4, 2021a.

Osmann, M. B., Tierney, J. E., Zhu, J., Tardif, R., Halkim, G. J., King, J., and Poulsen, C. J.: NOAA/WDS Paleoclimatology – Globally resolved surface temperatures since the Last Glacial Maximum, NOAA National Centers for Environmental Information [data set], https://doi.org/10.25921/njxd-hg08, 2021b.

PAGES 2k Consortium (Neukom, R., Barboza, L.A., Erb, M. P., Shi, F., Emile-Geay, J., Evans, M. N., Franke, J., Kaufman, D. S., Lücke, L., Rehfeld, K., Schurer, A., Zhu, F., Brönnimann, S., Hakim, G.J., Henley, B., Ljungqvist, F. C., McKay, N., Valler, V., von Gunten, L.): Consistent multi-decadal variability in global temperature reconstructions and simulations over the Common Era. Nature Geosci., 12, 643-649. https://doi.org/10.1038/s41561-019-0400-0, 2019.

Rouston, C., McKay, N., Sommer, P. S., Dätwyler, C., and Erb, M.: nickmckay/Temperature12k: Analysis and plotting code for Temp12k Analysis Paper (1.2.0), Zenodo [code], 105 https://doi.org/10.5281/zenodo.3888590, 2020.

Snyder, C. W.: Evolution of global temperature over the past two million years, Nature, 538, 226–228, https://doi.org/10.1038/nature19798, 2016.

Trewin, B.: Global temperature time series from IPCC AR6, Zenodo [data set], https://doi.org/10.5281/zenodo.6321535, 2022.

Zachos, J.C., Dickens, G.R., and Zeebe, R.E.: An Early Cenozoic perspective on greenhouse warming and carbon-cycle dynamics. Nature 451, 279–283, https://doi.org/10.1038/nature06588, 2008.