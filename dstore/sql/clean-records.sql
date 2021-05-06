--
-- Retain GHS-relevant records.sql
-- Mike Van Maele, Talus Analytics, LLC
-- mvanmaele@talusanalytics.com
-- 11 March 2020
--

-- Part A: Remove irrelevant transactions
-- No transactions with null sector codes (we don't know if they're GHS-
-- relevant)
delete from trans where trans_sector is null;

-- No transactions not on the list of sectors considered relevant. See Technical
-- Appendix online for list of sectors:
-- https://tracking.ghscosting.org/export/GIDA%20Technical%20Appendix.pdf
delete from trans where cast(trans_sector as integer) not in (12110, 12181, 12182, 12191, 12220, 12230, 12240, 12250, 12261, 12262, 12263, 12281, 13010, 13020, 13030, 13040, 13081, 31195, 16064, 32168);

-- No transactions with negative or null values (there is currently no robust
-- way to handle these because negative transactions are not displayed in the
-- tracking site and there is no way to track "canceled out" transactions).
-- delete from trans where trans_usd <= 0 or trans_usd is null;

-- No transactions that are not commitments, expenditures, or disbursements
-- (note that the latter two are considered equivalent in the Tracking site and
-- are simply referred to as "disbursements").
-- delete from trans where trans_code not in ('C', 'E', 'D') or trans_code is null;

-- No transactions for which the date of the transaction is unknown
-- delete from trans where trans_day is null;

-- Part B: Remove irrelevant activities (projects)
-- No activities which contain no transactions
delete from act where aid not in (select distinct aid from trans);

-- Part C: Ensure all transactions have a non-null country
-- Set trans_country to "_NONE_" if it is null. This step is required because
-- when these data are parsed and ingested into the Talus Tracking database,
-- the trans_country forms the primary key of each transaction along with
-- various other data fields.
update trans set trans_country = '_NONE_' where trans_country is null;


-- -- Part D: Remove irrelevant XSON records.
-- -- Create a new xson table containing only records that define participating
-- -- organizations, since that is the only XSON data used in the Talus Tracking
-- -- ingest script.
-- CREATE TABLE xson2 AS
-- SELECT *
-- FROM xson
-- where root = '/iati-activities/iati-activity/participating-org'
-- or root = '/iati-activities/iati-activity/recipient-region'
--
-- -- Create index on AID code to speed operations
-- create index XsonAid on xson2(aid)
