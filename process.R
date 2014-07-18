data <- read.csv("solr-log-entries.csv", header=TRUE)
data$server <- factor(data$server)
data$day <- factor(data$day)
data$hour <- factor(data$hour)
data$status <- factor(data$status)
data$dayhour <- sprintf("%s-%02d", data$day, data$hour)
data$dayhour <- factor(data$dayhour)

png(file="hist.png")
plot(data$server, data$day)
dev.off()

queries_per_day(data, "queries_per_day.png")
queries_per_hour(data, "queries_per_hour.png")
queries_per_day_and_hour(data, "all_queries_per_day_and_hour.png")
queries_per_day_and_hour_lastweek(data)

