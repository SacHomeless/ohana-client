Command-line client for using the Ohana API.

At the moment, this uploads a set of EBT records from a csv file.


Example upload of EBT:

./ohana_client -e -f ../Hack4Sac/data/federal_ebt_data.csv


Example purge of all EBT records

./ohana_client --purge-ebt
