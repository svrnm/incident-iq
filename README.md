# Incident IQ

Push incidents created by health rule violations into the AppDynamics Event Service,
so you can run analytics over your incidents!

## Prerequisite

To use *Incident IQ* you need an AppDynamics Platform (either SaaS or on-premise), including
the Events Service and a valid license for transaction analytics.

Also, you need to have health rules created which will be your data basis.

## Installation

Download or clone this git repository. Next open the file [env.sh](env.sh) with your prefered editor and provide the following details:

- An Analytics API Key
- Your global account name
- Your analytics endpoint

Run [install.sh](install.sh) from your command line.
This script executes the following tasks:

- Creating the *incident_events* schema in Analytics
- (tbd) Creating the http action template to feed incident data into Analytics
- (tbd) Creating the business journey *incident_duration*

Afterwards you can go into your "Alert&Respond" section and connect those health rules, that should be feed into Analytics, with the newly created action template.

## Test with fake data

Since you probably don't want to wait for real incidents to test *Incident IQ*, you can use the script `fakeEvent.sh` to create some fake data. Run the following `code` on your command line to send fake data into Analytics:

```shell
while [ true ]; do ./fakeEvent.sh ${RANDOM:0:2} ${RANDOM:0:2}; done;
```

This will create fake data for the (non-existing) applications `Fake-ECommerce` and `Fake-Fulfillment`. Use this data to test ADQL queries or to build your incident reporting dashboards.

## Usage

With your incidents feed into Analytics, you cancreate dashboards, reports, ADQL queries and metrics. Below you will find a few examples and use cases.

### ADQL queries

- Number of incidents for the last 4 weeks:

```SQL
SELECT count(*) FROM incident_events SINCE 4 weeks
```

- Longest incident in minutes:

```SQL
SELECT max(totalTime)/(60*1000) AS 'minutes' FROM incident_duration
```

- Availability in %:

```SQL
SELECT 100-100*sum(totalTime)/(max(start_daysInMonth)*24*60*1000) AS '%' FROM incident_duration
```

## Limitations

- Computing the % of SLA violation in a given month requires a work around , therefore each event comes with a "daysInMonth" field, that allows you to know the length of the given month.
- Data is only stored for 90 days max in Analytics, even shorter in SaaS (8, 30, 60, 90 days). Create metrics with ADQL to store your data for a longer time.
- If for some reasons an incident is not ended properly, the duration count will never end. You can of course end the incident manually.
- If an incident should be ignored, the best way is implementing [Action Suppression](https://docs.appdynamics.com/display/latest/Action+Suppression). If you want to ignore an incident after it was logged, you can send a custom event with milestone `ignore` and change your queries accordingly.
