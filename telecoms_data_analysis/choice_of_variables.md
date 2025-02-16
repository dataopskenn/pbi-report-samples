# Choice of Variables
The variables selected in the FactTable are representative of both network performance and customer engagement:

## Network Performance Metrics:
Latency, Throughput, CallDropRate, SignalStrength, DataErrorRate, PacketLoss, Jitter, NetworkAvailability, Uptime, Downtime
These variables capture how well the network is performing. For instance, high latency or call drop rate typically correlates with poor service quality.

## Customer Engagement Metrics:
DataUsage, NumberOfCalls, NumberOfTexts, SessionDuration, CustomerSatisfaction, ChurnRiskIndicator, ARPU, ComplaintRate, Revenue, NPS
These reflect how customers interact with the service and their overall satisfaction. They are critical for understanding user experience and financial performance.

## Other Variables:
CustomerID, TimeID, LocationID, NetworkTypeID, CustomerSegmentID
These serve as keys linking the fact data to various dimensions (e.g., time, location), enabling segmentation and more detailed analyses.
