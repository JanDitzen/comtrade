*! comtrade version 1.01
*! Jan Ditzen
*! 2019

program define comtrade, rclass
	syntax [anything ], [ 						///
					///	program options 
					append(string) 			/// append dataset
					variables(string) 		/// obtains only specific variables
					load 					/// load data at end
					nocheck 				/// no check for validation
					ONLYVALIdation			/// check only
					save(string)			/// folder to save zip (only bulk) and dta. If API used, specify file name as well, if empty then current folder used	
					records(string)			/// path and filename of excel file contianing list with records when downloaded and updated
					force					/// force download. 
					SHOWVALIDation			/// show validation
					/// bulk specific options 			
					skipzip					/// do not unzip file, just download zip files
					/// parameters for json/web call 
					hs(string) 				/// hs cat.
					CLass(string) 			/// tradeclass
					REPORTERCountry(string) 	/// reportercountry
					REPORTCountry(string)	/// keep to make sure old do files work
					PARTNERCountry(string)  /// partnercountry
					maxdata(string)  		/// maximum numbers of records
					type(string)  			/// type
					freq(string) 			/// frequencey
					TRADERegime(string) 	/// trade regime
					imts(string)			/// imts
					YEARs(string) 			/// years [for MBS use as well!]
					///MBS
					footnote				/// for footnote download
					series_type(string)		/// Type of data series: combination of table number, frequency, type of measurement and currenty
					table_type(string)		/// MBS Table numbers
					country_code(string)  	/// reference country/area
					///period_type(string)		/// data set frequency:
					///period(string)			/// time period (default = any):Regardless the frequency					
					/// URL
					url(string) 			/// use url	
					/// Validation
					token(string)			/// validation token					
					/// internal options for reverse calls 
					count(string) 			/// internal: counter for multiple tries
					starttime(string) 		/// intital start time 
					maxcount(string) 		/// maximum number of counts
					/// list settings		
					listall					/// list all
					]
		version 14
		clear
		qui {
			local cmd_line `*'
			tokenize `anything'
			if "`1'" == "" {
				local dltype "api"
				
			}
			else if "`1'" != "list" {
				local dltype "`anything'"
			}
			*** Own block if list used
			else if "`1'" == "list" {
				*tokenize `anything'
			
				if "`2'" == "partner" {
					local amend "partnerAreas"
				}
				if "`2'" == "reporter" {
					local amend "reporterAreas"
				}
				else if "`2'" == "px" {
					local amend "classification`3'"					
				}
				else if "`2'" == "regime" {
					local amend "tradeRegimes"
				}
				else if "`2'" == "mbs" {
					local amend "`3'"
				}
				else if "`2'" == "" {
					*** Output if only list used, i.e. if 2 is empty.
					noi disp "The following lists for parameters are available:"
					noi disp _col(3) "Title" _col(35) "Link"
					noi disp in smcl _col(3) "***** API and Bulk *****"
					noi disp in smcl _col(4) "1. Reporter Area" _col(35) "{stata comtrade list reporter}"
					noi disp in smcl _col(4) "2. Partner Area" _col(35) "{stata comtrade list partner}"
					noi disp in smcl _col(4) "3. Trade Regimes" _col(35) "{stata comtrade list regime}"
					noi disp _col(3) "Classifications"
					mata classtypes = ("HS as reported","HS 1992","HS 1996","HS 2002","HS 2007","HS 2012","SITC as reported","SITC Rev. 1","SITC Rev. 2","SITC Rev. 3","SITC Rev. 4","Broad Econ. Cat. (BEC)","Extended Balance of paym.")
					local i = 4
					foreach type in HS H0 H1 H2 H3 H4 ST S1 S2 S3 S4 BEC EB02 {
						mata st_local("strType",classtypes[`i'-2])
						if `i' < 10 {
							local col "4"
						}
						else {
							local col "3"
						}
						noi noi disp in smcl _col(`col') "`i'. `strType'" _col(35) "{stata comtrade list px `type'}"
						local i = `i' + 1
					}
					noi disp in smcl _col(3) "***** MBS *****"
					mata classtypes = ("Type of data series" ,"MBS Table numbers","reference country/area")
					local s = `i'
					foreach type in series_type table_type MBSAreas {
						mata st_local("strType",classtypes[`i'-`s'+1])
						if `i' < 10 {
							local col "4"
						}
						else {
							local col "3"
						}
						noi noi disp in smcl _col(`col') "`i'. `strType'" _col(35) "{stata comtrade list mbs `type'}"
						local i = `i' + 1
					}
					exit
				}
				clear
				capture jsonio kv, file("https://comtrade.un.org/data/cache/`amend'.json")
				
				if _rc != 0 {
					noi disp "Error, try again"
					exit
				}
				split key , parse("/")
					
				drop if key4 == ""
				keep key4 value
				if key4[2] == "text" {
					gen id = value[_n-1] if key4 == "text"
					keep if id != ""
					local vars ""
				}
				else {
					local tabtype = key4[1]
					
					if "`tabtype'" ==  "series_type" { 
						gen id1 = value[_n+1] if key4 == "`tabtype'"
						gen id2 = value[_n+2] if key4 == "`tabtype'"
						gen id3 = value[_n+3] if key4 == "`tabtype'"
						gen id4 = value[_n+4] if key4 == "`tabtype'"
						
						keep if id4 != ""
						local vars "multiple"
					}
					else {
						gen id = value[_n+1] if key4 == "`tabtype'"
						keep if id != ""
						** swap id and value
						rename id valuei
						rename value id
						rename valuei value
					}
					
				}
				***
				
				
				drop key4

				if _N > 50 & "`listall'" == "" {
					noi comtrade_show value id* , `vars'
					noi display "More than 50 observations, only 50 first shown."
					noi display "To show all, type:"
					noi display in smcl "{stata list}" , _c
					noi display " or " , _c
					noi display in smcl "{stata comtrade `cmd_line' , listall}" 
				}
				else {
					noi comtrade_show value id*, listall `vars' 
				}
				
				exit
				
			}			
			** Now main part! List ends here.					
			
			if "`reportcountry'" != "" {
				local reportercountry "`reportcountry'"
			}
			if "`maxcount'" == "" {
				local maxcount = 100
			}
			if "`starttime'" == "" {
				local starttime "`c(current_time)'"
			}
			if "`token'" == "" {
				local token ""
			}
			else {
				local tokenBulk "?token=`token'"
				local token "&token=`token'"
			}
			if "`dltype'" == "mbs" {
				local check "nocheck"
			}
			if "`check'" != "" {
				local force "force"
			}
			if "`records'" == "" {
				local force "force"
			}
			if "`append'" != "" {
				local appendfile = subinstr("`append'",".dta","",.)
				local appendfile  "`appendfile'.dta"
			}
			if "`count'" == "" {
				local count = 0
			}
			**** Check if jsonio is installed
			capture which jsonio
			if _rc != 0 {
				noi disp "jsonio not installed. Please install from:"
				noi disp in smcl `"{stata "net inst jsonio, from(https://wbuchanan.github.io/StataJSON) replace "}"'
				exit
			}
			**** check if folder defined, if not, then define it
			if "`save'" == "" {
				local save "`c(pwd)'"
				if "`dltype'" == "api" {
					local stamp =subinstr(subinstr("`c(current_time)' `c(current_date)'",":","-",.),".","-",.)
					local save "`save'/Comtrade `stamp'"
				}
			}
			
			***** all parameters have values
			local fail = 1
			if "url" == "" {
				if "`dltype'" == "api" {
					if "`hs'" != "" & "`class'" != "" & "`reportercountry'" != "" & "`partnercountry'" != "" & "`maxdata'" != "" & "`type'" != "" & "`freq'" != "" & "`traderegime" != "" & "`years'" != "" {
						local fail = 0
					}
					else {
						local fail = 1
					}
				}
				else if "`dltype'" == "bulk" {
					if "`hs'" != "" & "`reportercountry'" != "" & "`type'" != "" & "`freq'" != "" & "`years'" != "" {
						local fail = 0
					}
					else {
						local fail = 1
					}
				}
				else if "`dltype'" == "mbs" {
					if "`footnote'" == "" {
						if "`series_type'" != "" & "`table_type'" != "" & "`series_type'" != "" & "`country_code'" != "" &  "`years'" != "" { 
							local fail = 0
						}
						else {
							local fail = 1
						}
					}
					else {
						if "`table_type'" != "" & "`country_code'" != "" {
							local fail = 0
						}
						else {
							local fail = 1
						}
					}
				}
			}
			else {
				local fail = 0
			}
			if `fail' == 1 {
				noi disp "Not all parameters specified, or use option url()."
				exit
			}
			
			***** validation of request
			if ("`check'" == "" & "`url'" == "")  { 
				if "`dltype'" == "api" { 
					local validation "https://comtrade.un.org/api//refs/da/view?r=`reportercountry'&px=`hs'&ps=`years'&p=`partnercountry'&rg=`traderegime'&cc=`class'&max=`maxdata'&type=`type'&freq=`freq'`token'"
				}
				else if "`dltype'" == "bulk" { 
					local validation "https://comtrade.un.org/api//refs/da/bulk?r=`reportercountry'&px=`hs'&ps=`years'&freq=`freq'&type=`type'`token'"
				}
				
				*no count here as validation! local count = `count' + 1
				capture noi jsonio kv, file("`validation'")
				if _rc == 0 {
					split key , parse("/")
					egen group = group(key2)
					drop key1 key2 key
					rename key3 type
					** show validation
					if "`showvalidation'" != "" {
						noi list type value
					}	
					
					*** check number of different request blocks					
					reshape wide value , i(group) j(type) string
					rename value* _*
					rename _r rtCode
					rename _ps period
					destring period rtCode, replace
					tempfile validation
					save `validation', replace
					
					** Write back					
					rename rtCode r
					rename period ps
					rename _* *
					tostring ps r, replace
					
					** New sort and keep only first value (should be oldest)
					sort publicationDate					
					keep in 1
					rename * value*
					rename valuegroup group
					reshape long value , i(group) j(type) string
					
					*** Put data in mata as quicker to get specific values
					putmata desc = (type value ), replace
					mata st_local("PublicationDate",desc[selectindex(desc[.,1]:=="publicationDate"),2])
					
					*Records
					if "`dltype'" == "api" { 
						mata st_local("NumRecords",desc[selectindex(desc[.,1]:=="TotalRecords"),2])
						mata st_local("api_1",desc[selectindex(desc[.,1]:=="type"),2])
						mata st_local("api_2",desc[selectindex(desc[.,1]:=="freq"),2])
						mata st_local("api_3",desc[selectindex(desc[.,1]:=="px"),2])
						mata st_local("api_4",desc[selectindex(desc[.,1]:=="r"),2])
						mata st_local("api_5",desc[selectindex(desc[.,1]:=="ps"),2])
						mata key = "`api_1'_`api_2'_`api_3'_`api_4'_`api_5'_`class'"
						local key  "`api_1'_`api_2'_`api_3'_`api_4'_`api_5'_`class'"
					}
					else if "`dltype'" == "bulk" {
						mata st_local("filesize",desc[selectindex(desc[.,1]:=="filesize"),2])
						mata st_local("uri",desc[selectindex(desc[.,1]:=="downloadUri"),2])
						mata st_local("FileName",desc[selectindex(desc[.,1]:=="name"),2])
						mata key = "`uri'"
						local key  "`uri'"
					}
				}
				else {
					noi disp "Cannot validate."
					return local validation "`validation'"
					return scalar count = `count'
					return local StartTime "`starttime'"
					exit
				}
			}
			
			*noi disp "KEY:: `key' - `uri'"
			**** If only validation end here
			if "`onlyvalidation'" != "" {
				return local PublicationDate "`PublicationDate'"
				if "`dltype'" == "api" { 
					return local NumRecords "`NumRecords'"
				}
				else if "`dltype'" == "bulk" {
					return local FileSize "`filesize'"
					return local uri "`uri'"
					return local FileName "`FileName'"
				}
				noi list type value
				return scalar downloaded = 0
				return local validation "`validation'"
				exit
			}
			
			
			**** Load dataset with time stamps and check if updates
			if "`records'" != "" {
				local Sheet "bulk"
				if "`dltype'" == "api" {
					local Sheet "api"
				}
				if fileexists("`records'") == 1 {
					
					mata records = OpenExcel("`records'","`Sheet'")
					
					** Check if records has a value
					mata st_local("cols_rec",(records[1,1]))
					
					if "`cols_rec'" == "#" {
						
						mata st_local("tmp_num",strofreal(rows(records)-1))
						noi disp "Getting records from file: `records', sheet: `Sheet'"
						noi disp "`tmp_num' record(s) found."
						if `tmp_num' > 0 {
							mata tmp_index = selectindex(records[.,2]:==key)
							mata tmp = records[tmp_index,.]
							mata st_local("tmp_num",strofreal(rows(tmp)))					

							if `tmp_num' > 1 {
								noi disp "More than one row identified in storage file. Please check."
								exit
							}
							else if `tmp_num' == 1 {
								noi display "1 match found."
								mata st_local("PubDateSaved",tmp[1,4])
								/// remove T from PubDateSource
								local PubDateSaved = subinstr("`PubDateSaved'","T"," ",.)
							}
						}	
						else {
							local PubDateSaved = ("`c(current_date)' `c(current_time)'")
						}
					}
					else {
						local PubDateSaved = ("`c(current_date)' `c(current_time)'")
						mata mata  drop records
						local tmp_num = -1 
					}
				}
				else {
					local tmp_num = -1 
					local PubDateSaved = ("`c(current_date)' `c(current_time)'")
				}
				
			}
			*noi disp "`tmp_num' tmpnum"
			*** Check publication dates. If date same as obtained from validation, stop.
			if "`force'" == "" {
				
				local PublicationDate = subinstr("`PublicationDate'","T"," ",.)
				local PubDateValidationClock = clock("`PublicationDate'","YMDhms")
				local PubDateSavedClock = clock("`PubDateSaved'","DMYhms")
				if "`PubDateSavedClock'" == "." {
					local PubDateSavedClock = clock("`PubDateSaved'","YMDhms")
				}
				*noi disp "Valida `PubDateValidationClock' - `PublicationDate' vs Saved `PubDateSavedClock' - `PubDateSaved'"
				if `PubDateValidationClock' >= `PubDateSavedClock' {
					noi disp "No update available. Both have date: `PublicationDate'"
					return scalar downloaded = 0
					*noi list
					exit
				}
				if `tmp_num' == 1 {
					noi disp "Update found. "
					noi disp "Old data published: `PubDateSaved'."
					noi disp "New data published: `PublicationDate'."
				}
				else if `tmp_num' == -1 {
					noi disp "New Series found."
					noi disp "New data published: `PublicationDate'."
				}
			}
			
			
			**** Build URL			
			if "`url'" == "" {	
				** Check that all options are used
				if "`imts'" != "" {
					local imts "&imts=`imts'"
				}
				if "`dltype'" == "api" { 
					local quest "https://comtrade.un.org/api/get?r=`reportercountry'&px=`hs'&ps=`years'&p=`partnercountry'&rg=`traderegime'&cc=`class'&max=`maxdata'&type=`type'&freq=`freq'&fmt=json`imts'`token'"
				}
				else if "`dltype'" == "bulk" { 
					local quest "https://comtrade.un.org/`uri'`tokenBulk'"
				}
				else if "`dltype'" == "mbs" {
					if "`footnote'" == "" {
						*local quest "https://comtrade.un.org/api/getMBSData?series_type=`series_type'&table_type=`table_type'&country_code=`country_code'&period_type=`period_type'&period=`period'&year=`years'&fmt=json"
						local quest "https://comtrade.un.org/api/getMBSData?series_type=`series_type'&country_code=`country_code'&year=`years'&fmt=json"
					}
					else {
						local quest "https://comtrade.un.org/api/getMBSFootNote?table_type=`table_type'&fmt=json"
					}	
				}
				noi disp "`quest'"
			}
			else {
				if strmatch("`url'","*comtrade*") == 1 {
					local quest "`url'"
				}
				else {
					local quest "https://comtrade.un.org`url'"
				}
			}
			clear
			if "`token'" == "" {
				local currentTime =clock("`c(current_time)'","hms")
				local ss_time = clock("`starttime'","hms")
				local Difference = `currentTime' - `ss_time'
				* time in ms. 1hour has 60*60*1000 ms
				if `Difference' < `=60*60*1000' & `count' > `maxcount' {
					local Difference2 = 60*60*1000 - `Difference'
					noi disp "Maximum number of requests in the last hour. Wait for `=`Difference2'/60/1000' minutes."
					sleep `Difference2'
					local starttime "`c(current_time)'"
					local count = 0
				}			
				
			}
			
			*** Download - API and records > 0
			local UpdateRecords = 0
			
			if "`dltype'" == "api" | "`dltype'" == "mbs" {
				local count = `count' + 1
				
				capture noi jsonio kv, file("`quest'")
				
				if _rc != 0 {
					* indicates that start time changed
					local change = 0
					if _rc == 1 {
						noi disp "Error, likely maximum number of requests per hour reached."
						local currentTime =clock("`c(current_time)'","hms")
						local ss_time = clock("`starttime'","hms")
						local Difference = `currentTime' - `ss_time'
						** time in ms. 1hour has 60*60*1000 ms
						if `Difference' < `=60*60*1000'  {
							local Difference2 = 60*60*1000 - `Difference'
							noi disp "Wait for `=`Difference2'/60/1000' minutes."
							sleep `Difference2'
							local starttime "`c(current_time)'"
							local count = 0
							local change = 1
						}							
					}
					else {
						noi disp "Error, wait for 5s and start again."
						sleep 5000	
					}
					local cmd_line = subinstr(`"`cmd_line'"',",","",.)
					
					tokenize `cmd_line'
					while "`1'" != "" {
						* Update counter
						if strmatch("`1'","count(*") == 1 {							
							local cmd `"`cmd' count(`count')"'
						}
						else if strmatch("`1'","starttime(*") == 1 & `change' == 1 {
							local cmd `"`cmd' starttime(`starttime')"'
						}
						else {
							local cmd `"`cmd' `1'"'
						}
						macro shift
					}
					
									
					
					comtrade `cmd'
					
					
				}
				
				split key , parse("/")
				rename key2 subset 
				rename key3 id
				replace id = subinstr(id,"id_","",.)
				rename key4 code
				
				keep subset code value id
				
				** create tag to keep specific values
				gen tag = 0
				replace tag = 1 if subset == "validation" 
				
				*replace id if validation
				
				if "`variables'" == "" {
					levelsof code
					foreach var in `r(levels)' {
						replace tag = 1 if subset == "dataset" & code == "`var'"
					}
				}
				else {
					foreach var in `variables' {
						replace tag = 1 if subset == "dataset" & code == "`var'"
					}
				}
				
				putmata desc = (code value id) if subset == "validation", replace
				
				mata st_local("status",desc[selectindex((desc[.,1]:=="value"))[1],2])
				mata st_local("description",desc[selectindex(desc[.,1]:=="description"),2])
				mata st_local("num_obs",desc[selectindex((desc[.,1]:=="value"))[2],2])
				/*
				
				local status "`=value[1]'"
				local description "`=value[2]'"
				local num_obs = "`=value[3]'"
				drop if id == "0"
				*/
				qui keep if tag
				replace id = "0" if subset == "validation"
				drop if id == "0"				
				drop tag 
				
				noi disp "Number of observations found in dataset: `num_obs'"
				local NumRecords = `num_obs'
				** Case all good, save data
				if "`num_obs'" > "0" & "`status'" == "0" {
					*replace value = strtoname(value)
					rename value v_
					reshape wide v_ , i(id) j(code) string
					
					rename v_* * 	
					
					drop id subset
					
					
					** destrict specific vars
					foreach var in TradeQuantity cmdCode ptCode rtCode qtCode yr AltQuantity CIFValue FOBValue GrossWeight IsLeaf NetWeight TradeQuantity TradeValue cmdCode cstCode estCode motCode period pfCode ptCode ptCode2 qtAltCode qtCode rgCode rtCode  {
						capture destring `var' , replace
					}
					
					** merge with validation dataset
					if "`check'" == "" {
						merge m:1 period rtCode using `validation'
						
						** make sure all data matched
						capture assert _merge == 3
						
						if _rc != 0 {
							noi disp "Some validation data was not able to be matched to downloaded data!"
						}
						drop _merge
						gen _DownloadDate = "`c(current_time)' `c(current_date)'"
					}
					capture drop yr group
					if "`append'" != "" {
						if fileexists("`appendfile'") == 1 {
							append using "`append'", force
						}
						save "`append'", replace
						local FileToOpen "`append'"
						noi disp "File appended using `append'"
					}
					else {
						save "`save'", replace
						local FileToOpen "`save'"
						noi disp "File saved using `save'"
						
					}
					local UpdateRecords = 1
				}
				else {
					noi disp "Nothing to save."
				}
				
				
			}
			
			**** BULK download and processing
			else if "`dltype'" == "bulk" {
				*noi disp "copy from `quest' to `save'/`FileName'"
				capture copy "`quest'" "`save'/`FileName'.zip", replace
				if _rc == 679 {
					noi disp "Web Error 409. Either a usage limit is hit or no authorisation code used."
					error 679
				}
				else if _rc != 0 {
					noi disp "Error `_rc'. Not possible to download and save bulk zip file."
					error _rc
				}
				local count = `count' + 1
				if "`skipzip'" == "" {
					local pwd_old "`c(pwd)'"
					cd "`save'"
					unzipfile "`save'/`FileName'.zip", replace
					
					local FileNameCSV = subinstr("`FileName'",".zip","",.)
					import delimited "`save'/`FileNameCSV'.csv", clear
					local NumRecords = _N
					if "`append'" == "" {
						save "`FileNameCSV'", replace
						local FileToOpen "`FileNameCSV'"
						noi disp "File saved using `FileNameCSV'"
					}
					else {						
						if fileexists("`appendfile'") == 1 {
							append using "`append'", force
							
						}
						save "`append'", replace
						local FileToOpen "`append'"
						noi disp "File appended using `append'"
					}
					cd "`pwd_old'"
					local UpdateRecords = 1
				}
			}
			
			
			*** Write Excel Record file
			if "`records'" != "" {
				if `tmp_num' == 1 {
					** update colum
					mata records[tmp_index,(2,4,5)] = ("`key'","`PublicationDate'","`c(current_date)' `c(current_time)'")
				}
				else if `tmp_num' == 0 {
					** Add new colum
					if "`dltype'" == "api" {
						local third "`NumRecords'"
					}
					else {
						local third "`FileName'"
					}
					mata records = (records \ (strofreal(rows(records)-1) , "`key'" , "`third'" , "`PublicationDate'" , "`c(current_date)' `c(current_time)'"))
				}
				else if `tmp_num' == -1 {
					** build new matrix
					if "`dltype'" == "api" {
						mata records = ("#","key","# records","Publication Date","Download Date")
						local third "`NumRecords'"
					}
					else {
						mata records = ("#","uri","File Name","Publication Date","Download Date")
						local third "`FileName'"
					}
					mata records = (records \ ("1" , "`key'" , "`third'" , "`PublicationDate'" , "`c(current_date)' `c(current_time)'"))
				}
				
				** Save
				mata WriteExcel("`records'","`Sheet'",records)
				*noi mata records
				noi disp "Record list written to " , _c
				noi disp in smcl `"{browse "`records'"}"' 
			}
		
			*** Returns 
			return local PublicationDate "`PublicationDate'"
			return local NumRecords "`NumRecords'"
			return local validation "`validation'"
			return local url "`quest'"
		
			if "`dltype'" != "bulk" {
				return local FileSize "`filesize'"
				return local url "`uri'"
				return local FileName "`FileName'"
			}
			
			return scalar count = `count'
			return local StartTime "`starttime'"
			return scalar downloaded = `UpdateRecords'
			
		** qui end
		}		
		
		if "`load'" == "load" & `UpdateRecords'== 1 {
			use "`FileToOpen'", clear
		}	
		
end



mata:
	function OpenExcel (string scalar path , string scalar sheet)
	{
		class xl scalar   b
		string scalar pathxlsx
		/// make sure path doesnt include xlsx
		
		path = subinstr(path,".xlsx","",.)
		pathxlsx = path + ".xlsx"
		
		if (fileexists(pathxlsx) == 1) {
				b = xl()
				b.load_book(pathxlsx)
				if (sum(b.get_sheets():==sheet):>0) {
					
				
								
					b.set_sheet(sheet)
					
					output = J(0,5,"")
					i = 1
					check = b.get_string(i,(1,5))
					while (check[1,1]:~="") {
						check
						output = (output \ check)
						i = i + 1
						check = b.get_string(i,(1,5))
					}
					
					
					
			}
			else {
					output = "0"
			}
			return(output)
			b.close_book()
		}
		
		
	}
end


mata:
	function WriteExcel (string scalar path , string scalar sheet , string matrix content)
	{
		class xl scalar   b
		string scalar pathxlsx
		/// make sure path doesnt include xlsx		
		path = subinstr(path,".xlsx","",.)
		pathxlsx = path + ".xlsx"
		
		b = xl()
		if (fileexists(pathxlsx) == 0) {
			"create"
			b.create_book(pathxlsx, sheet , "xlsx")
			
		}
		else {
			b.load_book(pathxlsx)
		}
		/// check if sheet exists
		if (sum(b.get_sheets():==sheet):==0) {
			b.add_sheet(sheet)
		}
		b.set_sheet(sheet)
		b.put_string(1,1,content)
		
		collen = colmax(strlen(content))
		
		for (i=1;i<=cols(content);i++) {
			b.set_column_width(i,i,collen[i])
		}
		
		
		b.close_book()
	}
end	

program define comtrade_show 
syntax varlist , [listall multiple]
	tokenize `varlist'
	*noi disp "`varlist'"
	if "`multiple'" != "" {
		tokenize `varlist'
		local currencytype "`5'"
		local seriestype "`1'"
		local tabletype "`2'"
		local periodtype "`3'"
		local valuetype "`4'"
		*noi disp "`currencytype' = `tabletypedesc'"
		
		tempname tab1 tab2 tab3
		gen `tab1' = strlen(`seriestype')
		qui sum `tab1'
		local tab1l = r(max)
		
		gen `tab2' = strlen(`tabletype')
		qui sum `tab2'
		local tab2l = r(max)
		
		gen `tab3' = strlen(`valuetype')
		qui sum `tab3'
		local tab3l = r(max)
		
		if `=`tab1l' + `tab2l' + `tab3l' + 4 * 3 + 2* 8' > c(linesize) {
					local tab1l = round(`tab1l' / ( `tab1l' + `tab2l' + `tab3l' + 4 * 3 + 2* 3) * `c(linesize)')
					local tab2l = round(`tab2l' / ( `tab1l' + `tab2l' + `tab3l' + 4 * 3 + 2* 3) * `c(linesize)')
					local tab3l = round(`tab2l' / ( `tab1l' + `tab2l' + `tab3l' + 4 * 3 + 2* 3) * `c(linesize)')
		}
		
		noi disp in smcl _col(2) "Series Type" 			_col(`=`tab1l'+3') "{c |}" " Table Type" 			_col(`=`tab1l'+3+`tab2l'') "{c |}" " Value" 					_col(`=`tab1l'+3+`tab2l'+3+`tab3l'') "{c |}" " Period" 					_col(`=`tab1l'+3+`tab2l'+3+`tab3l'+3+8') "{c |}" " Currency"
		noi disp in smcl _col(2) "{hline `=`tab1l'+1'}" _col(`=`tab1l'+1') "{c +}" "{hline `=`tab2l'-1'}"  	_col(`=`tab1l'+3+`tab2l'') "{c +}" "{hline `=`tab3l'+2'}"  		_col(`=`tab1l'+3+`tab2l'+3+`tab3l'') "{c +}" "{hline `=8+2'}" 			_col(`=`tab1l'+3+`tab2l'+3+`tab3l'+3+8') "{c +}" "{hline `=8+3'}" 
		local N = 50
		if "`listall'" != "" {
			local N = _N
		}
		if `tab1l' < 3 {
			local tab1l = 3
		}
		if `tab2l' < 3 {
			local tab2l = 3
		}
		if `tab3l' < 3 {
			local tab3l = 3
		}
		forvalues i = 1(1)`N' {
			noi disp in smcl _col(2) abbrev(`seriestype'[`i'],`tab1l') _col(`=`tab1l'+3') "{c |}"   abbrev(`tabletype'[`i'],`tab2l') _col(`=`tab1l'+3+`tab2l'') "{c |}"  abbrev(`valuetype'[`i'],`=`tab3l'-2') _col(`=`tab1l'+3+`tab2l'+3+`tab3l'') "{c |}"  abbrev(`periodtype'[`i'],8) _col(`=`tab1l'+3+`tab2l'+3+`tab3l'+3+8') "{c |}"  abbrev(`currencytype'[`i'],8) 
		}
		
		
	}
	else {
		local text "`1'"
		local code "`2'"
	
		** get maximum string length of code and text
		tempvar codelen textlen
		
		gen `codelen' = strlen(`code')
		qui sum `codelen'
		local codemax = `r(max)'
		
		if `codemax' < 4 {
			local codemax = 4
		}
		
		gen `textlen' = strlen(`text')
		qui sum `textlen' 
		local textmax = `r(max)'
		
		local tab1 = 2 + `codemax' + 2
		local tab2 = c(linesize) - `tab1'
		
		noi disp in smcl _col(2) "Code" _col(`=`tab1'-1') "{c |}"  _col(`=`tab1'+1') "Description"
		noi disp in smcl _col(2) "{hline `=`tab1'-3'}" _col(`=`tab1'-1') "{c +}"  _col(`tab1') "{hline `tab2'}" 
		local N = 50
		if "`listall'" != "" {
			local N = _N
		}
		forvalues i = 1(1)`N' {
			noi disp in smcl _col(2) `code'[`i'] _col(`=`tab1'-1') "{c |}"  _col(`=`tab1'+1') abbrev(`text'[`i'],`tab2')
		}
	}
end
