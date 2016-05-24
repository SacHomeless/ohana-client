## Command-line client for using the Ohana API.

At the moment, this uploads a set of EBT records from a csv file.


Example upload of EBT:

./ohana_client -e -f ../Hack4Sac/data/federal_ebt_data.csv

Example purge of all EBT records  (will remove ALL locatoins under the EBT organization)

./ohana_client --purge-ebt

Example upload of WIC:

./ohana_client -w -f ../Hack4Sac/data/wic_authorized_vendors.csv

Example purge of all WIC records   (will remove ALL locatoins under the WIC organization)

./ohana_client --purge-wic  

Example upload of Sacramento area food closets data (has a number of parins components tailored for the data)

./ohana_client -p -f ../Hack4Sac/data/wic_authorized_vendors.csv

Example purge of all WIC records  (will remove ALL locatoins under the food organization)

./ohana_client --purge-food



## Formatting
Formats for the csv files used to load sacsos.org during the Hackathon.  AN identical format could be used to load other counties.
The examples below are changable by altering the ruby scripts in the siste project SacHomeless/ohana-client: https://github.com/SacHomeless/ohana-client
See that porject for example scripts to load these files.


../Hack4Sac/data/federal_ebt_data.csv

Store_Name,Longitude,Latitude,Address,Address Line #2,City,State,Zip5,Zip4,County

"CIRCLE K STORE 8103",-80.082291,32.720379,"3603 Maybank Hwy","","Johns Island",SC,"29455","4825","CHARLESTON"

 ../Hack4Sac/data/food_by_zip_code.csv <==

Note- This information is updated periodically. Sacramento Food Bank & Family Services relies on partner agencies to help provide us with current,,,,,,,
information. Please call ahead if possible to verify details and eligibility.,,,,,,,

 ../Hack4Sac/data/wic_authorized_vendors.csv <==

Vendor,Address,Second Address,City,Zip Code,County,Location

11-C SUPERMARKET, 661 ROBERT'S LN,  ,BAKERSFIELD,93308, KERN,"(35.408042, -119.03373)"
