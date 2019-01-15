{smcl}
{hline}
{hi:help comtrade}{right: v. 1.0 - January 2019}
{hline}
{title:Title}

{p 4 4}{cmd:comtrade} - Downloads trade data from {browse "https://comtrade.un.org/":Comtrade} using {help jsonio} and parses the output in a user friendly format.{p_end}

{title:Contents}

{p 4}{help comtrade##syntax:Syntax}{p_end}
{p 4}{help comtrade##Introduction:Introduction}{p_end}
{p 4}{help comtrade##options:Options}{p_end}
{p 4}{help comtrade##Examples:Examples}{p_end}
{p 4}{help comtrade##rclass:Stored Values}{p_end}
{p 4}{help comtrade##about:About}{p_end}


{marker syntax}{title:Syntax}

{p 4 13}The general syntax is:{p_end}

{p 6 13}{cmd: comtrade [api|bulk|mbs|list] , {it:specific_options} {it:general_options}}{p_end}

{p 4 13}where {cmd:api} is the default and {it:specific_options} depend on {cmd:api|bulk|mbs|list}.{p_end}

{p 4 13}To download api data (default):{p_end}

{p 6 13}{cmd: comtrade [api] , }
{cmd:hs(string)}
{cmdab:cl:ass(string)}
{cmdab:reporterc:ountry(string)} 
{cmdab:partnercountry(string)}
{cmd:maxdata(string)}
{cmd:type(string)} 
{cmd:freq(string)}
{cmd:years(string)}
{cmd:traderegime(string)}
[ {cmd:imts(string)} {it:general options} ] {p_end}

{p 4 13}To download bulk data:{p_end}

{p 6 13}{cmd: comtrade bulk , }
{cmd:hs(string)}
{cmdab:reportc:ountry(string)}
{cmd:type(string)}
{cmd:freq(string)}
{cmd:years(string)} 
[ skipzip {it:general options} ] {p_end}

{p 4 13}To download Monthly Bulletin of Statistics (MBS) and 
Analytical Trade Tables and World Tables of International Trade Statistics Yearbook (ITSY):{p_end}

{p 6 13}{cmd: comtrade mbs , }
{cmd:series_type(string)}
{cmd:years(string)}
{cmd:country_code(string)}
|
{cmd:footnote}
{cmd:table_type(string)}{p_end}

{p 4 13}To download data from a specified url:{p_end}

{p 6 13}{cmd: comtrade ,}
{cmd:url(string)}
[ {it:general options} ] {p_end}

{p 4 13}{it:general options} are:{p_end}

{p 6 13}{cmd: comtrade , .... }
{cmd:token(string)}
{cmd:variables(string)}
{cmd:load}
{cmd:force}
{cmd:nocheck}
{cmdab:onlyvali:dation}
{cmdab:showvali:dation}
{cmd:save(filename)}
{cmd:records(filename)}
{cmd:count(integer)}
{cmd:maxcount(integer)}
{cmd:starttime(time)}
{p_end}

{p 4 13}To download possible parameters for {it:reportercountry}, {it:partnercountry},
{it:class}:{p_end}

{p 6 13}{cmd: comtrade list, [listall]}{p_end}

{p 4 8}William Buchanan's {help jsonio} needs to be installed for the use of {cmd:comtrade}. 
Please install from:{p_end}
{col 12}{stata "net install jsonio, from(https://wbuchanan.github.io/StataJSON) replace"}
{p 4 8}For more information see the autors {browse "https://github.com/wbuchanan" :website}
or the help page for {browse "https://github.com/wbuchanan/StataJSON":StataJSON}.{p_end}

{marker Introduction}{title:Introduction}

{p 4 4}{cmd:comtrade} downloads trade data from {browse "https://comtrade.un.org/":UN Comtrade}.
Comtrade trade data is available in the JSON (JavaScript Object Notation) format.
{cmd:comtrade} uses the user written command {help jsonio} to download the data in the JSON 
format, 
it then parsesthe retrieved data bringing it in into an user friendly format.{p_end}

{p 4 4}Comtrade offers data in four different ways, via a bulk download, an API call
or a webadress.
{cmd:comtrade} can retrieve data from all of those, but validates the request first.
In addition it can downlaod data from the 
Monthly Bulletin of Statistics (MBS) of Analytical Trade Tables and World Tables 
of International Trade Statistics Yearbook (ITSY) including footnotes.{p_end}

{p 4 8}{ul:Validation}{p_end}
{p 4 4}As a first step {cmd:comtrade} validates the data request (see
{browse "https://comtrade.un.org/data/doc/api/#APIKey":api} and 
{browse "https://comtrade.un.org/data/doc/api/bulk/#DataRequests":bulk}).
Within this step, if the option {cmd:records()} is used, 
it is possible to cross-check if data was updated and only peform
the data request if data online was updated.
{cmd:records()} saves an xlsx file with details of the validation.
The results from the validation are saved as variables starting with {cmd:_{varname}}.
The following results are stored: informations about the request, publication date,
indicator if data is original and number of records.{p_end}

{p 4 8}{ul:API Calls}{p_end}
{p 4 4}API calls allow to download a specific reportcountry, classification, partnercountry
and year combination. 
For more information, the necessary parameters see the 
{browse "https://comtrade.un.org/data/doc/api/":documentation}.{break}
{cmd:comtrade} validates and downloads the data and brings it in a user friendly format.
Under the free version, comtrade restricts the number of hourly requests.
{cmd:comtrade} can keep track of those and pause Stata and continue if necessary.{p_end}

{p 4 8}{ul:bulk downloads}{p_end}
{p 4 4}Large quantities of data can be obtained using a {it:bulk} download 
({browse "https://comtrade.un.org/data/doc/api/bulk/":see for more information}).
Bulk downloads contain all partner trade data for a given year, reportcountry and 
trade code. 
Bulk downloads are downloaded in a zip file and only available to authorized users. 
For informations about pricing see {browse "https://shop.un.org/comtrade":UN Comtrade Shop}.{break}
{cmd:comtrade} downloads the zip file, extracts it, saves it as a dta and opens it in Stata.{p_end}

{p 4 8}{ul:mbs downloads}{p_end}
{p 4 4}Monthly Bulletin of Statistics (MBS) of Analytical Trade Tables and World Tables 
of International Trade Statistics Yearbook (ITSY) including footnotes
can be downloaded as well.
For a description of the data see the 
{browse "https://comtrade.un.org/data/doc/API_MBS":MBS webpage}.
The download of footnotes is possible as well.
There is no validation for {cmd:mbs} requests necessary.{p_end}

{p 4 8}{ul:url downloads}{p_end}
{p 4 4}It is possible to build a query using the 
{browse "https://comtrade.un.org/data/":webinterface}. 
This is essentially an API call and can be used using the {cmd:url()} option.{break}
{cmd:comtrade} downloads the requested data and loads it into Stata.
{p_end}


{marker options}{title:Options}

{p 4 8}{ul:Non url() requests}{p_end}

{p 4 8}If {cmd:url} is not used, then the depending if {cmd:bulk}, {cmd:api} or {cmd:mbs}
is used, several options are required to build a request. 
A comtrade request is an url which looks for an API call looks like - 
https://comtrade.un.org/api//refs/da/view?parameters -
for more details see
{browse "https://comtrade.un.org/data/doc/api/#DataRequests" :Comtrade API Parameters}.
{p_end}

{p 4 8}The following parameters need to be set for:{p_end}

{p 4 8}{ul:{cmd:api} and {cmd:bulk} requests}{p_end}

{p 4 8}{cmd:hs(string)} sets the {it:px} parameter, the product classification scheme.
Can be HS, H0, H1, H2, H4, H5, ST, S1, S2, S3, S4, BEC or EB02.
See the {browse "https://comtrade.un.org/data/doc/api/#DataRequests":webpage}
or {stata comtradedownlaoder list:Stata} for valid parameters.{p_end}

{p 4 8}{cmdab:cl:ass(string)} sets the {it:cc} parameter, the detailed product classification
code. {it:string} can be:  TOTAL (Total trade between reporter and partner, no detail breakdown),
AG1, AG2, AG3, AG4, AG5, AG6 and ALL (all codes).
AG1 - AG6 are detailed codes at a specific digit level.
For instance AG6 in HS gives all of the 6-digit codes, which are the most detailed codes that are internationally comparable. 
Not all classifications have all digit levels available. 
See the classification specific codes for more information.
{p_end}

{p 4 8}{cmdab:reporterc:ountry(string)} sets the {it:r} parameter, the reporter country.
See list of valid reporters in {browse "https://comtrade.un.org/data/cache/reporterAreas.json" :web}
or in {stata comtrade list reporter:Stata}.{p_end}

{p 4 8}{cmdab:partnerc:ountry(string)} sets the {it:p} parameter, the partner country.
See list of valid partners {browse "https://comtrade.un.org/data/cache/partnerAreas.json" :web}
or in {stata comtrade list partner:Stata}{p_end}

{p 4 8}{cmd:type(string)} sets the {it:type} parameter, the trade data type. Values can be
{it:C} for commodities and {it:S} for services.{p_end}

{p 4 8}{cmd:freq(string)} sets the {it:freq} parameter, the frequency. Valid values are
{it: A} for annual and {it:M} for monthly.{p_end}

{p 4 8}{cmd:traderegime(string)} sets the {it:rg} parameter, the trade regime. 
Valid values are {it:all} for imports and exports, {it:1} for imports and {it:2}
for exports. See valid parameters in 
{browse "https://comtrade.un.org/data/cache/tradeRegimes.json":web}
or {stata comtrade list regime:Stata}.{p_end}

{p 4 8}{cmd:years(string)} sets the {it:ps} parameter, the time period. Format can 
be {it:YYYY}, {it:YYYYMM}, {it:now} or {it:recent}.{p_end}

{p 4 8}{cmd:imts(string)} data fields/columns based on IMTS Concepts & Definitions.
Can be {it:2010} for data complying with IMTS 2010 or {it:orig} for earlier versions.
Is optional.{p_end}

{p 4 8}{cmd:maxdata(string)} sets the {it:max} parameter, maximum number of records to be returned.{p_end}

{p 4 8}{ul:{cmd:mbs} requests}{p_end}

{p 4 8}{cmd:series_type(string)} sets the series type. 
The series type is a combination of the tablenumber, frequency, type of measurement and currency.
For a list of possible valid values see
{browse "https://comtrade.un.org/data/cache/series_type.json":web} or 
{stata comtrade list mbs series_type:Stata}.{p_end}

{p 4 8}{cmd:country_code(string)} sets the country code. 
A list of valid codes can be obtained on the 
{browse "https://comtrade.un.org/data/cache/MBSAreas.json":web}
or from {stata comtrade list mbs MBSAreas :Stata}.{p_end}

{p 4 8}{cmd:years(string)} specifies the reference year.{p_end}

{p 4 8}If option {cmd:footnote} is used to obtain footnotes. 
Then {cmd:table_type} defines the table for which the footnotes are downloaded.
A list is available on the 
{browse "https://comtrade.un.org/data/cache/table_type.json":web}
or from {stata comtrade list mbs table_type:Stata}.{p_end}

{p 4 6}{ul:{cmd:list} specific options}{p_end}

{p 4 8}{cmd:listall} only with {cmd:list}. 
Shows all possible value for a given parameter.
If not set, then only the first 50 values are shown.{p_end}

{p 4 6}{ul:Specific Options - Validation}{p_end}
{p 4 6}Before data is requested, the request is validated.
This only applies to {cmd:api}, {cmd:bulk} or {cmd:url} calls.
Within the validation process {cmd:comtrade} compares the date of publication
of the requested and existing data. 
The following options alter this behaviour:
{p_end}

{p 4 8}{cmd:records(filename)} specifies the Excel file to save a log. 
The log contains the filename, uri (for bulk) or a key (for API), the date of download and
date of publication. 
Records are only possible for a single reporter country-class-year combination.{p_end}

{p 4 8}{cmd:force} Download file even if date of publication is the same.{p_end}

{p 4 8}{cmdab:onlyvali:dation} only validates the request without downloading data.{p_end}

{p 4 8}{cmdab:showvali:dation} display details of validation.{p_end}

{p 4 8}The following options load, save or keep the data:{p_end}

{p 4 8}{cmd:variables({varlist})} obtains only the variables defined in {varlist}.
Default is to obtain all variables.{p_end}

{p 4 6}{ul:General Options}{p_end}
{p 4 6}Options relating how to store the obtained data:{p_end}

{p 4 8}{cmd:save(string)} saves dataset. 
If option {cmd:bulk} is used, then the filename is the name of the zip file. 
For API calls, {it:string} has to contain the filename.{p_end}

{p 4 8}{cmd:append(string)} appends and saves dataset.{p_end}

{p 4 8}{cmd:skipzip} does not unzip the downloaded bulk file. 
The option applies only if the option {cmd:bulk} is used.{p_end}

{p 4 8}{cmd:token(string)} sets the authorization token. 
The token can be tested {browse "https://comtrade.un.org/ws/CheckRights.aspx" :here} and
for further information see {browse "https://comtrade.un.org/api/swagger/ui/index#!/Auth/Auth_Authorize":info about authorization}.
The token is required for {cmd:url()} and {cmd:api} calls of a certain size or 
if there are more than 100 requests per hour. 
The token is {ul:always} required for bulk downloads.{p_end}

{p 4 8}{cmd:load} load the obtained dataset into memory.{p_end}

{p 4 8}{cmd:count(integer)} number of past requests.{p_end}

{p 4 8}{cmd:maxcount(integer)} maximum number of possible requests per hour. Default is 100.{p_end}

{p 4 8}{cmd:starttime(time)} start time of the first request. Needs to be in the format as saved
in {cmd:c(current_time)}.{p_end}

{marker Examples}{title:Examples}

{p 4 8}{bf:Example 1: build an API call and use url()}{break}
{cmd:comtrade} can be used to download a pre build URL.
The URL can be build on the comtrade website 
{browse "https://comtrade.un.org/data/":here}
or in the 
{browse "https://comtrade.un.org/data/dev/portal/":comtrade API portal}.{p_end}

{p 4 8}For example the aim is to download Germany's coal trade with the world in 2017.
From the website above, the following url is obtained:{break}{break}
/api/get?max=500&type=C&freq=A&px=HS&ps=2017&r=276&p=0&rg=all&cc=2701{break}{break}
To use the link to download the data, the option {cmd:url()} is used. 
The data is saved in the current workfolder and named {it:GermanyCoal.dta}:{p_end}

{p 10 12}{stata comtrade , url(/api/get?max=500&type=C&freq=A&px=HS&ps=2017&r=276&p=0&rg=all&cc=2701) save("`c(pwd)'/GermanyCoal.dta")}{p_end}

{p 4 8}The output will be the following:{p_end}

{col 12}{cmd: Number of observations found in dataset: 2}
{col 12}{cmd: File saved: ..../GermanyCoal.dta}

{p 4 8}Two observations are downloaded and loaded into Stata.
One for exports and one for imports.{p_end}

{p 4 8}{bf:Example 2: Directly build an API call}{break}
It is possible to download the same data, but if the keys are known, {cmd:comtrade} will be able to 
build the URL itself. For the example above, we need to set the following options:{p_end}

{p 10 12}{stata comtrade api, maxdata(500) type(C) freq(A)  years(2017) reporterc(276) partnerc(0) traderegime(all) hs(HS) cl(2701) save("`c(pwd)'/GermanyCoal.dta")}{p_end}

{p 4 8}A maximum number of 500 observations ({it:maxdata(500)}) of commodities ({it:type(C)}) 
of yearly ({it:freq(A)}) for the year 2017 ({it:years(2017)}) is downloaded. 
{it:reportc} sets the reporting country and {it:partnerc} the partner(s).
{it:traderegime} specifies that all trade, i.e. export and imports and re-exports and re-imports,
for the {it:HS} code defined in {it:cl()}  are obtained.{p_end}

{p 4 8}The output will be the same as before:{p_end}

{col 12}{cmd: Number of observations found in dataset: 2}
{col 12}{cmd: File saved: ..../GermanyCoal.dta}

{p 4 8}{bf:Example 3: Using the records() option}{break}
To use the record function, the option {cmd:records()} is added.
For example if a list of all downloaded files is to be kept in the workfolder and the filename is {it:records}
and the same request as above is done:{p_end}

{p 10 12}{stata comtrade api, maxdata(500) type(C) freq(A) hs(HS) years(2017) reporterc(276) partnerc(0) traderegime(all) cl(2701) save("`c(pwd)'/GermanyCoal.dta") records("`c(pwd)'/Records.xlsx")}{p_end}

{p 4 8}The output is the following:{p_end}

{col 12}{cmd: New data published: 2018-08-23 00:00:00.}
{col 12}{cmd: Number of observations found in dataset: 2}
{col 12}{cmd: File saved using ..../GermanyCoal.dta}
{col 12}{cmd: Record list written to  ..../Records.xlsx}

{p 4 8}If the same command line from above is called again, {cmd:comtrade} will 
check if data is updated. If not (as it is the case here) it will issue the following messages:{p_end}

{col 12}{cmd: Getting records from file: ..../Records.xlsx, sheet: api}
{col 12}{cmd: 1 record(s) found.}
{col 12}{cmd: 1 match found.}
{col 12}{cmd: No update available. Both have date: 2018-08-23 00:00:00}

{p 4 8}To download for example peat trade, option {cmd:cl()} is changed from {bf:2701} to {bf:2703}.
In addition the saved dta should be appended and the download is logged and 
{cmd:api} omitted.{p_end}

{p 10 12}{stata comtrade, maxdata(500) type(C) freq(A) hs(HS) years(2017) reporterc(276) partnerc(0) traderegime(all) cl(2703) append("`c(pwd)'/GermanyCoal.dta") records("`c(pwd)'/Records.xlsx")}{p_end}

{p 4 8}The file will be downloaded and a new record added to the Excel file. 
The output reads:{p_end}

{col 12}{cmd: Getting records from file: ..../Records.xlsx, sheet: api}
{col 12}{cmd: 1 record(s) found.}
{col 12}{cmd: Number of observations found in dataset: 2}
{col 12}{cmd: File appended using ..../GermanyCoal.dta}
{col 12}{cmd: Record list written to  ..../Records.xlsx}

{p 4 8}The dataset will have 4 observations, two for each product for both years.{p_end}

{p 4 8}{bf:Example 4: Bulk download}{break}
To download a bulk file, the option {cmd:bulk} is used.
It is not necessary to specify the name of the dta under which the downloaded data is saved.
In addition, a authorization token is required.{p_end}

{p 4 8}For example, to download all trade data for Germany in 2017, the following command line is used:{p_end}

{p 10 12}{stata comtrade bulk, type(C) freq(A) hs(HS) years(2017) reporterc(276)  append("`c(pwd)'/GermanyCoalBulk.dta") records("`c(pwd)'/Records.xlsx") token(token)}{p_end}

{p 4 8}The output is the following:{p_end}

{col 12}{cmd: New Series found.}
{col 12}{cmd: New data published: 2018-08-23 00:00:00.}
{col 12}{cmd: File appended using ..../GermanyCoal.dta}
{col 12}{cmd: Record list written to  ..../Records.xlsx}

{p 4 8}{bf:Example 5: Loop and API download}{break}
{cmd:comtrade} can be used within a loop over multiple values of a parameter, for example years.
For example a loop can be used to retrieve coal trade of Germany for the years 1991 - 2018.
If no token is used, then a maximum number of 100 data requests per hour is allowed. 
{cmd:comtrade} can keep track of the number of requests and if the maximum 
per hour is reached, wait until further requests are allowed.
To track the number of requests, the options {cmd:starttime()} and {cmd:count()} are set.
Within the loop, the counter is changed using the value {cmd:r(count)}.
To save the data the option {cmd:append()} is used.
{p_end}

{p 4 8}The following code is used (please copy):{p_end}

{col 12}{cmd: local starttime "`c(current_time)'"}
{col 12}{cmd: local count = 0}
{col 12}{cmd: forvalues year = 1991(1)2018  {c -(} }
{col 14}{cmd: comtrade api, append(data) maxdata(500) type(C) freq(A) hs(HS) years(`year') reporterc(276) partnerc(0) traderegime(all) cl(2701) }
{col 20}{cmd: count(`count') starttime(`starttime')}
{col 14}{cmd: local count = r(count)}
{col 12}{cmd: {c )-}}

{p 4 8}{bf:Example 6: Download MBS data}{break}
To download Monthly Bulletin of Statistics ({browse "https://comtrade.un.org/data/doc/API_MBS":MBS})
the function {cmd:comtrade mbs} is used. 
The download requires to set the {cmd:series_type()} option, the {cmd:year} and
{cmd: country_type} options.
For specifications see the {browse "https://comtrade.un.org/data/doc/API_MBS":MBS webpage}.
The specifications can be obtain using {stata comtrade list} as well.{p_end}

{p 4 8}The {cmd:series_type} parameter contains information about the table number, frequency, 
type of measurement and currency. 
To follow the example from the website, the following command line is used:{p_end}

{col 12}{stata comtrade mbs , series_type("T35.A.V.$") country_code(842) year(2015)}

{p 4 8}To download footnotes, the option {cmd:footnote} is used. 
For the footnote, the options {cmd:table_type()} is required.{p_end}

{col 12}{stata comtrade mbs , footnote table_type("T35") }

{p 4 8}{bf:Example 7: List and download possible parameters}{break}
{cmd:comtrade} offers to download all possible values for parameters, 
such as country codes, classification codes,.... To obtain those, {cmd:comtrade} 
is called with the parameter {cmd:list}:{p_end}

{col 12}{stata comtrade list}

{p 4 8}gives the following output:{p_end}

{col 12}{com}. comtrade list
{col 12}The following lists for parameters are available:
{col 12}Title{col 48}Link
{col 13}***** API and Bulk *****
{col 13}1. Reporter/Partner Area{col 48}{stata comtrade list countries}
{col 13}2. Trade Regimes{col 48}{stata comtrade list regime}
{col 12}Classifications
{col 13}3. HS as reported{col 48}{stata comtrade list px HS}
{col 13}4. HS 1992{col 48}{stata comtrade list px H0}
{col 13}5. HS 1996{col 48}{stata comtrade list px H1}
{col 13}6. HS 2002{col 48}{stata comtrade list px H2}
{col 13}7. HS 2007{col 48}{stata comtrade list px H3}
{col 13}8. HS 2012{col 48}{stata comtrade list px H4}
{col 13}9. SITC as reported{col 48}{stata comtrade list px ST}
{col 12}10. SITC Rev. 1{col 48}{stata comtrade list px S1}
{col 12}11. SITC Rev. 2{col 48}{stata comtrade list px S2}
{col 12}12. SITC Rev. 3{col 48}{stata comtrade list px S3}
{col 12}13. SITC Rev. 4{col 48}{stata comtrade list px S4}
{col 12}14. Broad Econ. Cat. (BEC){col 48}{stata comtrade list px BEC}
{col 12}15. Extended Balance of paym.{col 48}{stata comtrade list px EB02}
{col 12}***** MBS *****
{col 12}16. Type of data series{col 48}{stata comtrade list mbs series_type}
{col 12}17. MBS Table numbers{col 48}{stata comtrade list mbs table_type}
{col 12}18. reference country/area{col 48}{stata comtrade list mbs MBSAreas}
{reset} 

{marker rclass}{title:Stored Values}

{p 4 8}The following values are stored in {cmd:r()}:{p_end}

{col 8}{cmd:r(validation)}{col 30}Validation Code
{col 8}{cmd:r(count)}{col 30}Number of requests
{col 8}{cmd:r(StartTime)}{col 30}Time of first request
{col 8}{cmd:r(PublicationDate)}{col 30}Publication date (earliest)
{col 8}{cmd:r(NumRecords)}{col 30}Number of records
{col 8}{cmd:r(FileSize)}{col 30}Size of file on disk
{col 8}{cmd:r(Filename)}{col 30}Filename of saved dta
{col 8}{cmd:r(uri)}{col 30}URL to request
{col 8}{cmd:r(downloaded)}{col 30}0 if no data downlaoded, 1 if data downloaded.


{marker about}{title:Author}

{p 4}Jan Ditzen (Heriot-Watt University){p_end}
{p 4}Email: {browse "mailto:j.ditzen@hw.ac.uk":j.ditzen@hw.ac.uk}{p_end}
{p 4}Web: {browse "www.jan.ditzen.net":www.jan.ditzen.net}{p_end}

{marker changelog}{title:Changelog}

{p 4 8}This version: 1.0{p_end}

{title:Acknowledgement}

{p 4 4}This program would not have been possible without William Buchanan
{help jsonio} command. 
For more information see {browse "https://github.com/wbuchanan"}.{break}
Thanks to the {browse "https://ceerp.hw.ac.uk/":CEERP} team for valuable feedback.
All errors are my own.{p_end}

{title:Also see}

{p 4 4}See also: {help jsonio}{p_end} 
