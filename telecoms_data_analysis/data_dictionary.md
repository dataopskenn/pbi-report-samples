# FactTable Data Dictionary

Each record in the FactTable represents a single measurement event or usage snapshot for a customer. These records capture both network performance and customer engagement metrics.

## Identification & Foreign Keys

#### FactID

Data Type: Integer
Description: A unique identifier for each record in the FactTable.
How It’s Generated: Automatically assigned (e.g., via sequential numbering) when a new record is created by the ETL process or data ingestion tool (such as Microsoft SQL Server Integration Services [SSIS]).

#### CustomerID

Data Type: Integer
Description: Links this record to a customer in the Customer Dimension.
How It’s Collected: Sourced from the customer registration system or CRM (for example, Salesforce or Microsoft Dynamics).

#### TimeID

Data Type: Integer
Description: Links this record to a specific time entry in the Time Dimension.
How It’s Collected: Derived from the timestamp when the event is recorded (often through automated data pipelines using tools like Apache NiFi or Informatica).

#### LocationID

Data Type: Integer
Description: Indicates where the network performance data was captured by linking to the Location Dimension.
How It’s Collected: Data is collected from network infrastructure (e.g., cell towers or base stations), often using network management systems like Cisco Prime Infrastructure or Nokia NetAct.

#### NetworkTypeID

Data Type: Integer
Description: Identifies the network technology in use (e.g., 3G, 4G, 5G).
How It’s Collected: Automatically determined by the customer’s device when connecting to the network and logged via mobile network operation systems (such as Ericsson OSS).

#### CustomerSegmentID

Data Type: Integer
Description: Categorizes the customer (e.g., Retail, Business, High-Value, Prepaid, or Postpaid) by linking to the Customer Segment Dimension.
How It’s Collected: Derived from customer profiles in CRM systems like Salesforce or customer billing systems such as Oracle Billing and Revenue Management (BRM).


## Network Performance Metrics
These fields measure how well the network is performing at the time of the recorded event.

#### Uptime

Data Type: Decimal (Percentage)
Description: The percentage of time the network was operational during the measurement period.
How It’s Measured: Calculated using network monitoring tools such as SolarWinds Network Performance Monitor (NPM) which track service availability.

#### Downtime

Data Type: Decimal (Percentage)
Description: The percentage of time the network was unavailable during the measurement period.
How It’s Measured: Either recorded directly by outage detection systems (like Nagios) or computed as 100% minus the uptime.

#### CallDropRate

Data Type: Decimal (Percentage)
Description: The percentage of initiated voice calls that are unexpectedly terminated.
How It’s Measured: Recorded using call detail record (CDR) analysis tools such as those offered by Ericsson or Nokia’s OSS systems.

#### Latency

Data Type: Decimal (Milliseconds)
Description: The time delay between sending a request and receiving a response over the network.
How It’s Measured: Captured using network diagnostic tools like Wireshark or iPerf; lower values indicate a more responsive network.

#### Throughput

Data Type: Decimal (Mbps)
Description: The rate at which data is successfully transmitted through the network.
How It’s Measured: Calculated by tools such as iPerf or network monitoring systems like PRTG Network Monitor, which measure the volume of data transferred per second.

#### SignalStrength

Data Type: Decimal (dBm)
Description: Indicates the power level of the received signal and is a key measure of connection quality.
How It’s Measured: Collected by mobile devices and network equipment using diagnostic tools (for example, Qualcomm’s Mobile Insights or built-in diagnostics in smartphones).

#### DataErrorRate

Data Type: Decimal (Percentage)
Description: The percentage of data packets that contain errors.
How It’s Measured: Determined by comparing error packet counts with total packet counts, often using tools such as Wireshark or Cisco Prime.

#### PacketLoss

Data Type: Decimal (Percentage)
Description: The percentage of data packets that are lost in transit.
How It’s Measured: Monitored using network diagnostics tools like SolarWinds or PRTG Network Monitor.

#### Jitter

Data Type: Decimal (Milliseconds)
Description: The variability in time delay between packets. High jitter can negatively affect real-time applications like voice or video calls.
How It’s Measured: Measured by calculating the standard deviation of latency over time using tools like iPerf or Netalyzr.

#### NetworkAvailability

Data Type: Decimal (Percentage)
Description: Overall percentage of time that the network service is available to users.
How It’s Measured: Derived from uptime metrics, often monitored using systems such as SolarWinds or Nagios.


## Customer Engagement Metrics
These fields capture how customers interact with the network and their overall satisfaction.

#### DataUsage

Data Type: Decimal (Megabytes or Gigabytes)
Description: The volume of data used by a customer during the measurement period.
How It’s Measured: Logged by data aggregation systems within billing platforms such as Oracle BRM or through network data usage monitors.

#### NumberOfCalls

Data Type: Integer
Description: The total number of voice calls made by the customer during the period.
How It’s Measured: Recorded from call detail records (CDRs) using telephony systems like those from Avaya or Ericsson.


#### NumberOfTexts

Data Type: Integer
Description: The total count of SMS messages sent by the customer in the period.
How It’s Measured: Captured via messaging logs maintained by telecom platforms (often part of the same CDR systems).

#### SessionDuration

Data Type: Decimal (Seconds)
Description: The duration for which a customer was actively connected to the network.
How It’s Measured: Determined by measuring the time from session initiation to termination, using session management systems integrated in the network (e.g., via Cisco Call Manager).

#### CustomerSatisfaction

Data Type: Decimal (Scale 1–5)
Description: A rating reflecting the customer’s satisfaction with the network service.
How It’s Measured: Typically collected via surveys using tools like SurveyMonkey, Qualtrics, or Google Forms.

#### ChurnRiskIndicator

Data Type: Decimal (Percentage or Score)
Description: A predictive metric indicating the likelihood that a customer might cancel the service.
How It’s Measured: Calculated using predictive analytics platforms (such as SAS, IBM SPSS, or Python’s scikit-learn) based on usage and behavioral patterns.

#### ARPU (Average Revenue Per User)

Data Type: Decimal (Monetary Value)
Description: The average revenue generated from each customer during the measurement period.
How It’s Measured: Computed from billing systems like Oracle BRM or SAP ERP by dividing total revenue by the number of active customers.

#### ComplaintRate

Data Type: Decimal (Percentage or Count)
Description: The frequency at which customers file complaints regarding the network service.
How It’s Measured: Derived from customer service platforms like Zendesk or ServiceNow, which log customer interactions and complaints.

#### ServiceActivationCount

Data Type: Integer
Description: The number of times a new service was activated for a customer.
How It’s Measured: Logged by service provisioning systems such as Salesforce Service Cloud or Oracle Service Cloud.

#### ServiceDeactivationCount

Data Type: Integer
Description: The count of service cancellations or deactivations.
How It’s Measured: Recorded by the same service management systems (e.g., ServiceNow) when a customer cancels a service.

#### HandlingTime

Data Type: Decimal (Minutes)
Description: The average time taken by customer support to resolve issues.
How It’s Measured: Calculated from customer service call logs or support ticket systems (for example, Genesys or Five9).

#### NPS (Net Promoter Score)

Data Type: Decimal
Description: A metric indicating customer loyalty by measuring how likely customers are to recommend the service to others.
How It’s Measured: Collected via surveys using tools like Medallia or Promoter.io, then computed by subtracting the percentage of detractors from promoters.

#### Revenue

Data Type: Decimal (Monetary Value)
Description: The total revenue generated from the customer during the measurement period.
How It’s Measured: Aggregated from financial or billing systems such as Oracle Financials or SAP ERP.
