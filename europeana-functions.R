queries_per_day_and_hour_lastweek <- function(records) {
  daylevels <- sort(levels(records$day))
  lastWeek <- records[(records$day %in% daylevels[(length(daylevels)-7):length(daylevels)]),]
  queries_per_day_and_hour(lastWeek, "lastweek_queries_per_day_and_hour.png")
}

queries_per_hour <- function(records, filename="queries_per_hour.png") {
  hours <- table(records$server, records$hour)
  hours <- floor(hours/1000)
  solr10 <- hours[1,]
  solr11 <- hours[2,]
  solr12 <- hours[3,]
  solr13 <- hours[4,]

  png(file=filename)
  g_range <- range(0, solr10, solr11, solr12, solr13)
  plot(solr10, type="o", ylim=g_range, col="blue", xlab="hours (0-24)", ylab="number of queries (1000s)")
  lines(solr11, type="o", col="red")
  lines(solr12, type="o", col="black")
  lines(solr13, type="o", col="green")
  title(main="Queries running in four Europeana Solr servers", col.main="red", font.main=4)
  legend(1, g_range[2], c("solr10", "solr11", "solr12", "solr13"), cex=0.8, col=c("blue", "red", "black", "green"), pch=21:22, lty=1:2);
  dev.off()
}

queries_per_day <- function(records, filename="queries_per_day.png") {
  days <- table(records$server, records$day)
  days <- floor(days/1000)
  solr10 <- days[1,]
  solr11 <- days[2,]
  solr12 <- days[3,]
  solr13 <- days[4,]

  png(file=filename)
  g_range <- range(0, solr10, solr11, solr12, solr13)
  plot(solr10, type="o", ylim=g_range, col="blue", xlab="days from 2014-05-28", ylab="number of queries (1000s)")
  lines(solr11, type="o", col="red")
  lines(solr12, type="o", col="black")
  lines(solr13, type="o", col="green")
  title(main="Queries running in four Europeana Solr servers", col.main="red", font.main=4)
  legend(1, g_range[2], c("solr10", "solr11", "solr12", "solr13"), cex=0.8, col=c("blue", "red", "black", "green"), pch=21:22, lty=1:2);
  dev.off()
}

queries_per_day_and_hour <- function(records, filename="queries_per_day_and_hour.png") {
  records$dayhour <- factor(records$dayhour)
  dayhour <- table(records$server, records$dayhour)
  dayhour <- dayhour/1000
  solr10 <- dayhour[1,]
  solr11 <- dayhour[2,]
  solr12 <- dayhour[3,]
  solr13 <- dayhour[4,]
  humans <- solr11 + solr12 + solr13
  totals <- solr10 + humans
  dlabels <- labels(dayhour)
  ticks <- ((seq(1:(ceiling(length(dlabels[[2]])/24)))-1)*24)+1
  axislabels <- sapply(dlabels[[2]][ticks], function(x) substr(x, 1, 5))

  png(file=filename, width=1500, height=1000)
  g_range <- range(0, solr10, solr11, solr12, solr13, humans, totals)
  plot(totals, type="o", ylim=g_range, col="grey", xlab="Hourly usage during the last weeks", ylab="number of queries per hour (1000s)", xaxt='n')
  lines(solr10, type="o", col="blue")
  lines(solr11, type="o", col="red")
  lines(solr12, type="o", col="black")
  lines(solr13, type="o", col="green")
  lines(humans, type="o", col="orange")
  abline(h = 0:ceiling(g_range[2]), v = seq(0:length(dlabels[[2]])), col = "lightgray", lty=3)
  title(main="Hourly number of queries running in four Europeana Solr servers", col.main="red", font.main=4)
  legend(1, g_range[2], c("solr10", "solr11", "solr12", "solr13", "humans", "totals"), cex=0.8, col=c("blue", "red", "black", "green", "orange", "grey"), pch=21:22, lty=1:2);
  axis(1, at=ticks, lab=axislabels)
  dev.off()
}
