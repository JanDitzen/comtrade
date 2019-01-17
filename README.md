# comtrade 
## Downloading trade data from UN Comtrade using jsonio and parsing the output in a user friendly format.

__Table of Contents__
1. [Syntax](#1-syntax)
2. [Introduction](#2-introduction)
3. [Options](#3-options)
4. [Examples](#4-examples)
5. [Stored Values](#5-stored values)
6. [About](#6-about)

# 1. Syntax
The general syntax is:

```
comtrade [api|bulk|mbs|list] , specific_options general_options
```

where api is the default and specific_options depend on api|bulk|mbs|list.

To download api data (default):

```
comtrade [api] , hs(string) class(string) reportercountry(string) partnercountry(string) maxdata(string) type(string) freq(string) years(string) traderegime(string) [ imts(string) general options ]
```

To download bulk data:

```
comtrade bulk , hs(string) reportcountry(string) type(string) freq(string) years(string) [ skipzip general options ]
```

To download Monthly Bulletin of Statistics (MBS) and Analytical Trade Tables and World Tables of International Trade Statistics Yearbook (ITSY):

```
comtrade mbs , series_type(string) years(string) country_code(string) | footnote table_type(string)
```

To download data from a specified url:

```
comtrade , url(string) [ general options ]
```

general options are:

```
comtrade , ....  token(string) variables(string) load force nocheck onlyvalidation showvalidation save(filename) records(filename) count(integer) maxcount(integer) starttime(time)
```

To download possible parameters for reportercountry, partnercountry, class:

```
comtrade list, [listall]
```

William Buchanan's jsonio needs to be installed for the use of comtrade.  Please install from:
```
net install jsonio, from(https://wbuchanan.github.io/StataJSON) replace
```

For more information see the autors website or the help page for StataJSON.

# 2. Introduction
**comtrade** downloads trade data from [UN Comtrade](https://comtrade.un.org/). Comtrade trade data is available in the JSON (JavaScript Object Notation) format. **comtrade** uses the user written command jsonioto download the data in the JSON format, it then parses the retrieved data bringing it in into an user friendly format.

Comtrade offers data in four different ways, via a bulk download, an API call or a web address. **comtrade** can retrieve data from all of those, but validates the request first. In addition it can download data from the Monthly Bulletin of Statistics (MBS) of Analytical Trade Tables and World Tables of International Trade Statistics Yearbook (ITSY) including footnotes.


## Validation

As a first step **comtrade** validates the data request (see [api](https://comtrade.un.org/data/doc/api/#APIKey) and [bulk](https://comtrade.un.org/data/doc/api/bulk/#DataRequests)). Within this step, if the option **records()** is used, it is possible to cross-check if data was updated and only perform the data request if data online was updated. **records()** saves an xlsx file with details of the validation. The results from the validation are saved as variables starting with **_varname**. 
The following results are stored: information about the request, publication date, indicator if data is original and number of records.


## API Calls

API calls allow to download a specific reportercountry, classification, partnercountry and year combination. For more information, the necessary parameters see the [documentation](https://comtrade.un.org/data/doc/api/).

**comtrade** validates and downloads the data and brings it in a user friendly format. Under the free version, comtrade restricts the number of hourly requests. **comtrade** can keep track of those and pause Stata and continue if necessary.


## bulk downloads

Large quantities of data can be obtained using a _bulk_ download ([see for more information](https://comtrade.un.org/data/doc/api/bulk/)). Bulk downloads contain all partner trade data for a given year, reportercountry and trade code. 
Bulk downloads are downloaded in a zip file and only available to authorized users. 
For information about pricing see [UN Comtrade Shop](https://shop.un.org/comtrade).

**comtrade** downloads the zip file, extracts it, saves it as a dta and opens it in Stata.


## mbs downloads

Monthly Bulletin of Statistics (MBS) of Analytical Trade Tables and World Tables of International Trade Statistics Yearbook (ITSY) including footnotes can be downloaded as well. For a description of the data see the [MBS webpage]("https://comtrade.un.org/data/doc/API_MBS). The download of footnotes is possible as well. There is no validation for **mbs** requests necessary.

## url downloads
It is possible to build a query using the [webinterace](https://comtrade.un.org/data/). This is essentially an API call and can be used using the **url()** option.

**comtrade** downloads the requested data and loads it into Stata.

              Non url() requests

              If url is not used, then the depending if bulk, api or mbs is used, several options are required to build a
                  request.  A comtrade request is an url which looks for an API call looks like -
                  https://comtrade.un.org/api//refs/da/view?parameters - for more details see Comtrade API Parameters.

              The following parameters need to be set for:

              api and bulk requests

              hs(string) sets the px parameter, the product classification scheme.  Can be HS, H0, H1, H2, H4, H5, ST, S1,
                  S2, S3, S4, BEC or EB02.  See the webpage or Stata for valid parameters.

              class(string) sets the cc parameter, the detailed product classification code. string can be:  TOTAL (Total
                  trade between reporter and partner, no detail breakdown), AG1, AG2, AG3, AG4, AG5, AG6 and ALL (all
                  codes).  AG1 - AG6 are detailed codes at a specific digit level.  For instance AG6 in HS gives all of
                  the 6-digit codes, which are the most detailed codes that are internationally comparable.  Not all
                  classifications have all digit levels available.  See the classification specific codes for more
                  information.

              reportercountry(string) sets the r parameter, the reporter country.  See list of valid reporters in web or
                  in Stata.

              partnercountry(string) sets the p parameter, the partner country.  See list of valid partners web or in
                  Stata

              type(string) sets the type parameter, the trade data type. Values can be C for commodities and S for
                  services.

              freq(string) sets the freq parameter, the frequency. Valid values are A for annual and M for monthly.

              traderegime(string) sets the rg parameter, the trade regime.  Valid values are all for imports and exports,
                  1 for imports and 2 for exports. See valid parameters in web or Stata.

              years(string) sets the ps parameter, the time period. Format can be YYYY, YYYYMM, now or recent.

              imts(string) data fields/columns based on IMTS Concepts & Definitions.  Can be 2010 for data complying with
                  IMTS 2010 or orig for earlier versions.  Is optional.

              maxdata(string) sets the max parameter, maximum number of records to be returned.

              mbs requests

              series_type(string) sets the series type.  The series type is a combination of the tablenumber, frequency,
                  type of measurement and currency.  For a list of possible valid values see web or Stata.

              country_code(string) sets the country code.  A list of valid codes can be obtained on the web or from Stata.

              years(string) specifies the reference year.

              If option footnote is used to obtain footnotes.  Then table_type defines the table for which the footnotes
                  are downloaded.  A list is available on the web or from Stata.

              list specific options

              listall only with list.  Shows all possible value for a given parameter.  If not set, then only the first 50
                  values are shown.

              Specific Options - Validation
              Before data is requested, the request is validated.  This only applies to api, bulk or url calls.  Within
                the validation process comtrade compares the date of publication of the requested and existing data.  The
                following options alter this behaviour:

              records(filename) specifies the Excel file to save a log.  The log contains the filename, uri (for bulk) or
                  a key (for API), the date of download and date of publication.  Records are only possible for a single
                  reporter country-class-year combination.

              force Download file even if date of publication is the same.

              onlyvalidation only validates the request without downloading data.

              showvalidation display details of validation.

              The following options load, save or keep the data:

              variables(varlist) obtains only the variables defined in varlist.  Default is to obtain all variables.

              General Options
              Options relating how to store the obtained data:

              save(string) saves dataset.  If option bulk is used, then the filename is the name of the zip file.  For API
                  calls, string has to contain the filename.

              append(string) appends and saves dataset.

              skipzip does not unzip the downloaded bulk file.  The option applies only if the option bulk is used.

              token(string) sets the authorization token.  The token can be tested here and for further information see
                  info about authorization.  The token is required for url() and api calls of a certain size or if there
                  are more than 100 requests per hour.  The token is always required for bulk downloads.

              load load the obtained dataset into memory.

              count(integer) number of past requests.

              maxcount(integer) maximum number of possible requests per hour. Default is 100.

              starttime(time) start time of the first request. Needs to be in the format as saved in c(current_time).

          Examples

              Example 1: build an API call and use url()
                  comtrade can be used to download a pre build URL.  The URL can be build on the comtrade website here or
                  in the comtrade API portal.

              For example the aim is to download Germany's coal trade with the world in 2017.  From the website above, the
                  following url is obtained:
                  /api/get?max=500&type=C&freq=A&px=HS&ps=2017&r=276&p=0&rg=all&cc=2701
                  To use the link to download the data, the option url() is used.  The data is saved in the current
                  workfolder and named GermanyCoal.dta:

                    comtrade , url(/api/get?max=500&type=C&freq=A&px=HS&ps=2017&r=276&p=0&rg=all&cc=2701)
                      save("`c(pwd)'/GermanyCoal.dta")

              The output will be the following:

                      Number of observations found in dataset: 2
                      File saved: ..../GermanyCoal.dta

              Two observations are downloaded and loaded into Stata.  One for exports and one for imports.

              Example 2: Directly build an API call
                  It is possible to download the same data, but if the keys are known, comtrade will be able to build the
                  URL itself. For the example above, we need to set the following options:

                    comtrade api, maxdata(500) type(C) freq(A) years(2017) reporterc(276) partnerc(0) traderegime(all)
                      hs(HS) cl(2701) save("`c(pwd)'/GermanyCoal.dta")

              A maximum number of 500 observations (maxdata(500)) of commodities (type(C)) of yearly (freq(A)) for the
                  year 2017 (years(2017)) is downloaded.  reportc sets the reporting country and partnerc the partner(s).
                  traderegime specifies that all trade, i.e. export and imports and re-exports and re-imports, for the HS
                  code defined in cl() are obtained.

              The output will be the same as before:

                      Number of observations found in dataset: 2
                      File saved: ..../GermanyCoal.dta

              Example 3: Using the records() option
                  To use the record function, the option records() is added.  For example if a list of all downloaded
                  files is to be kept in the workfolder and the filename is records and the same request as above is done:

                    comtrade api, maxdata(500) type(C) freq(A) hs(HS) years(2017) reporterc(276) partnerc(0)
                      traderegime(all) cl(2701) save("`c(pwd)'/GermanyCoal.dta") records("`c(pwd)'/Records.xlsx")

              The output is the following:

                      New data published: 2018-08-23 00:00:00.
                      Number of observations found in dataset: 2
                      File saved using ..../GermanyCoal.dta
                      Record list written to  ..../Records.xlsx

              If the same command line from above is called again, comtrade will check if data is updated. If not (as it
                  is the case here) it will issue the following messages:

                      Getting records from file: ..../Records.xlsx, sheet: api
                      1 record(s) found.
                      1 match found.
                      No update available. Both have date: 2018-08-23 00:00:00

              To download for example peat trade, option cl() is changed from 2701 to 2703.  In addition the saved dta
                  should be appended and the download is logged and api omitted.

                    comtrade, maxdata(500) type(C) freq(A) hs(HS) years(2017) reporterc(276) partnerc(0) traderegime(all)
                      cl(2703) append("`c(pwd)'/GermanyCoal.dta") records("`c(pwd)'/Records.xlsx")

              The file will be downloaded and a new record added to the Excel file.  The output reads:

                      Getting records from file: ..../Records.xlsx, sheet: api
                      1 record(s) found.
                      Number of observations found in dataset: 2
                      File appended using ..../GermanyCoal.dta
                      Record list written to  ..../Records.xlsx

              The dataset will have 4 observations, two for each product for both years.

              Example 4: Bulk download
                  To download a bulk file, the option bulk is used.  It is not necessary to specify the name of the dta
                  under which the downloaded data is saved.  In addition, a authorization token is required.

              For example, to download all trade data for Germany in 2017, the following command line is used:

                    comtrade bulk, type(C) freq(A) hs(HS) years(2017) reporterc(276)
                      append("`c(pwd)'/GermanyCoalBulk.dta") records("`c(pwd)'/Records.xlsx") token(token)

              The output is the following:

                      New Series found.
                      New data published: 2018-08-23 00:00:00.
                      File appended using ..../GermanyCoal.dta
                      Record list written to  ..../Records.xlsx

              Example 5: Loop and API download
                  comtrade can be used within a loop over multiple values of a parameter, for example years.  For example
                  a loop can be used to retrieve coal trade of Germany for the years 1991 - 2018.  If no token is used,
                  then a maximum number of 100 data requests per hour is allowed.  comtrade can keep track of the number
                  of requests and if the maximum per hour is reached, wait until further requests are allowed.  To track
                  the number of requests, the options starttime() and count() are set.  Within the loop, the counter is
                  changed using the value r(count).  To save the data the option append() is used.

              The following code is used (please copy):

                      local starttime "`c(current_time)'"
                      local count = 0
                      forvalues year = 1991(1)2018  { 
                        comtrade api, append(data) maxdata(500) type(C) freq(A) hs(HS) years(`year') reporterc(276) partnerc(0) traderegime(all) cl(2701) 
                              count(`count') starttime(`starttime')
                        local count = r(count)
                      }

              Example 6: Download MBS data
                  To download Monthly Bulletin of Statistics (MBS) the function comtrade mbs is used.  The download
                  requires to set the series_type() option, the year and country_type options.  For specifications see the
                  MBS webpage.  The specifications can be obtain using comtrade list as well.

              The series_type parameter contains information about the table number, frequency, type of measurement and
                  currency.  To follow the example from the website, the following command line is used:

                     comtrade mbs , series_type("T35.A.V.$") country_code(842) year(2015)

              To download footnotes, the option footnote is used.  For the footnote, the options table_type() is required.

                     comtrade mbs , footnote table_type("T35") 

              Example 7: List and download possible parameters
                  comtrade offers to download all possible values for parameters, such as country codes, classification
                  codes,.... To obtain those, comtrade is called with the parameter list:

                     comtrade list

              gives the following output:

                     . comtrade list
                     The following lists for parameters are available:
                     Title                               Link
                      ***** API and Bulk *****
                      1. Reporter/Partner Area           comtrade list countries
                      2. Trade Regimes                   comtrade list regime
                     Classifications
                      3. HS as reported                  comtrade list px HS
                      4. HS 1992                         comtrade list px H0
                      5. HS 1996                         comtrade list px H1
                      6. HS 2002                         comtrade list px H2
                      7. HS 2007                         comtrade list px H3
                      8. HS 2012                         comtrade list px H4
                      9. SITC as reported                comtrade list px ST
                     10. SITC Rev. 1                     comtrade list px S1
                     11. SITC Rev. 2                     comtrade list px S2
                     12. SITC Rev. 3                     comtrade list px S3
                     13. SITC Rev. 4                     comtrade list px S4
                     14. Broad Econ. Cat. (BEC)          comtrade list px BEC
                     15. Extended Balance of paym.       comtrade list px EB02
                     ***** MBS *****
                     16. Type of data series             comtrade list mbs series_type
                     17. MBS Table numbers               comtrade list mbs table_type
                     18. reference country/area          comtrade list mbs MBSAreas
           

          Stored Values

              The following values are stored in r():

                 r(validation)         Validation Code
                 r(count)              Number of requests
                 r(StartTime)          Time of first request
                 r(PublicationDate)    Publication date (earliest)
                 r(NumRecords)         Number of records
                 r(FileSize)           Size of file on disk
                 r(Filename)           Filename of saved dta
                 r(uri)                URL to request
                 r(downloaded)         0 if no data downlaoded, 1 if data downloaded.


          Author

              Jan Ditzen (Heriot-Watt University)
              Email: j.ditzen@hw.ac.uk
              Web: www.jan.ditzen.net

          Changelog

              This version: 1.0

          Acknowledgement

              This program would not have been possible without William Buchanan jsonio command.  For more information see
              https://github.com/wbuchanan.
              Thanks to the CEERP team for valuable feedback.  All errors are my own.

          Also see

              See also: jsonio
           
